/// App-wide constant values that are not visual (timings, keys, config).
abstract final class AppConstants {
  AppConstants._();

  static const String appName = 'Wassalny Captain';
  static const String appTagline = 'Drive. Earn. Repeat.';
  static const String appVersion = 'v2.4.0';

  // Country / formatting
  static const String dialCode = '+20';
  static const String currency = 'EGP';

  // Timings
  static const Duration splashDelay = Duration(seconds: 2);
  static const Duration requestCountdown = Duration(seconds: 15);
  static const Duration screenTransition = Duration(milliseconds: 350);

  // Supabase config.
  //
  // Preferred: pass these at build time via --dart-define(-from-file) (see
  // run-live.sh). As a FALLBACK — so the app also connects when launched from
  // the IDE's plain Debug button (which passes no --dart-define) — paste your
  // project's URL and ANON key below.
  //
  // The anon key is a PUBLIC client key (protected by Row Level Security) and
  // is safe to ship in the app. NEVER put the service_role key here.
  static const String _fallbackSupabaseUrl =
      'https://ovagqwoipzjokueqqubs.supabase.co';
  static const String _fallbackSupabaseAnonKey =
      ''; // <-- paste your Supabase anon key here

  static const String supabaseUrl =
      String.fromEnvironment('SUPABASE_URL', defaultValue: _fallbackSupabaseUrl);
  static const String supabaseAnonKey = String.fromEnvironment(
      'SUPABASE_ANON_KEY',
      defaultValue: _fallbackSupabaseAnonKey);

  // Supabase table names (kept here so the data layer has a single source).
  // These match the deployed schema (see supabase/schema.sql).
  static const String tableProfiles = 'profiles';
  static const String tableDrivers = 'drivers';
  static const String tableTrips = 'trips';
  static const String tableDriverLocations = 'driver_locations';
  static const String tableNotifications = 'notifications';
  static const String tablePayments = 'payments';

  // Trip status values (server-side enum public.trip_status).
  static const String tripStatusRequested = 'requested';
  static const String tripStatusAccepted = 'accepted';
  static const String tripStatusArrived = 'arrived';
  static const String tripStatusInProgress = 'in_progress';
  static const String tripStatusCompleted = 'completed';
  static const String tripStatusCancelled = 'cancelled';
}
