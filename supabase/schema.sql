-- ============================================================================
-- Wassalny — complete database schema (single, ordered, idempotent script).
--
-- Paste this whole file into the Supabase SQL Editor and Run, OR:
--   psql "$DATABASE_URL" -f supabase/schema.sql
--
-- It is safe to run more than once. Sections are globally ordered so there are
-- no forward references: extensions → types → tables → indexes → functions →
-- triggers → RLS policies → storage.
-- ============================================================================

-- ─────────────────────────────────────────────────────────────────────────────
-- 1. EXTENSIONS
-- ─────────────────────────────────────────────────────────────────────────────
create extension if not exists "pgcrypto";
create extension if not exists "postgis";

-- ─────────────────────────────────────────────────────────────────────────────
-- 2. ENUM TYPES  (guarded so re-running does not error)
-- ─────────────────────────────────────────────────────────────────────────────
do $$ begin create type public.user_role          as enum ('admin','passenger','driver'); exception when duplicate_object then null; end $$;
do $$ begin create type public.approval_status    as enum ('pending','approved','rejected','suspended'); exception when duplicate_object then null; end $$;
do $$ begin create type public.online_status      as enum ('offline','online','on_trip'); exception when duplicate_object then null; end $$;
do $$ begin create type public.vehicle_type       as enum ('economy','comfort','suv','van','motorbike'); exception when duplicate_object then null; end $$;
do $$ begin create type public.document_type      as enum ('national_id','driver_license','vehicle_registration','vehicle_insurance','vehicle_photo','profile_photo'); exception when duplicate_object then null; end $$;
do $$ begin create type public.verification_status as enum ('pending','verified','rejected'); exception when duplicate_object then null; end $$;
do $$ begin create type public.trip_status        as enum ('requested','accepted','arrived','in_progress','completed','rejected','cancelled','expired'); exception when duplicate_object then null; end $$;
do $$ begin create type public.actor_type         as enum ('passenger','driver','admin','system'); exception when duplicate_object then null; end $$;
do $$ begin create type public.payment_method     as enum ('cash','wallet','card'); exception when duplicate_object then null; end $$;
do $$ begin create type public.notification_type  as enum ('trip_request','trip_accepted','trip_arrived','trip_started','trip_completed','trip_cancelled','driver_approved','driver_rejected','document_verified','payment','promo','system'); exception when duplicate_object then null; end $$;

-- ─────────────────────────────────────────────────────────────────────────────
-- 3. TABLES
-- ─────────────────────────────────────────────────────────────────────────────

-- profiles : master identity (1:1 with auth.users)
create table if not exists public.profiles (
  id            uuid primary key references auth.users (id) on delete cascade,
  role          public.user_role not null default 'passenger',
  full_name     text,
  phone         text unique,
  profile_image text,
  is_active     boolean not null default true,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);
comment on table public.profiles is 'Master account record (1:1 with auth.users) shared by all roles.';

-- drivers : captain profile extension (1:1 with a driver profile)
create table if not exists public.drivers (
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
  current_location  geography(Point, 4326) generated always as (
    case when current_latitude is not null and current_longitude is not null
    then st_setsrid(st_makepoint(current_longitude, current_latitude), 4326)::geography end) stored,
  rating            numeric(3,2) not null default 0 check (rating between 0 and 5),
  total_ratings     integer not null default 0,
  total_trips       integer not null default 0,
  rejection_reason  text,
  approved_by       uuid references public.profiles (id),
  approved_at       timestamptz,
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now()
);
comment on table public.drivers is 'Driver vehicle/KYC data, approval status and live availability/location.';

-- driver_documents : KYC docs (one per type per driver)
create table if not exists public.driver_documents (
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
  unique (driver_id, document_type)
);
comment on table public.driver_documents is 'Driver KYC documents reviewed by admins.';

-- passenger_favorites : bookmarked drivers
create table if not exists public.passenger_favorites (
  id                 uuid primary key default gen_random_uuid(),
  passenger_id       uuid not null references public.profiles (id) on delete cascade,
  favorite_driver_id uuid not null references public.drivers (profile_id) on delete cascade,
  created_at         timestamptz not null default now(),
  unique (passenger_id, favorite_driver_id)
);
comment on table public.passenger_favorites is 'Passengers'' preferred drivers (M:N).';

