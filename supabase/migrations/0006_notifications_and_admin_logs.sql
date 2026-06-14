-- ============================================================================
-- 0006_notifications_and_admin_logs.sql
-- Per-user notifications + an immutable admin audit trail.
-- ============================================================================

create table public.notifications (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references public.profiles (id) on delete cascade,
  type       public.notification_type not null,
  title      text not null,
  body       text,
  data       jsonb not null default '{}'::jsonb,  -- deep-link payload (trip_id, etc.)
  is_read    boolean not null default false,
  read_at    timestamptz,
  created_at timestamptz not null default now()
);

comment on table  public.notifications is
  'In-app notifications delivered to a single recipient. Rows are created server-side (edge functions / service role).';
comment on column public.notifications.data is 'Arbitrary JSON payload for client-side routing (e.g. {"trip_id": "..."}).';

create index idx_notifications_user_unread
  on public.notifications (user_id, is_read, created_at desc);

alter table public.notifications enable row level security;

-- Recipients read and update (mark-as-read) their own notifications.
create policy "notifications_select_own"
  on public.notifications for select
  using (user_id = auth.uid());

create policy "notifications_update_own"
  on public.notifications for update
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

-- Admins may read all; admins/service role may create notifications.
create policy "notifications_select_admin"
  on public.notifications for select
  using (public.is_admin());

create policy "notifications_insert_admin"
  on public.notifications for insert
  with check (public.is_admin());
-- NOTE: the Supabase service_role key bypasses RLS, so backend functions can
-- insert notifications for any user without an explicit policy.


-- ============================================================================
-- admin_logs  (who did what, when — immutable)
-- ============================================================================
create table public.admin_logs (
  id           uuid primary key default gen_random_uuid(),
  admin_id     uuid not null references public.profiles (id) on delete set null,
  action       text not null,                 -- e.g. 'driver.approve', 'driver.suspend'
  target_table text,                           -- affected table (e.g. 'drivers')
  target_id    uuid,                           -- affected row id
  description  text,
  metadata     jsonb not null default '{}'::jsonb,
  ip_address   inet,
  created_at   timestamptz not null default now()
);

comment on table public.admin_logs is
  'Immutable audit trail of privileged admin actions (approvals, suspensions, edits).';

create index idx_admin_logs_admin  on public.admin_logs (admin_id, created_at desc);
create index idx_admin_logs_target on public.admin_logs (target_table, target_id);

alter table public.admin_logs enable row level security;

-- Only admins can read or write the audit log.
create policy "admin_logs_admin_select"
  on public.admin_logs for select
  using (public.is_admin());

create policy "admin_logs_admin_insert"
  on public.admin_logs for insert
  with check (public.is_admin() and admin_id = auth.uid());
