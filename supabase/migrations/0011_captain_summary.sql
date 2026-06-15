-- ============================================================================
-- 0011_captain_summary.sql
-- Per-driver "today" summary for the Captain app dashboard pills.
-- ============================================================================
create or replace function public.captain_today_summary()
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select jsonb_build_object(
    'today_earnings', 'EGP ' || coalesce(
      (select round(sum(trip_price))::int from public.trips
        where driver_id = auth.uid() and status = 'completed'
          and completed_at >= date_trunc('day', now())), 0)::text,
    'trips_today', (select count(*) from public.trips
        where driver_id = auth.uid() and status = 'completed'
          and completed_at >= date_trunc('day', now())),
    'online_time', '—'
  );
$$;

comment on function public.captain_today_summary is
  'Today''s completed earnings + trip count for the signed-in driver (Captain app).';

grant execute on function public.captain_today_summary() to authenticated;