-- trips : the central transactional table
create table if not exists public.trips (
  id                    uuid primary key default gen_random_uuid(),
  passenger_id          uuid not null references public.profiles (id) on delete restrict,
  driver_id             uuid references public.drivers (profile_id) on delete set null,
  pickup_address        text not null,
  destination_address   text not null,
  pickup_latitude       double precision not null,
  pickup_longitude      double precision not null,
  destination_latitude  double precision not null,
  destination_longitude double precision not null,
  pickup_location       geography(Point,4326) generated always as (st_setsrid(st_makepoint(pickup_longitude, pickup_latitude),4326)::geography) stored,
  destination_location  geography(Point,4326) generated always as (st_setsrid(st_makepoint(destination_longitude, destination_latitude),4326)::geography) stored,
  status                public.trip_status not null default 'requested',
  estimated_distance    numeric(8,2),
  estimated_duration    integer,
  trip_price            numeric(10,2),
  payment_method        public.payment_method not null default 'cash',
  cancellation_reason   text,
  cancelled_by          public.actor_type,
  accepted_at           timestamptz,
  started_at            timestamptz,
  completed_at          timestamptz,
  cancelled_at          timestamptz,
  created_at            timestamptz not null default now(),
  updated_at            timestamptz not null default now(),
  constraint chk_trip_price_positive check (trip_price is null or trip_price >= 0)
);
comment on table public.trips is 'Ride requests and their full lifecycle.';

-- trip_status_history : append-only audit of status changes
create table if not exists public.trip_status_history (
  id         bigint generated always as identity primary key,
  trip_id    uuid not null references public.trips (id) on delete cascade,
  status     public.trip_status not null,
  changed_by uuid references public.profiles (id),
  note       text,
  created_at timestamptz not null default now()
);
comment on table public.trip_status_history is 'Immutable timeline of trip status transitions.';

-- driver_locations : high-volume GPS breadcrumb trail
create table if not exists public.driver_locations (
  id          bigint generated always as identity primary key,
  driver_id   uuid not null references public.drivers (profile_id) on delete cascade,
  trip_id     uuid references public.trips (id) on delete set null,
  latitude    double precision not null,
  longitude   double precision not null,
  location    geography(Point,4326) generated always as (st_setsrid(st_makepoint(longitude, latitude),4326)::geography) stored,
  heading     numeric(5,2),
  speed       numeric(6,2),
  accuracy    numeric(6,2),
  recorded_at timestamptz not null default now()
);
comment on table public.driver_locations is 'Historical GPS fixes; consider partitioning by recorded_at at scale.';

-- ratings : passenger → driver, one per trip
create table if not exists public.ratings (
  id           uuid primary key default gen_random_uuid(),
  trip_id      uuid not null unique references public.trips (id) on delete cascade,
  passenger_id uuid not null references public.profiles (id) on delete cascade,
  driver_id    uuid not null references public.drivers (profile_id) on delete cascade,
  rating       smallint not null check (rating between 1 and 5),
  review       text,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);
comment on table public.ratings is 'Passenger rating of a driver after a completed trip.';

-- notifications
create table if not exists public.notifications (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references public.profiles (id) on delete cascade,
  type       public.notification_type not null,
  title      text not null,
  body       text,
  data       jsonb not null default '{}'::jsonb,
  is_read    boolean not null default false,
  read_at    timestamptz,
  created_at timestamptz not null default now()
);
comment on table public.notifications is 'Per-recipient in-app notifications.';

-- admin_logs
create table if not exists public.admin_logs (
  id           uuid primary key default gen_random_uuid(),
  admin_id     uuid references public.profiles (id) on delete set null,
  action       text not null,
  target_table text,
  target_id    uuid,
  description  text,
  metadata     jsonb not null default '{}'::jsonb,
  ip_address   inet,
  created_at   timestamptz not null default now()
);
comment on table public.admin_logs is 'Immutable audit trail of admin actions.';

