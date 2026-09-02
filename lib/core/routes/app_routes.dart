/// Centralized route paths & names. Screens navigate using these constants
/// only — never with hardcoded path strings.
abstract final class AppRoutes {
  AppRoutes._();

  // Auth flow
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String otp = '/otp';
  static const String forgotPassword = '/forgot-password';
  static const String accountRemoved = '/account-removed';

  // Main shell tabs
  static const String dashboard = '/dashboard';
  static const String earnings = '/earnings';
  static const String history = '/history';
  static const String notifications = '/notifications';
  static const String profile = '/profile';

  // Trip lifecycle
  static const String incomingRequest = '/incoming';
  static const String navigateToPickup = '/navigate';
  static const String arrived = '/arrived';
  static const String activeTrip = '/trip';
  static const String tripCompleted = '/trip-completed';

  // Profile sub-pages
  static const String wallet = '/wallet';
  static const String vehicle = '/vehicle';
  static const String support = '/support';
  static const String editProfile = '/edit-profile';
}
