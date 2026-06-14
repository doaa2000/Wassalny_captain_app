-- ============================================================================
-- 0002_profiles.sql
-- Core identity table. One row per auth.users user, holding shared profile
-- data for passengers, drivers and admins. All other tables reference this.
-- ============================================================================

create table public.profiles (
  id            uuid primary key references auth.users (id) on delete cascade,
  role          public.user_role not null default 'passenger',
  full_name     text,
  phone         text unique,
  profile_image text,
  is_active     boolean not null default true,   -- soft-disable an account
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

comment on table  public.profiles is
  'Master account record (1:1 with auth.users). Common fields for every role.';
comment on column public.profiles.role          is 'admin | passenger | driver.';
comment on column public.profiles.phone         is 'E.164 phone, unique across the platform.';
comment on column public.profiles.profile_image is 'Storage path/URL in the profile-images bucket.';

-- Indexes ---------------------------------------------------------------------
create index idx_profiles_role on public.profiles (role);

-- updated_at trigger ----------------------------------------------------------
create trigger trg_profiles_updated_at
  before update on public.profiles
  for each row execute function public.set_updated_at();

-- Auto-provision a profile whenever a new auth user signs up. The role and
-- name are read from the sign-up metadata (passed by the mobile apps).
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, role, full_name, phone)
  values (
    new.id,
    coalesce((new.raw_user_meta_data ->> 'role')::public.user_role, 'passenger'),
    new.raw_user_meta_data ->> 'full_name',
    coalesce(new.phone, new.raw_user_meta_data ->> 'phone')
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

create trigger trg_on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- Block non-admins from escalating their own role. Admins may change roles.
create or replace function public.guard_profile_role()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.role is distinct from old.role and not public.is_admin() then
    raise exception 'Only admins can change a profile role';
  end if;
  return new;
end;
$$;

create trigger trg_profiles_guard_role
  before update on public.profiles
  for each row execute function public.guard_profile_role();

-- Row Level Security ----------------------------------------------------------
alter table public.profiles enable row level security;

-- Read: own profile, admins read everything, and anyone authenticated may read
-- the profile of an approved driver (so passengers can see name & photo).
create policy "profiles_select_self"
  on public.profiles for select
  using (id = auth.uid());

create policy "profiles_select_admin"
  on public.profiles for select
  using (public.is_admin());

create policy "profiles_select_approved_drivers"
  on public.profiles for select
  using (
    exists (
      select 1 from public.drivers d
      where d.profile_id = profiles.id
        and d.approval_status = 'approved'
    )
  );

-- Insert: a user may only create their own profile row (the trigger does this
-- automatically; this policy covers manual/edge inserts).
create policy "profiles_insert_self"
  on public.profiles for insert
  with check (id = auth.uid());

-- Update: own row, or any row for admins.
create policy "profiles_update_self"
  on public.profiles for update
  using (id = auth.uid())
  with check (id = auth.uid());

create policy "profiles_update_admin"
  on public.profiles for update
  using (public.is_admin())
  with check (public.is_admin());
