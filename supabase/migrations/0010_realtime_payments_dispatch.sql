-- ============================================================================
-- 0010_realtime_payments_dispatch.sql
-- Broadcast dispatch (Uber/Careem style) + Realtime + payments table.
-- ============================================================================

-- ─────────────────────────────────────────────────────────────────────────────
-- 1. REALTIME — stream row changes to the apps live.
--    (Wrapped so re-running doesn't fail when a table is already published.)
-- ─────────────────────────────────────────────────────────────────────────────
do $$ begin alter publication supabase_realtime add table public.trips;            exception when duplicate_object then null; end $$;
do $$ begin alter publication supabase_realtime add table public.driver_locations; exception when duplicate_object then null; end $$;
do $$ begin alter publication supabase_realtime add table public.notifications;    exception when duplicate_object then null; end $$;

-- Emit full row (incl. old values) on UPDATE/DELETE so clients & RLS work cleanly.
alter table public.trips            replica identity full;
alter table public.driver_locations replica identity full;
alter table public.notifications    replica identity full;

-- ─────────────────────────────────────────────────────────────────────────────
-- 2. BROADCAST DISPATCH
--    A passenger creates a trip with driver_id = NULL (an open request). Every
--    approved + online driver can SEE it; the first to accept claims it.
-- ─────────────────────────────────────────────────────────────────────────────

-- Approved, online drivers can read open (unassigned) requests.
drop policy if exists "trips_select_open_for_drivers" on public.trips;
create policy "trips_select_open_for_drivers" on public.trips
for select using (
  status = 'requested' and driver_id is null
  and exists (
    select 1 from public.drivers d
    where d.profile_id = auth.uid()
      and d.approval_status = 'approved'
      and d.online_status = 'online'
  )
);

-- Atomic claim: the first approved driver to call this wins; everyone else gets
-- "no longer available". Avoids two drivers grabbing the same trip.
create or replace function public.accept_trip(p_trip_id uuid)
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

  update public.trips
    set driver_id = auth.uid(), status = 'accepted'
  where id = p_trip_id and status = 'requested' and (driver_id is null or driver_id = auth.uid())
  returning * into v_trip;

  if not found then
    raise exception 'Trip is no longer available' using errcode = 'check_violation';
  end if;

  return v_trip;
end;
$$;

comment on function public.accept_trip is
  'A driver atomically claims an open ride request (first-come-first-served).';

grant execute on function public.accept_trip(uuid) to authenticated;

-- ─────────────────────────────────────────────────────────────────────────────
-- 3. PAYMENTS
-- ─────────────────────────────────────────────────────────────────────────────
do $$ begin
  create type public.payment_status as enum ('pending', 'paid', 'failed', 'refunded');
exception when duplicate_object then null; end $$;

create table if not exists public.payments (
  id           uuid primary key default gen_random_uuid(),
  trip_id      uuid not null unique references public.trips (id) on delete cascade,
  passenger_id uuid not null references public.profiles (id) on delete restrict,
  driver_id    uuid references public.drivers (profile_id) on delete set null,
  amount       numeric(10, 2) not null check (amount >= 0),
  method       public.payment_method not null default 'cash',
  status       public.payment_status not null default 'pending',
  paid_at      timestamptz,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

comment on table public.payments is
  'One payment record per trip (fare, method and settlement status).';

create index if not exists idx_payments_passenger on public.payments (passenger_id);
create index if not exists idx_payments_driver    on public.payments (driver_id);
create index if not exists idx_payments_status    on public.payments (status);

drop trigger if exists trg_payments_updated_at on public.payments;
create trigger trg_payments_updated_at
  before update on public.payments
  for each row execute function public.set_updated_at();

alter table public.payments enable row level security;

-- Participants read their own payments; admins read all. Writes happen
-- server-side (service role bypasses RLS) or by an admin.
drop policy if exists "payments_select_participant" on public.payments;
create policy "payments_select_participant" on public.payments
  for select using (passenger_id = auth.uid() or driver_id = auth.uid());

drop policy if exists "payments_select_admin" on public.payments;
create policy "payments_select_admin" on public.payments
  for select using (public.is_admin());

drop policy if exists "payments_admin_write" on public.payments;
create policy "payments_admin_write" on public.payments
  for all using (public.is_admin()) with check (public.is_admin());
