-- ============================================================================
-- 0012_grants.sql
-- Restore table-level privileges for the Supabase API roles.
--
-- RLS controls which ROWS a role sees; these GRANTs control whether the role
-- can touch the table at all. They are set by Supabase by default, but a
-- `drop schema public cascade; create schema public;` wipes them — which causes
-- "permission denied for table ..." (HTTP 403) from PostgREST. Run this after
-- any such reset (it is also included at the end of schema.sql).
-- ============================================================================
grant usage on schema public to anon, authenticated, service_role;
grant all on all tables    in schema public to anon, authenticated, service_role;
grant all on all sequences in schema public to anon, authenticated, service_role;
grant all on all functions in schema public to anon, authenticated, service_role;

alter default privileges in schema public grant all on tables    to anon, authenticated, service_role;
alter default privileges in schema public grant all on sequences to anon, authenticated, service_role;
alter default privileges in schema public grant all on functions to anon, authenticated, service_role;