-- ─────────────────────────────────────────────────────────────────────────────
-- 4. INDEXES
-- ─────────────────────────────────────────────────────────────────────────────
create index if not exists idx_profiles_role            on public.profiles (role);
create index if not exists idx_drivers_approval         on public.drivers (approval_status);
create index if not exists idx_drivers_online           on public.drivers (online_status);
create index if not exists idx_drivers_rating           on public.drivers (rating desc);
create index if not exists idx_drivers_dispatch         on public.drivers (approval_status, online_status);
create index if not exists idx_drivers_location_gist    on public.drivers using gist (current_location);
create index if not exists idx_driver_documents_driver  on public.driver_documents (driver_id);
create index if not exists idx_driver_documents_status  on public.driver_documents (verification_status);
create index if not exists idx_favorites_passenger      on public.passenger_favorites (passenger_id);
create index if not exists idx_favorites_driver         on public.passenger_favorites (favorite_driver_id);
create index if not exists idx_trips_passenger          on public.trips (passenger_id);
create index if not exists idx_trips_driver             on public.trips (driver_id);
create index if not exists idx_trips_status             on public.trips (status);
create index if not exists idx_trips_created_at         on public.trips (created_at desc);
create index if not exists idx_trips_driver_status      on public.trips (driver_id, status);
create index if not exists idx_trips_open               on public.trips (created_at) where status = 'requested';
create index if not exists idx_trip_history_trip        on public.trip_status_history (trip_id, created_at);
create index if not exists idx_driver_locations_driver  on public.driver_locations (driver_id, recorded_at desc);
create index if not exists idx_driver_locations_trip    on public.driver_locations (trip_id, recorded_at);
create index if not exists idx_driver_locations_gist    on public.driver_locations using gist (location);
create index if not exists idx_ratings_driver           on public.ratings (driver_id);
create index if not exists idx_ratings_passenger        on public.ratings (passenger_id);
create index if not exists idx_notifications_user_unread on public.notifications (user_id, is_read, created_at desc);
create index if not exists idx_admin_logs_admin         on public.admin_logs (admin_id, created_at desc);
create index if not exists idx_admin_logs_target        on public.admin_logs (target_table, target_id);

-- ─────────────────────────────────────────────────────────────────────────────
-- 5. FUNCTIONS  (defined AFTER tables, so SQL bodies validate)
-- ─────────────────────────────────────────────────────────────────────────────
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at := now(); return new; end; $$;

create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.profiles where id = auth.uid() and role = 'admin');
$$;

create or replace function public.current_user_role()
returns public.user_role language sql stable security definer set search_path = public as $$
  select role from public.profiles where id = auth.uid();
$$;

create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, role, full_name, phone)
  values (new.id,
          coalesce((new.raw_user_meta_data ->> 'role')::public.user_role, 'passenger'),
          new.raw_user_meta_data ->> 'full_name',
          coalesce(new.phone, new.raw_user_meta_data ->> 'phone'))
  on conflict (id) do nothing;
  return new;
end; $$;

create or replace function public.guard_profile_role()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  if new.role is distinct from old.role and not public.is_admin() then
    raise exception 'Only admins can change a profile role';
  end if;
  return new;
end; $$;

create or replace function public.guard_driver_columns()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  if not public.is_admin() then
    if new.approval_status is distinct from old.approval_status
       or new.rating is distinct from old.rating
       or new.total_ratings is distinct from old.total_ratings
       or new.total_trips is distinct from old.total_trips
       or new.approved_by is distinct from old.approved_by then
      raise exception 'These driver fields can only be modified by an admin or the system';
    end if;
  end if;
  return new;
end; $$;

create or replace function public.handle_trip_status_timestamps()
returns trigger language plpgsql as $$
begin
  if tg_op = 'UPDATE' and new.status is distinct from old.status then
    case new.status
      when 'accepted'    then new.accepted_at  := coalesce(new.accepted_at, now());
      when 'in_progress' then new.started_at   := coalesce(new.started_at, now());
      when 'completed'   then new.completed_at := coalesce(new.completed_at, now());
      when 'cancelled'   then new.cancelled_at := coalesce(new.cancelled_at, now());
      when 'rejected'    then new.cancelled_at := coalesce(new.cancelled_at, now());
      when 'expired'     then new.cancelled_at := coalesce(new.cancelled_at, now());
      else null;
    end case;
  end if;
  return new;
end; $$;

