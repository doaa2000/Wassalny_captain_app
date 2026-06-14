-- ============================================================================
-- 0007_storage_buckets.sql
-- Storage buckets + access policies for driver KYC documents and avatars.
--
-- File path convention (enforced by the policies below):
--   <bucket>/<auth.uid()>/<filename>
-- i.e. every user can only touch files inside a folder named after their id.
-- ============================================================================

-- Buckets ---------------------------------------------------------------------
-- driver-documents : PRIVATE (sensitive KYC). 10 MB limit, common doc types.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'driver-documents', 'driver-documents', false, 10485760,
  array['image/jpeg', 'image/png', 'image/webp', 'application/pdf']
)
on conflict (id) do nothing;

-- profile-images : PUBLIC read (avatars shown across apps). 5 MB limit.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'profile-images', 'profile-images', true, 5242880,
  array['image/jpeg', 'image/png', 'image/webp']
)
on conflict (id) do nothing;

-- vehicle-photos : PUBLIC read (shown to passengers). 5 MB limit.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'vehicle-photos', 'vehicle-photos', true, 5242880,
  array['image/jpeg', 'image/png', 'image/webp']
)
on conflict (id) do nothing;

-- ----------------------------------------------------------------------------
-- driver-documents policies (private; owner + admin only)
-- ----------------------------------------------------------------------------
create policy "driver_docs_owner_read"
  on storage.objects for select
  using (
    bucket_id = 'driver-documents'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "driver_docs_admin_read"
  on storage.objects for select
  using (bucket_id = 'driver-documents' and public.is_admin());

create policy "driver_docs_owner_write"
  on storage.objects for insert
  with check (
    bucket_id = 'driver-documents'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "driver_docs_owner_modify"
  on storage.objects for update
  using (
    bucket_id = 'driver-documents'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "driver_docs_owner_delete"
  on storage.objects for delete
  using (
    bucket_id = 'driver-documents'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

-- ----------------------------------------------------------------------------
-- profile-images & vehicle-photos policies (public read; owner write)
-- ----------------------------------------------------------------------------
create policy "public_images_read"
  on storage.objects for select
  using (bucket_id in ('profile-images', 'vehicle-photos'));

create policy "public_images_owner_write"
  on storage.objects for insert
  with check (
    bucket_id in ('profile-images', 'vehicle-photos')
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "public_images_owner_modify"
  on storage.objects for update
  using (
    bucket_id in ('profile-images', 'vehicle-photos')
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "public_images_owner_delete"
  on storage.objects for delete
  using (
    bucket_id in ('profile-images', 'vehicle-photos')
    and (storage.foldername(name))[1] = auth.uid()::text
  );
