-- ============================================================================
-- 0004_trips_and_history.sql
-- The central transactional table (trips) + an append-only audit of every
-- status change (trip_status_history).
-- ============================================================================

create table public.trips (
  id                    uuid primary key default gen_random_uuid(),
  passenger_id          uuid not null references public.profiles (id) on delete restrict,
  driver_id             uuid references public.drivers (profile_id) on delete set null,

  -- Pickup / destination (addresses + coordinates from Google Maps).
  pickup_address        text not null,
  destination_address   text not null,
  pickup_latitude       double precision not null,
  pickup_longitude      double precision not null,
  destination_latitude  double precision not null,
  destination_longitude double precision not null,
  pickup_location       geography(Point, 4326)
    generated always as (st_setsrid(st_makepoint(pickup_longitude, pickup_latitude), 4326)::geography) stored,
  destination_location  geography(Point, 4326)
    generated always as (st_setsrid(st_makepoint(destination_longitude, destination_latitude), 4326)::geography) stored,

  status                public.trip_status not null default 'requested',

  -- Estimates & pricing.
  estimated_distance    numeric(8, 2),   -- kilometres
  estimated_duration    integer,         -- minutes
  trip_price            numeric(10, 2),
  payment_method        public.payment_method not null default 'cash',

  -- Cancellation metadata.
  cancellation_reason   text,
  cancelled_by          public.actor_type,

  -- Lifecycle timestamps (maintained by trigger below).
  accepted_at           timestamptz,
  started_at            timestamptz,
  completed_at          timestamptz,
  cancelled_at          timestamptz,
  created_at            timestamptz not null default now(),
  updated_at            timestamptz not null default now(),

  constraint chk_trip_price_positive check (trip_price is null or trip_price >= 0)
);

comment on table  public.trips is
  'A ride request and its full lifecycle from requested → completed/cancelled.';
comment on column public.trips.driver_id  is 'The chosen/assigned driver. Null until set; SET NULL if the driver is deleted (history preserved).';
comment on column public.trips.status     is 'State machine: requested→accepted→arrived→in_progress→completed (or rejected/cancelled/expired).';

-- Indexes ---------------------------------------------------------------------
create index idx_trips_passenger     on public.trips (passenger_id);
create index idx_trips_driver        on public.trips (driver_id);
create index idx_trips_status        on public.trips (status);
create index idx_trips_created_at    on public.trips (created_at desc);
-- Driver's active board / dispatch lookups.
create index idx_trips_driver_status on public.trips (driver_id, status);
-- Open requests still looking for a driver.
create index idx_trips_open
  on public.trips (created_at)
  where status = 'requested';

create trigger trg_trips_updated_at
  before update on public.trips
  for each row execute function public.set_updated_at();

-- Stamp lifecycle timestamps automatically when status changes.
create or replace function public.handle_trip_status_timestamps()
returns trigger
language plpgsql
as $$
begin
  if tg_op = 'UPDATE' and new.status is distinct from old.status then
    case new.status
      when 'accepted'    then new.accepted_at  := coalesce(new.accepted_at, now());
      when 'in_progress' then new.started_at    := coalesce(new.started_at, now());
      when 'completed'   then new.completed_at  := coalesce(new.completed_at, now());
      when 'cancelled'   then new.cancelled_at  := coalesce(new.cancelled_at, now());
      when 'rejected'    then new.cancelled_at  := coalesce(new.cancelled_at, now());
      when 'expired'     then new.cancelled_at  := coalesce(new.cancelled_at, now());
      else null;
    end case;
  end if;
  return new;
end;
$$;

create trigger trg_trips_status_timestamps
  before update on public.trips
  for each row execute function public.handle_trip_status_timestamps();

-- ============================================================================
-- trip_status_history  (append-only audit log)
-- ============================================================================
create table public.trip_status_history (
  id          bigint generated always as identity primary key,
  trip_id     uuid not null references public.trips (id) on delete cascade,
  status      public.trip_status not null,
  changed_by  uuid references public.profiles (id),
  note        text,
  created_at  timestamptz not null default now()
);

comment on table public.trip_status_history is
  'Immutable timeline of every status a trip passed through, for tracking & disputes.';

create index idx_trip_history_trip on public.trip_status_history (trip_id, created_at);

-- Record every status transition + bump driver totals on completion.
create or replace function public.log_trip_status_change()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if tg_op = 'INSERT' then
    insert into public.trip_status_history (trip_id, status, changed_by)
    values (new.id, new.status, new.passenger_id);

  elsif new.status is distinct from old.status then
    insert into public.trip_status_history (trip_id, status, changed_by, note)
    values (new.id, new.status, auth.uid(), new.cancellation_reason);

    -- Maintain the driver's completed-trip counter.
    if new.status = 'completed' and new.driver_id is not null then
      update public.drivers
        set total_trips = total_trips + 1
        where profile_id = new.driver_id;
    end if;
  end if;
  return new;
end;
$$;

create trigger trg_trips_log_status
  after insert or update on public.trips
  for each row execute function public.log_trip_status_change();

-- RLS: trips ------------------------------------------------------------------
alter table public.trips enable row level security;

create policy "trips_select_participant"
  on public.trips for select
  using (passenger_id = auth.uid() or driver_id = auth.uid());

create policy "trips_select_admin"
  on public.trips for select
  using (public.is_admin());

-- A passenger creates a trip for themselves.
create policy "trips_insert_passenger"
  on public.trips for insert
  with check (passenger_id = auth.uid() and status = 'requested');

-- Both participants may update the trip (status transitions enforced in app /
-- edge functions); admins may update anything.
create policy "trips_update_participant"
  on public.trips for update
  using (passenger_id = auth.uid() or driver_id = auth.uid())
  with check (passenger_id = auth.uid() or driver_id = auth.uid());

create policy "trips_update_admin"
  on public.trips for update
  using (public.is_admin())
  with check (public.is_admin());

-- RLS: trip_status_history (read-only to clients; rows written by trigger) ----
alter table public.trip_status_history enable row level security;

create policy "trip_history_select_participant"
  on public.trip_status_history for select
  using (
    exists (
      select 1 from public.trips t
      where t.id = trip_status_history.trip_id
        and (t.passenger_id = auth.uid() or t.driver_id = auth.uid())
    )
  );

create policy "trip_history_select_admin"
  on public.trip_status_history for select
  using (public.is_admin());