create or replace function public.log_trip_status_change()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  if tg_op = 'INSERT' then
    insert into public.trip_status_history (trip_id, status, changed_by)
    values (new.id, new.status, new.passenger_id);
  elsif new.status is distinct from old.status then
    insert into public.trip_status_history (trip_id, status, changed_by, note)
    values (new.id, new.status, auth.uid(), new.cancellation_reason);
    if new.status = 'completed' and new.driver_id is not null then
      update public.drivers set total_trips = total_trips + 1 where profile_id = new.driver_id;
    end if;
  end if;
  return new;
end; $$;

create or replace function public.recompute_driver_rating()
returns trigger language plpgsql security definer set search_path = public as $$
declare v_driver uuid := coalesce(new.driver_id, old.driver_id);
begin
  update public.drivers d
    set rating = coalesce((select round(avg(r.rating)::numeric,2) from public.ratings r where r.driver_id = v_driver), 0),
        total_ratings = (select count(*) from public.ratings r where r.driver_id = v_driver)
  where d.profile_id = v_driver;
  return null;
end; $$;

-- RPCs ------------------------------------------------------------------------
create or replace function public.nearby_drivers(
  p_lat double precision, p_lng double precision,
  p_radius_km double precision default 5, p_vehicle_type public.vehicle_type default null)
returns table (profile_id uuid, full_name text, profile_image text,
  vehicle_type public.vehicle_type, rating numeric, total_trips integer,
  latitude double precision, longitude double precision, distance_km double precision)
language sql stable security definer set search_path = public as $$
  with origin as (select st_setsrid(st_makepoint(p_lng, p_lat), 4326)::geography as g)
  select d.profile_id, p.full_name, p.profile_image, d.vehicle_type, d.rating, d.total_trips,
         d.current_latitude, d.current_longitude,
         round((st_distance(d.current_location, origin.g)/1000)::numeric, 2)::double precision
  from public.drivers d join public.profiles p on p.id = d.profile_id cross join origin
  where d.approval_status = 'approved' and d.online_status = 'online' and d.current_location is not null
    and (p_vehicle_type is null or d.vehicle_type = p_vehicle_type)
    and st_dwithin(d.current_location, origin.g, p_radius_km * 1000)
  order by d.current_location <-> origin.g limit 30;
$$;

create or replace function public.complete_trip(p_trip_id uuid)
returns public.trips language plpgsql security definer set search_path = public as $$
declare v_trip public.trips;
begin
  update public.trips set status = 'completed'
  where id = p_trip_id and driver_id = auth.uid() and status = 'in_progress'
  returning * into v_trip;
  if not found then raise exception 'Trip % cannot be completed by the current user', p_trip_id using errcode = 'check_violation'; end if;
  return v_trip;
end; $$;

create or replace function public.set_driver_approval(p_driver_id uuid, p_status public.approval_status, p_reason text default null)
returns public.drivers language plpgsql security definer set search_path = public as $$
declare v_driver public.drivers;
begin
  if not public.is_admin() then raise exception 'Only admins can change approval status' using errcode = 'insufficient_privilege'; end if;
  update public.drivers
    set approval_status = p_status,
        rejection_reason = case when p_status = 'rejected' then p_reason else null end,
        approved_by = auth.uid(),
        approved_at = case when p_status = 'approved' then now() else approved_at end
  where profile_id = p_driver_id returning * into v_driver;
  if not found then raise exception 'Driver % not found', p_driver_id; end if;
  insert into public.admin_logs (admin_id, action, target_table, target_id, description)
  values (auth.uid(), 'driver.' || p_status::text, 'drivers', p_driver_id, p_reason);
  return v_driver;
end; $$;

grant execute on function public.nearby_drivers(double precision, double precision, double precision, public.vehicle_type) to authenticated;
grant execute on function public.complete_trip(uuid) to authenticated;
grant execute on function public.set_driver_approval(uuid, public.approval_status, text) to authenticated;

-- ─────────────────────────────────────────────────────────────────────────────
-- 6. TRIGGERS  (drop-if-exists makes this re-runnable)
-- ─────────────────────────────────────────────────────────────────────────────
drop trigger if exists trg_profiles_updated_at on public.profiles;
create trigger trg_profiles_updated_at before update on public.profiles for each row execute function public.set_updated_at();

drop trigger if exists trg_on_auth_user_created on auth.users;
create trigger trg_on_auth_user_created after insert on auth.users for each row execute function public.handle_new_user();

