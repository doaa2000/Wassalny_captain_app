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

  // Supabase — values are injected from the environment at build time
  // (`--dart-define`). They live here only as keys; no secret is committed.
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY');

  // Supabase table names (kept here so the data layer has a single source).
  static const String tableCaptains = 'captains';
  static const String tableRequests = 'ride_requests';
  static const String tableTrips = 'trips';
  static const String tableEarnings = 'earnings';
  static const String tableTransactions = 'wallet_transactions';
  static const String tableNotifications = 'notifications';
  static const String tableVehicles = 'vehicles';
}
