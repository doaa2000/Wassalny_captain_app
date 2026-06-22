-- 0014_drivers_admin_delete.sql
-- Allow admins to delete a driver from the admin panel. Without this DELETE
-- policy, RLS silently blocks the delete (0 rows removed) so the driver
-- reappears on reload. Cascades remove the driver's documents, ratings,
-- favorites and location history; trips keep their history with driver_id set
-- to null. The person's `profiles` row (their account) is kept.

drop policy if exists "drivers_delete_admin" on public.drivers;
create policy "drivers_delete_admin" on public.drivers
  for delete using (public.is_admin());
