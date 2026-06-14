-- ============================================================================
-- 0001_extensions_enums_helpers.sql
-- Foundation: extensions, ENUM types, and shared helper functions.
-- Wassalny — ride-hailing platform (Passenger app · Captain app · Admin panel).
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Extensions
-- ----------------------------------------------------------------------------
-- gen_random_uuid() for primary keys (built into PG13+, exposed via pgcrypto).
create extension if not exists "pgcrypto";
-- PostGIS powers spatial "nearby driver" queries via geography + GiST indexes.
create extension if not exists "postgis";

-- ----------------------------------------------------------------------------
-- ENUM types  (centralized, so every table shares the same vocabulary)
-- ----------------------------------------------------------------------------

-- Account role. A single auth user is exactly one of these.
create type public.user_role as enum ('admin', 'passenger', 'driver');

-- Lifecycle of a driver application reviewed by an admin.
create type public.approval_status as enum ('pending', 'approved', 'rejected', 'suspended');

-- Driver availability for receiving trip requests.
create type public.online_status as enum ('offline', 'online', 'on_trip');

-- Vehicle service tiers offered to passengers.
create type public.vehicle_type as enum ('economy', 'comfort', 'suv', 'van', 'motorbike');

-- KYC document categories uploaded by drivers.
create type public.document_type as enum (
  'national_id', 'driver_license', 'vehicle_registration',
  'vehicle_insurance', 'vehicle_photo', 'profile_photo'
);

-- Per-document verification state.
create type public.verification_status as enum ('pending', 'verified', 'rejected');

-- Trip lifecycle (state machine).
create type public.trip_status as enum (
  'requested',    -- passenger created the request, awaiting driver
  'accepted',     -- driver accepted, heading to pickup
  'arrived',      -- driver arrived at pickup
  'in_progress',  -- trip started, en route to destination
  'completed',    -- trip finished
  'rejected',     -- driver declined the request
  'cancelled',    -- cancelled by passenger/driver/admin
  'expired'       -- no driver responded in time
);

-- Who triggered a cancellation.
create type public.actor_type as enum ('passenger', 'driver', 'admin', 'system');

-- Payment methods.
create type public.payment_method as enum ('cash', 'wallet', 'card');

-- Notification categories.
create type public.notification_type as enum (
  'trip_request', 'trip_accepted', 'trip_arrived', 'trip_started',
  'trip_completed', 'trip_cancelled', 'driver_approved', 'driver_rejected',
  'document_verified', 'payment', 'promo', 'system'
);

-- ----------------------------------------------------------------------------
-- Helper: keep updated_at fresh on every UPDATE.
-- ----------------------------------------------------------------------------
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

-- ----------------------------------------------------------------------------
-- Helper: is the current JWT user an admin?
-- SECURITY DEFINER + table-owner context avoids RLS recursion when this is
-- used inside the profiles policies. STABLE so the planner can cache it.
-- ----------------------------------------------------------------------------
create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.profiles
    where id = auth.uid() and role = 'admin'
  );
$$;

-- Helper: role of the current user (or null when unauthenticated).
create or replace function public.current_user_role()
returns public.user_role
language sql
stable
security definer
set search_path = public
as $$
  select role from public.profiles where id = auth.uid();
$$;
