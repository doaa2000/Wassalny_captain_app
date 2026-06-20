-- 0013_trip_driver.sql
-- Lets a trip participant (passenger or the assigned driver) read the public
-- details of the driver assigned to that trip. Needed by the rider app to show
-- "who accepted" after a broadcast request, without exposing the whole drivers
-- table through RLS.

create or replace function public.trip_driver(p_trip_id uuid)
returns table (
  profile_id    uuid,
  full_name     text,
  profile_image text,
  vehicle_type  public.vehicle_type,
  vehicle_model text,
  vehicle_color text,
  plate_number  text,
  rating        numeric,
  total_trips   integer
)
language sql stable security definer set search_path = public as $$
  select d.profile_id, p.full_name, p.profile_image,
         d.vehicle_type, d.vehicle_model, d.vehicle_color,
         d.plate_number, d.rating, d.total_trips
  from public.trips t
  join public.drivers  d on d.profile_id = t.driver_id
  join public.profiles p on p.id = d.profile_id
  where t.id = p_trip_id
    and t.driver_id is not null
    and (t.passenger_id = auth.uid() or t.driver_id = auth.uid() or public.is_admin());
$$;

grant execute on function public.trip_driver(uuid) to anon, authenticated;
