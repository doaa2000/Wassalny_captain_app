# Wassalny — Supabase database

Production-ready PostgreSQL schema for the Wassalny platform (Passenger app,
Captain app, Admin panel). Run the migrations **in numeric order**.

## Apply

```bash
# Option A — Supabase CLI (recommended)
supabase db push

# Option B — psql against your database
for f in supabase/migrations/*.sql; do psql "$DATABASE_URL" -f "$f"; done
```

## Migration files

| File | Contents |
|------|----------|
| `0001_extensions_enums_helpers.sql` | `pgcrypto`, `postgis`; all ENUM types; `set_updated_at`, `is_admin`, `current_user_role` |
| `0002_profiles.sql` | `profiles` (1:1 auth.users) + auto-provision trigger + role guard + RLS |
| `0003_drivers_and_documents.sql` | `drivers`, `driver_documents`, `passenger_favorites` + RLS |
| `0004_trips_and_history.sql` | `trips`, `trip_status_history` + status/timestamp/audit triggers + RLS |
| `0005_locations_and_ratings.sql` | `driver_locations`, `ratings` + rating recompute trigger + RLS |
| `0006_notifications_and_admin_logs.sql` | `notifications`, `admin_logs` + RLS |
| `0007_storage_buckets.sql` | `driver-documents` (private), `profile-images`, `vehicle-photos` + object policies |
| `0008_rpc_functions.sql` | `nearby_drivers`, `complete_trip`, `set_driver_approval` |

## Notes
- **PostGIS** is used for `nearby_drivers` dispatch (GiST-indexed `geography` columns).
- **RLS is enabled on every table.** The Supabase `service_role` key bypasses RLS
  for trusted backend/edge-function work (e.g. creating notifications, expiring requests).
- Sign-up metadata should include `role` and `full_name` so `handle_new_user`
  provisions the profile correctly:
  `supabase.auth.signUp(..., data: { role: 'driver', full_name: '...' })`.
- At scale, range-partition `driver_locations` by `recorded_at` and add a retention job.
