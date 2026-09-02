-- ============================================================================
-- 0015_driver_fare_offer.sql
-- Captains may set a fare when claiming a request (counter-offer vs the
-- passenger's trip_price). NULL keeps the passenger's original price.
-- ============================================================================

drop function if exists public.accept_trip(uuid);
drop function if exists public.accept_trip(uuid, numeric);

create or replace function public.accept_trip(
  p_trip_id uuid,
  p_trip_price numeric default null
)
returns public.trips
language plpgsql
security definer
set search_path = public
as $$
declare
  v_trip   public.trips;
  v_status public.approval_status;
begin
  select approval_status into v_status from public.drivers where profile_id = auth.uid();
  if v_status is distinct from 'approved' then
    raise exception 'Only approved drivers can accept trips' using errcode = 'insufficient_privilege';
  end if;

  if p_trip_price is not null and p_trip_price < 0 then
    raise exception 'Trip price must be zero or greater' using errcode = 'check_violation';
  end if;

  update public.trips
    set driver_id = auth.uid(),
        status = 'accepted',
        trip_price = coalesce(p_trip_price, trip_price)
  where id = p_trip_id
    and status = 'requested'
    and (driver_id is null or driver_id = auth.uid())
  returning * into v_trip;

  if not found then
    raise exception 'Trip is no longer available' using errcode = 'check_violation';
  end if;

  return v_trip;
end;
$$;

comment on function public.accept_trip(uuid, numeric) is
  'A driver atomically claims an open ride request. Optional p_trip_price overrides the passenger fare.';

grant execute on function public.accept_trip(uuid, numeric) to authenticated;
