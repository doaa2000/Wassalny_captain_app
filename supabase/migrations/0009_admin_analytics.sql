-- ============================================================================
-- 0009_admin_analytics.sql
-- Read-only aggregate RPCs consumed by the Admin panel (dashboard cards +
-- notification campaign history). Admin-only.
-- ============================================================================

-- Aggregated KPIs for the dashboard cards, returned as a single JSON object.
create or replace function public.admin_dashboard_stats()
returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
begin
  if not public.is_admin() then
    raise exception 'admin only' using errcode = 'insufficient_privilege';
  end if;

  return (
    select jsonb_build_object(
      'total_drivers',        (select count(*) from public.drivers),
      'active_drivers',       (select count(*) from public.drivers
                                 where approval_status = 'approved' and online_status <> 'offline'),
      'total_passengers',     (select count(*) from public.profiles where role = 'passenger'),
      'pending_applications', (select count(*) from public.drivers where approval_status = 'pending'),
      'trips_today',          (select count(*) from public.trips where created_at >= date_trunc('day', now())),
      'trips_month',          (select count(*) from public.trips where created_at >= date_trunc('month', now())),
      'total_revenue',        coalesce((select sum(trip_price) from public.trips where status = 'completed'), 0),
      'today_revenue',        coalesce((select sum(trip_price) from public.trips
                                 where status = 'completed' and completed_at >= date_trunc('day', now())), 0),
      'cancelled',            (select count(*) from public.trips where status in ('cancelled','rejected','expired'))
    )
  );
end;
$$;

comment on function public.admin_dashboard_stats is
  'Admin-only aggregate KPIs for the dashboard cards (counts + revenue sums).';

-- Notification "campaign" history: group per-user notifications by title/type
-- into reach (recipients) and open-rate (%).
create or replace function public.admin_notification_history()
returns table (title text, target text, sent text, reach integer, opened integer)
language plpgsql
stable
security definer
set search_path = public
as $$
begin
  if not public.is_admin() then
    raise exception 'admin only' using errcode = 'insufficient_privilege';
  end if;

  return query
    select n.title,
           n.type::text                                                              as target,
           to_char(max(n.created_at), 'YYYY-MM-DD')                                   as sent,
           count(*)::int                                                              as reach,
           round(100.0 * count(*) filter (where n.is_read) / greatest(count(*), 1))::int as opened
    from public.notifications n
    group by n.title, n.type
    order by max(n.created_at) desc
    limit 50;
end;
$$;

comment on function public.admin_notification_history is
  'Admin-only: per-title notification reach and open-rate for the panel.';

grant execute on function public.admin_dashboard_stats() to authenticated;
grant execute on function public.admin_notification_history() to authenticated;
