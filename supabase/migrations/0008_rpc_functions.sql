-- ============================================================================
-- 0008_rpc_functions.sql
-- Callable RPCs the apps invoke via supabase.rpc(). These keep dispatch and
-- state transitions on the server where they can be validated and indexed.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- nearby_drivers: approved + online drivers within a radius, nearest first.
-- Uses the GiST index on drivers.current_location (ST_DWithin) and KNN (<->)
-- ordering — scales to large fleets.
-- ----------------------------------------------------------------------------
create or replace function public.nearby_drivers(
  p_lat          double precision,
  p_lng          double precision,
  p_radius_km    double precision default 5,
  p_vehicle_type public.vehicle_type default null
)
returns table (
  profile_id   uuid,
  full_name    text,
  profile_image text,
  vehicle_type public.vehicle_type,
  rating       numeric,
  total_trips  integer,
  latitude     double precision,
  longitude    double precision,
  distance_km  double precision
)
language sql
stable
security definer
set search_path = public
as $$
  with origin as (
    select st_setsrid(st_makepoint(p_lng, p_lat), 4326)::geography as g
  )
  select
    d.profile_id,
    p.full_name,
    p.profile_image,
    d.vehicle_type,
    d.rating,
    d.total_trips,
    d.current_latitude,
    d.current_longitude,
    round((st_distance(d.current_location, origin.g) / 1000)::numeric, 2)::double precision
  from public.drivers d
  join public.profiles p on p.id = d.profile_id
  cross join origin
  where d.approval_status = 'approved'
    and d.online_status   = 'online'
    and d.current_location is not null
    and (p_vehicle_type is null or d.vehicle_type = p_vehicle_type)
    and st_dwithin(d.current_location, origin.g, p_radius_km * 1000)
  order by d.current_location <-> origin.g
  limit 30;
$$;

comment on function public.nearby_drivers is
  'Returns approved, online drivers within p_radius_km of a point, nearest first.';

-- ----------------------------------------------------------------------------
-- complete_trip: assigned driver marks an in-progress trip completed and gets
-- the settled fare back. Used by the Captain app.
-- ----------------------------------------------------------------------------
create or replace function public.complete_trip(p_trip_id uuid)
returns public.trips
language plpgsql
security definer
set search_path = public
as $$
declare
  v_trip public.trips;
begin
  update public.trips
    set status = 'completed'
  where id = p_trip_id
    and driver_id = auth.uid()
    and status = 'in_progress'
  returning * into v_trip;

  if not found then
    raise exception 'Trip % cannot be completed by the current user', p_trip_id
      using errcode = 'check_violation';
  end if;

  return v_trip;
end;
$$;

comment on function public.complete_trip is
  'Marks the caller''s in-progress trip as completed (driver only) and returns it.';

-- ----------------------------------------------------------------------------
-- approve_driver / reject_driver: admin actions that also write an audit log.
-- ----------------------------------------------------------------------------
create or replace function public.set_driver_approval(
  p_driver_id uuid,
  p_status    public.approval_status,
  p_reason    text default null
)
returns public.drivers
language plpgsql
security definer
set search_path = public
as $$
declare
  v_driver public.drivers;
begin
  if not public.is_admin() then
    raise exception 'Only admins can change approval status' using errcode = 'insufficient_privilege';
  end if;

  update public.drivers
    set approval_status  = p_status,
        rejection_reason = case when p_status = 'rejected' then p_reason else null end,
        approved_by      = auth.uid(),
        approved_at      = case when p_status = 'approved' then now() else approved_at end
  where profile_id = p_driver_id
  returning * into v_driver;

  if not found then
    raise exception 'Driver % not found', p_driver_id;
  end if;

  insert into public.admin_logs (admin_id, action, target_table, target_id, description)
  values (auth.uid(), 'driver.' || p_status::text, 'drivers', p_driver_id, p_reason);

  return v_driver;
end;
$$;

comment on function public.set_driver_approval is
  'Admin-only: approve/reject/suspend a driver and record the action in admin_logs.';

-- Expose RPCs to authenticated clients (RLS + internal checks still apply).
grant execute on function public.nearby_drivers(double precision, double precision, double precision, public.vehicle_type) to authenticated;
grant execute on function public.complete_trip(uuid) to authenticated;
grant execute on function public.set_driver_approval(uuid, public.approval_status, text) to authenticated;