drop trigger if exists trg_profiles_guard_role on public.profiles;
create trigger trg_profiles_guard_role before update on public.profiles for each row execute function public.guard_profile_role();

drop trigger if exists trg_drivers_updated_at on public.drivers;
create trigger trg_drivers_updated_at before update on public.drivers for each row execute function public.set_updated_at();

drop trigger if exists trg_drivers_guard_columns on public.drivers;
create trigger trg_drivers_guard_columns before update on public.drivers for each row execute function public.guard_driver_columns();

drop trigger if exists trg_driver_documents_updated_at on public.driver_documents;
create trigger trg_driver_documents_updated_at before update on public.driver_documents for each row execute function public.set_updated_at();

drop trigger if exists trg_trips_updated_at on public.trips;
create trigger trg_trips_updated_at before update on public.trips for each row execute function public.set_updated_at();

drop trigger if exists trg_trips_status_timestamps on public.trips;
create trigger trg_trips_status_timestamps before update on public.trips for each row execute function public.handle_trip_status_timestamps();

drop trigger if exists trg_trips_log_status on public.trips;
create trigger trg_trips_log_status after insert or update on public.trips for each row execute function public.log_trip_status_change();

drop trigger if exists trg_ratings_updated_at on public.ratings;
create trigger trg_ratings_updated_at before update on public.ratings for each row execute function public.set_updated_at();

drop trigger if exists trg_ratings_recompute on public.ratings;
create trigger trg_ratings_recompute after insert or update or delete on public.ratings for each row execute function public.recompute_driver_rating();

-- ─────────────────────────────────────────────────────────────────────────────
-- 7. ROW LEVEL SECURITY + POLICIES  (all tables exist now → no forward refs)
-- ─────────────────────────────────────────────────────────────────────────────
alter table public.profiles            enable row level security;
alter table public.drivers             enable row level security;
alter table public.driver_documents    enable row level security;
alter table public.passenger_favorites enable row level security;
alter table public.trips               enable row level security;
alter table public.trip_status_history enable row level security;
alter table public.driver_locations    enable row level security;
alter table public.ratings             enable row level security;
alter table public.notifications       enable row level security;
alter table public.admin_logs          enable row level security;

-- profiles
drop policy if exists "profiles_select_self" on public.profiles;
create policy "profiles_select_self" on public.profiles for select using (id = auth.uid());
drop policy if exists "profiles_select_admin" on public.profiles;
create policy "profiles_select_admin" on public.profiles for select using (public.is_admin());
drop policy if exists "profiles_select_approved_drivers" on public.profiles;
create policy "profiles_select_approved_drivers" on public.profiles for select
  using (exists (select 1 from public.drivers d where d.profile_id = profiles.id and d.approval_status = 'approved'));
drop policy if exists "profiles_insert_self" on public.profiles;
create policy "profiles_insert_self" on public.profiles for insert with check (id = auth.uid());
drop policy if exists "profiles_update_self" on public.profiles;
create policy "profiles_update_self" on public.profiles for update using (id = auth.uid()) with check (id = auth.uid());
drop policy if exists "profiles_update_admin" on public.profiles;
create policy "profiles_update_admin" on public.profiles for update using (public.is_admin()) with check (public.is_admin());

-- drivers
drop policy if exists "drivers_select_self" on public.drivers;
create policy "drivers_select_self" on public.drivers for select using (profile_id = auth.uid());
drop policy if exists "drivers_select_admin" on public.drivers;
create policy "drivers_select_admin" on public.drivers for select using (public.is_admin());
drop policy if exists "drivers_select_approved" on public.drivers;
create policy "drivers_select_approved" on public.drivers for select using (approval_status = 'approved');
drop policy if exists "drivers_insert_self" on public.drivers;
create policy "drivers_insert_self" on public.drivers for insert with check (profile_id = auth.uid());
drop policy if exists "drivers_update_self" on public.drivers;
create policy "drivers_update_self" on public.drivers for update using (profile_id = auth.uid()) with check (profile_id = auth.uid());
drop policy if exists "drivers_update_admin" on public.drivers;
create policy "drivers_update_admin" on public.drivers for update using (public.is_admin()) with check (public.is_admin());

