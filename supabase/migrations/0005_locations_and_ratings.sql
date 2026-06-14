-- ============================================================================
-- 0005_locations_and_ratings.sql
-- High-volume GPS breadcrumb trail (driver_locations) + passenger→driver
-- ratings, with automatic recomputation of the driver's average.
-- ============================================================================

create table public.driver_locations (
  id          bigint generated always as identity primary key,
  driver_id   uuid not null references public.drivers (profile_id) on delete cascade,
  trip_id     uuid references public.trips (id) on delete set null,
  latitude    double precision not null,
  longitude   double precision not null,
  location    geography(Point, 4326)
    generated always as (st_setsrid(st_makepoint(longitude, latitude), 4326)::geography) stored,
  heading     numeric(5, 2),   -- degrees 0-360
  speed       numeric(6, 2),   -- km/h
  accuracy    numeric(6, 2),   -- metres
  recorded_at timestamptz not null default now()
);

comment on table public.driver_locations is
  'Historical GPS breadcrumb trail. High write volume — consider monthly range partitioning on recorded_at and a retention/archival policy at scale.';

-- Latest-fix lookups per driver, and per-trip route playback.
create index idx_driver_locations_driver on public.driver_locations (driver_id, recorded_at desc);
create index idx_driver_locations_trip   on public.driver_locations (trip_id, recorded_at);
create index idx_driver_locations_gist   on public.driver_locations using gist (location);

alter table public.driver_locations enable row level security;

-- Drivers write only their own fixes.
create policy "driver_locations_insert_self"
  on public.driver_locations for insert
  with check (driver_id = auth.uid());

create policy "driver_locations_select_self"
  on public.driver_locations for select
  using (driver_id = auth.uid());

create policy "driver_locations_select_admin"
  on public.driver_locations for select
  using (public.is_admin());

-- A passenger may follow the driver assigned to their active trip.
create policy "driver_locations_select_active_passenger"
  on public.driver_locations for select
  using (
    exists (
      select 1 from public.trips t
      where t.driver_id = driver_locations.driver_id
        and t.passenger_id = auth.uid()
        and t.status in ('accepted', 'arrived', 'in_progress')
    )
  );


-- ============================================================================
-- ratings  (passenger rates the driver after a completed trip)
-- ============================================================================
create table public.ratings (
  id           uuid primary key default gen_random_uuid(),
  trip_id      uuid not null unique references public.trips (id) on delete cascade,
  passenger_id uuid not null references public.profiles (id) on delete cascade,
  driver_id    uuid not null references public.drivers (profile_id) on delete cascade,
  rating       smallint not null check (rating between 1 and 5),
  review       text,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

comment on table public.ratings is
  'One passenger→driver rating per trip (1–5 + optional review). Drives the driver aggregate rating.';

create index idx_ratings_driver    on public.ratings (driver_id);
create index idx_ratings_passenger on public.ratings (passenger_id);

create trigger trg_ratings_updated_at
  before update on public.ratings
  for each row execute function public.set_updated_at();

-- Recompute the driver's average rating and rating count on any change.
create or replace function public.recompute_driver_rating()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_driver uuid := coalesce(new.driver_id, old.driver_id);
begin
  update public.drivers d
    set rating = coalesce(
          (select round(avg(r.rating)::numeric, 2) from public.ratings r where r.driver_id = v_driver),
          0),
        total_ratings = (select count(*) from public.ratings r where r.driver_id = v_driver)
  where d.profile_id = v_driver;
  return null;
end;
$$;

create trigger trg_ratings_recompute
  after insert or update or delete on public.ratings
  for each row execute function public.recompute_driver_rating();

alter table public.ratings enable row level security;

-- Ratings are public (transparency), so passengers can compare drivers.
create policy "ratings_select_all_authenticated"
  on public.ratings for select
  to authenticated
  using (true);

-- Only the passenger who took the completed trip may rate it.
create policy "ratings_insert_passenger"
  on public.ratings for insert
  with check (
    passenger_id = auth.uid()
    and exists (
      select 1 from public.trips t
      where t.id = ratings.trip_id
        and t.passenger_id = auth.uid()
        and t.driver_id = ratings.driver_id
        and t.status = 'completed'
    )
  );

create policy "ratings_update_own"
  on public.ratings for update
  using (passenger_id = auth.uid())
  with check (passenger_id = auth.uid());

create policy "ratings_delete_own"
  on public.ratings for delete
  using (passenger_id = auth.uid());

create policy "ratings_admin_all"
  on public.ratings for all
  using (public.is_admin())
  with check (public.is_admin());
