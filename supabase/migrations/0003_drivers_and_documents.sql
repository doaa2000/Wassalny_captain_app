-- ============================================================================
-- 0003_drivers_and_documents.sql
-- Driver (Captain) profile extension + KYC documents.
-- A driver row is created on registration and stays `pending` until an admin
-- approves it; only approved drivers are visible to passengers.
-- ============================================================================

create table public.drivers (
  profile_id        uuid primary key references public.profiles (id) on delete cascade,
  vehicle_type      public.vehicle_type not null default 'economy',
  vehicle_model     text,
  vehicle_color     text,
  vehicle_year      smallint,
  plate_number      text unique,
  national_id       text unique,
  license_number    text,
  approval_status   public.approval_status not null default 'pending',
  online_status     public.online_status   not null default 'offline',
  current_latitude  double precision,
  current_longitude double precision,
  -- Generated geography point for fast spatial "nearby" queries (WGS84).
  current_location  geography(Point, 4326)
    generated always as (
      case
        when current_latitude is not null and current_longitude is not null
        then st_setsrid(st_makepoint(current_longitude, current_latitude), 4326)::geography
      end
    ) stored,
  rating            numeric(3, 2) not null default 0.00 check (rating between 0 and 5),
  total_ratings     integer not null default 0,
  total_trips       integer not null default 0,
  rejection_reason  text,
  approved_by       uuid references public.profiles (id),
  approved_at       timestamptz,
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now()
);

comment on table  public.drivers is
  'Driver-specific data (1:1 with a profile whose role = driver). Holds vehicle, KYC and live availability/location.';
comment on column public.drivers.approval_status is 'pending | approved | rejected | suspended. Gates visibility to passengers.';
comment on column public.drivers.online_status  is 'offline | online | on_trip. Only online & approved drivers receive requests.';
comment on column public.drivers.current_location is 'Auto-derived PostGIS point used for nearby-driver search (GiST indexed).';

-- Indexes ---------------------------------------------------------------------
create index idx_drivers_approval        on public.drivers (approval_status);
create index idx_drivers_online          on public.drivers (online_status);
create index idx_drivers_rating          on public.drivers (rating desc);
-- Hot path: "approved + online" drivers near a point.
create index idx_drivers_dispatch        on public.drivers (approval_status, online_status);
create index idx_drivers_location_gist   on public.drivers using gist (current_location);

create trigger trg_drivers_updated_at
  before update on public.drivers
  for each row execute function public.set_updated_at();

-- Protect admin-only / system-only columns from being changed by the driver.
create or replace function public.guard_driver_columns()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  -- Restrict only end-user (JWT) requests; null auth.uid() = trusted server.
  if auth.uid() is not null and not public.is_admin() then
    if new.approval_status is distinct from old.approval_status
       or new.rating        is distinct from old.rating
       or new.total_ratings is distinct from old.total_ratings
       or new.total_trips   is distinct from old.total_trips
       or new.approved_by   is distinct from old.approved_by then
      raise exception 'These driver fields can only be modified by an admin or the system';
    end if;
  end if;
  return new;
end;
$$;

create trigger trg_drivers_guard_columns
  before update on public.drivers
  for each row execute function public.guard_driver_columns();

-- RLS -------------------------------------------------------------------------
alter table public.drivers enable row level security;

create policy "drivers_select_self"
  on public.drivers for select
  using (profile_id = auth.uid());

create policy "drivers_select_admin"
  on public.drivers for select
  using (public.is_admin());

-- Passengers (any authenticated user) may browse approved drivers.
create policy "drivers_select_approved"
  on public.drivers for select
  using (approval_status = 'approved');

-- A driver creates only their own row.
create policy "drivers_insert_self"
  on public.drivers for insert
  with check (profile_id = auth.uid());

create policy "drivers_update_self"
  on public.drivers for update
  using (profile_id = auth.uid())
  with check (profile_id = auth.uid());

create policy "drivers_update_admin"
  on public.drivers for update
  using (public.is_admin())
  with check (public.is_admin());

-- Now that drivers exists, allow anyone authenticated to read the profile rows
-- of approved drivers (so passengers can see a driver's name & photo).
create policy "profiles_select_approved_drivers"
  on public.profiles for select
  using (
    exists (
      select 1 from public.drivers d
      where d.profile_id = profiles.id
        and d.approval_status = 'approved'
    )
  );


-- ============================================================================
-- driver_documents
-- ============================================================================
create table public.driver_documents (
  id                  uuid primary key default gen_random_uuid(),
  driver_id           uuid not null references public.drivers (profile_id) on delete cascade,
  document_type       public.document_type not null,
  document_url        text not null,
  verification_status public.verification_status not null default 'pending',
  rejection_reason    text,
  reviewed_by         uuid references public.profiles (id),
  reviewed_at         timestamptz,
  expires_at          date,
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now(),
  unique (driver_id, document_type)   -- one document per type per driver
);

comment on table public.driver_documents is
  'KYC documents uploaded by drivers and reviewed by admins. Files live in the private driver-documents storage bucket; this stores their paths and review state.';

create index idx_driver_documents_driver on public.driver_documents (driver_id);
create index idx_driver_documents_status on public.driver_documents (verification_status);

create trigger trg_driver_documents_updated_at
  before update on public.driver_documents
  for each row execute function public.set_updated_at();

alter table public.driver_documents enable row level security;

create policy "driver_documents_owner_select"
  on public.driver_documents for select
  using (driver_id = auth.uid());

create policy "driver_documents_admin_select"
  on public.driver_documents for select
  using (public.is_admin());

create policy "driver_documents_owner_write"
  on public.driver_documents for insert
  with check (driver_id = auth.uid());

create policy "driver_documents_owner_update"
  on public.driver_documents for update
  using (driver_id = auth.uid())
  with check (driver_id = auth.uid());

create policy "driver_documents_admin_update"
  on public.driver_documents for update
  using (public.is_admin())
  with check (public.is_admin());

create policy "driver_documents_owner_delete"
  on public.driver_documents for delete
  using (driver_id = auth.uid());


-- ============================================================================
-- passenger_favorites  (passengers save preferred drivers)
-- ============================================================================
create table public.passenger_favorites (
  id                uuid primary key default gen_random_uuid(),
  passenger_id      uuid not null references public.profiles (id) on delete cascade,
  favorite_driver_id uuid not null references public.drivers (profile_id) on delete cascade,
  created_at        timestamptz not null default now(),
  unique (passenger_id, favorite_driver_id)
);

comment on table public.passenger_favorites is
  'Many-to-many: passengers bookmarking drivers they prefer to ride with.';

create index idx_favorites_passenger on public.passenger_favorites (passenger_id);
create index idx_favorites_driver    on public.passenger_favorites (favorite_driver_id);

alter table public.passenger_favorites enable row level security;

create policy "favorites_owner_all"
  on public.passenger_favorites for all
  using (passenger_id = auth.uid())
  with check (passenger_id = auth.uid());

create policy "favorites_admin_select"
  on public.passenger_favorites for select
  using (public.is_admin());