-- driver_documents
drop policy if exists "driver_documents_owner_select" on public.driver_documents;
create policy "driver_documents_owner_select" on public.driver_documents for select using (driver_id = auth.uid());
drop policy if exists "driver_documents_admin_select" on public.driver_documents;
create policy "driver_documents_admin_select" on public.driver_documents for select using (public.is_admin());
drop policy if exists "driver_documents_owner_write" on public.driver_documents;
create policy "driver_documents_owner_write" on public.driver_documents for insert with check (driver_id = auth.uid());
drop policy if exists "driver_documents_owner_update" on public.driver_documents;
create policy "driver_documents_owner_update" on public.driver_documents for update using (driver_id = auth.uid()) with check (driver_id = auth.uid());
drop policy if exists "driver_documents_admin_update" on public.driver_documents;
create policy "driver_documents_admin_update" on public.driver_documents for update using (public.is_admin()) with check (public.is_admin());
drop policy if exists "driver_documents_owner_delete" on public.driver_documents;
create policy "driver_documents_owner_delete" on public.driver_documents for delete using (driver_id = auth.uid());

-- passenger_favorites
drop policy if exists "favorites_owner_all" on public.passenger_favorites;
create policy "favorites_owner_all" on public.passenger_favorites for all using (passenger_id = auth.uid()) with check (passenger_id = auth.uid());
drop policy if exists "favorites_admin_select" on public.passenger_favorites;
create policy "favorites_admin_select" on public.passenger_favorites for select using (public.is_admin());

-- trips
drop policy if exists "trips_select_participant" on public.trips;
create policy "trips_select_participant" on public.trips for select using (passenger_id = auth.uid() or driver_id = auth.uid());
drop policy if exists "trips_select_admin" on public.trips;
create policy "trips_select_admin" on public.trips for select using (public.is_admin());
drop policy if exists "trips_insert_passenger" on public.trips;
create policy "trips_insert_passenger" on public.trips for insert with check (passenger_id = auth.uid() and status = 'requested');
drop policy if exists "trips_update_participant" on public.trips;
create policy "trips_update_participant" on public.trips for update using (passenger_id = auth.uid() or driver_id = auth.uid()) with check (passenger_id = auth.uid() or driver_id = auth.uid());
drop policy if exists "trips_update_admin" on public.trips;
create policy "trips_update_admin" on public.trips for update using (public.is_admin()) with check (public.is_admin());

-- trip_status_history
drop policy if exists "trip_history_select_participant" on public.trip_status_history;
create policy "trip_history_select_participant" on public.trip_status_history for select
  using (exists (select 1 from public.trips t where t.id = trip_status_history.trip_id and (t.passenger_id = auth.uid() or t.driver_id = auth.uid())));
drop policy if exists "trip_history_select_admin" on public.trip_status_history;
create policy "trip_history_select_admin" on public.trip_status_history for select using (public.is_admin());

-- driver_locations
drop policy if exists "driver_locations_insert_self" on public.driver_locations;
create policy "driver_locations_insert_self" on public.driver_locations for insert with check (driver_id = auth.uid());
drop policy if exists "driver_locations_select_self" on public.driver_locations;
create policy "driver_locations_select_self" on public.driver_locations for select using (driver_id = auth.uid());
drop policy if exists "driver_locations_select_admin" on public.driver_locations;
create policy "driver_locations_select_admin" on public.driver_locations for select using (public.is_admin());
drop policy if exists "driver_locations_select_active_passenger" on public.driver_locations;
create policy "driver_locations_select_active_passenger" on public.driver_locations for select
  using (exists (select 1 from public.trips t where t.driver_id = driver_locations.driver_id and t.passenger_id = auth.uid() and t.status in ('accepted','arrived','in_progress')));

-- ratings
drop policy if exists "ratings_select_all_authenticated" on public.ratings;
create policy "ratings_select_all_authenticated" on public.ratings for select to authenticated using (true);
drop policy if exists "ratings_insert_passenger" on public.ratings;
create policy "ratings_insert_passenger" on public.ratings for insert
  with check (passenger_id = auth.uid() and exists (select 1 from public.trips t where t.id = ratings.trip_id and t.passenger_id = auth.uid() and t.driver_id = ratings.driver_id and t.status = 'completed'));
drop policy if exists "ratings_update_own" on public.ratings;
create policy "ratings_update_own" on public.ratings for update using (passenger_id = auth.uid()) with check (passenger_id = auth.uid());
drop policy if exists "ratings_delete_own" on public.ratings;
create policy "ratings_delete_own" on public.ratings for delete using (passenger_id = auth.uid());
drop policy if exists "ratings_admin_all" on public.ratings;
create policy "ratings_admin_all" on public.ratings for all using (public.is_admin()) with check (public.is_admin());

-- notifications
drop policy if exists "notifications_select_own" on public.notifications;
create policy "notifications_select_own" on public.notifications for select using (user_id = auth.uid());
drop policy if exists "notifications_update_own" on public.notifications;
create policy "notifications_update_own" on public.notifications for update using (user_id = auth.uid()) with check (user_id = auth.uid());
drop policy if exists "notifications_select_admin" on public.notifications;
create policy "notifications_select_admin" on public.notifications for select using (public.is_admin());
drop policy if exists "notifications_insert_admin" on public.notifications;
create policy "notifications_insert_admin" on public.notifications for insert with check (public.is_admin());

-- admin_logs
drop policy if exists "admin_logs_admin_select" on public.admin_logs;
create policy "admin_logs_admin_select" on public.admin_logs for select using (public.is_admin());
drop policy if exists "admin_logs_admin_insert" on public.admin_logs;
create policy "admin_logs_admin_insert" on public.admin_logs for insert with check (public.is_admin() and admin_id = auth.uid());

-- ─────────────────────────────────────────────────────────────────────────────
-- 8. STORAGE BUCKETS + POLICIES
-- ─────────────────────────────────────────────────────────────────────────────
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('driver-documents','driver-documents',false,10485760, array['image/jpeg','image/png','image/webp','application/pdf'])
on conflict (id) do nothing;
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('profile-images','profile-images',true,5242880, array['image/jpeg','image/png','image/webp'])
on conflict (id) do nothing;
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('vehicle-photos','vehicle-photos',true,5242880, array['image/jpeg','image/png','image/webp'])
on conflict (id) do nothing;

drop policy if exists "driver_docs_owner_read" on storage.objects;
create policy "driver_docs_owner_read" on storage.objects for select
  using (bucket_id = 'driver-documents' and (storage.foldername(name))[1] = auth.uid()::text);
drop policy if exists "driver_docs_admin_read" on storage.objects;
create policy "driver_docs_admin_read" on storage.objects for select
  using (bucket_id = 'driver-documents' and public.is_admin());
drop policy if exists "driver_docs_owner_write" on storage.objects;
create policy "driver_docs_owner_write" on storage.objects for insert
  with check (bucket_id = 'driver-documents' and (storage.foldername(name))[1] = auth.uid()::text);
drop policy if exists "driver_docs_owner_modify" on storage.objects;
create policy "driver_docs_owner_modify" on storage.objects for update
  using (bucket_id = 'driver-documents' and (storage.foldername(name))[1] = auth.uid()::text);
drop policy if exists "driver_docs_owner_delete" on storage.objects;
create policy "driver_docs_owner_delete" on storage.objects for delete
  using (bucket_id = 'driver-documents' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "public_images_read" on storage.objects;
create policy "public_images_read" on storage.objects for select
  using (bucket_id in ('profile-images','vehicle-photos'));
drop policy if exists "public_images_owner_write" on storage.objects;
create policy "public_images_owner_write" on storage.objects for insert
  with check (bucket_id in ('profile-images','vehicle-photos') and (storage.foldername(name))[1] = auth.uid()::text);
drop policy if exists "public_images_owner_modify" on storage.objects;
create policy "public_images_owner_modify" on storage.objects for update
  using (bucket_id in ('profile-images','vehicle-photos') and (storage.foldername(name))[1] = auth.uid()::text);
drop policy if exists "public_images_owner_delete" on storage.objects;
create policy "public_images_owner_delete" on storage.objects for delete
  using (bucket_id in ('profile-images','vehicle-photos') and (storage.foldername(name))[1] = auth.uid()::text);

-- ============================================================================
-- Done. Verify with:  select typname from pg_type where typname = 'vehicle_type';
-- ============================================================================
