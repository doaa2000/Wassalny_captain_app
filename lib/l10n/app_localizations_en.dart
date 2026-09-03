// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Wassalny Captain';

  @override
  String get appTagline => 'Drive. Earn. Repeat.';

  @override
  String get appVersion => 'v2.4.0';

  @override
  String get home => 'Home';

  @override
  String get earnings => 'Earnings';

  @override
  String get history => 'History';

  @override
  String get alerts => 'Alerts';

  @override
  String get profile => 'Profile';

  @override
  String get tryAgain => 'Try again';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get back => 'Back';

  @override
  String get continueLabel => 'Continue';

  @override
  String get submit => 'Submit';

  @override
  String get logOut => 'Log out';

  @override
  String get logOutQuestion => 'Log out?';

  @override
  String get logOutMessage =>
      'You\'ll need to sign in again to go back online.';

  @override
  String get somethingWentWrong => 'Something went wrong.';

  @override
  String get pickup => 'Pickup';

  @override
  String get dropoff => 'Drop-off';

  @override
  String get driverLocation => 'Your location';

  @override
  String get splashWelcome => 'Wassalny';

  @override
  String get splashCaptain => 'Captain';

  @override
  String get splashTapToContinue => 'Tap to continue';

  @override
  String get loginTitle => 'Captain login';

  @override
  String get loginSubtitle => 'Sign in to start driving.';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get passwordLabel => 'Password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get logIn => 'Log in';

  @override
  String get newCaptain => 'New captain? ';

  @override
  String get registerToDrive => 'Register to drive';

  @override
  String get accountRemovedTitle => 'Account no longer active';

  @override
  String get accountRemovedBody =>
      'Your captain account has been removed by the Wassalny team. If you think this is a mistake, please contact support.';

  @override
  String get backToLogin => 'Back to login';

  @override
  String get resetPasswordTitle => 'Reset password';

  @override
  String get resetPasswordSubtitle =>
      'Enter your registered phone and we\'ll send a reset code.';

  @override
  String get sendResetCode => 'Send reset code';

  @override
  String get verifyTitle => 'Verify your number';

  @override
  String get verifySubtitle => 'Enter the 4-digit code sent to';

  @override
  String get didntGetCode => 'Didn\'t get a code? ';

  @override
  String resendIn(Object time) {
    return 'Resend in $time';
  }

  @override
  String get verifyAndStart => 'Verify & start';

  @override
  String get signupTitle => 'Become a captain';

  @override
  String get signupAccountInfo => 'Account information';

  @override
  String get signupAccountInfoSubtitle =>
      'Create your captain account using your email and password.';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get emailAddressLabel => 'Email address';

  @override
  String get emailHintSignup => 'You will use this email to sign in.';

  @override
  String get passwordHintSignup => 'Use at least 8 characters.';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get driverInfoTitle => 'Driver information';

  @override
  String get driverInfoSubtitle =>
      'Enter the information that will be reviewed by our team.';

  @override
  String get nationalIdLabel => 'National ID';

  @override
  String get licenseNumberLabel => 'Driving license number';

  @override
  String get vehicleInfoTitle => 'Vehicle information';

  @override
  String get vehicleModelLabel => 'Vehicle model';

  @override
  String get yearLabel => 'Year';

  @override
  String get plateNumberLabel => 'Plate number';

  @override
  String get requiredDocumentsTitle => 'Required documents';

  @override
  String get requiredDocumentsSubtitle =>
      'Upload clear photos of the documents below.';

  @override
  String get drivingLicense => 'Driving license';

  @override
  String get drivingLicenseDesc => 'Front and back of your driving license.';

  @override
  String get vehicleRegistration => 'Vehicle registration';

  @override
  String get vehicleRegistrationDesc =>
      'A clear photo of the vehicle registration.';

  @override
  String get insurance => 'Insurance';

  @override
  String get insuranceDesc => 'A valid vehicle insurance document.';

  @override
  String get submitApplication => 'Submit application';

  @override
  String get applicationReview => 'Application review';

  @override
  String get applicationReviewBody =>
      'After submitting your application, your account will remain pending until an admin reviews and approves your information.';

  @override
  String get accountStep => 'Account';

  @override
  String get driverStep => 'Driver';

  @override
  String get documentsStep => 'Documents';

  @override
  String get fieldRequired => 'Please complete all required fields.';

  @override
  String get invalidEmail => 'Please enter a valid email address.';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters.';

  @override
  String get passwordMismatch => 'Passwords do not match.';

  @override
  String get driverFieldsRequired =>
      'Please complete all driver and vehicle fields.';

  @override
  String get phoneLabel => 'Phone number';

  @override
  String get documentUploaded => 'Uploaded';

  @override
  String get documentAdd => 'Add';

  @override
  String get dashboardOnline => 'You\'re online';

  @override
  String get dashboardOffline => 'You\'re offline';

  @override
  String get dashboardOfflineSubtitle =>
      'Go online to start receiving ride requests near you.';

  @override
  String get goOnline => 'Go online';

  @override
  String get nearbyRequests => 'Nearby requests';

  @override
  String get live => 'Live';

  @override
  String minAway(Object minutes) {
    return '$minutes min away';
  }

  @override
  String get today => 'Today';

  @override
  String get trips => 'Trips';

  @override
  String get online => 'Online';

  @override
  String get dashboardError => 'Could not load your dashboard.';

  @override
  String get earningsTitle => 'Earnings';

  @override
  String get earningsDay => 'Day';

  @override
  String get earningsWeek => 'Week';

  @override
  String get earningsMonth => 'Month';

  @override
  String get thisWeek => 'This week';

  @override
  String get bonusEarned => 'Bonus earned';

  @override
  String get completed => 'Completed';

  @override
  String ridesCount(Object count) {
    return '$count rides';
  }

  @override
  String get totalEarnings => 'Total earnings';

  @override
  String get avgPerTrip => 'Avg / trip';

  @override
  String get tripHistoryTitle => 'Trip history';

  @override
  String get noTripsYet => 'No trips yet';

  @override
  String get noTripsSubtitle => 'Completed rides will appear here.';

  @override
  String get searchTrips => 'Search trips';

  @override
  String get filterAll => 'All';

  @override
  String get filterToday => 'Today';

  @override
  String get filterThisWeek => 'This week';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get clearAll => 'Clear all';

  @override
  String get allCaughtUp => 'You\'re all caught up';

  @override
  String get allCaughtUpSubtitle =>
      'New alerts about payouts and ratings show up here.';

  @override
  String get earlier => 'Earlier';

  @override
  String get vehicleTitle => 'My vehicle';

  @override
  String get plateNumberTitle => 'Plate number';

  @override
  String get serviceTierTitle => 'Service tier';

  @override
  String get documentsInsurance => 'Documents & insurance';

  @override
  String get activeApproved => 'Active & approved';

  @override
  String get docValid => 'Valid';

  @override
  String get docRenewSoon => 'Renew soon';

  @override
  String get docPassed => 'Passed';

  @override
  String get walletTitle => 'Wallet';

  @override
  String get payoutAccount => 'Payout account';

  @override
  String get transactions => 'Transactions';

  @override
  String get availableBalance => 'Available balance';

  @override
  String get withdrawEarnings => 'Withdraw earnings';

  @override
  String get withdrawalRequested => 'Withdrawal requested.';

  @override
  String get verified => 'Verified';

  @override
  String get vehicleManagement => 'Vehicle management';

  @override
  String get walletAndPayouts => 'Wallet & payouts';

  @override
  String get documentsLabel => 'Documents';

  @override
  String get languageLabel => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get supportCenter => 'Support center';

  @override
  String get supportTitle => 'Support center';

  @override
  String get callHotline => 'Call hotline';

  @override
  String get reportIncident => 'Report incident';

  @override
  String get safetyAccidents => 'Safety & accidents';

  @override
  String get frequentlyAsked => 'Frequently asked';

  @override
  String get liveChatSupport => 'Live chat support';

  @override
  String get toDestination => 'To destination';

  @override
  String get sos => 'SOS';

  @override
  String tripTo(Object destination) {
    return 'Trip to $destination';
  }

  @override
  String get completeTrip => 'Complete trip';

  @override
  String get arrivedAtPickup => 'You\'ve arrived at pickup';

  @override
  String get waitingTime => 'Waiting time';

  @override
  String meetingAt(Object pickup) {
    return 'Meeting at $pickup';
  }

  @override
  String get startTrip => 'Start trip';

  @override
  String get seconds => 'SECONDS';

  @override
  String pickupDistance(Object distance) {
    return 'PICKUP · $distance';
  }

  @override
  String dropoffDistance(Object distance) {
    return 'DROP-OFF · $distance';
  }

  @override
  String get decline => 'Decline';

  @override
  String acceptFare(Object fare) {
    return 'Send offer · $fare';
  }

  @override
  String get passengerFare => 'Passenger fare';

  @override
  String get yourFare => 'Your fare';

  @override
  String get egpCurrency => 'EGP';

  @override
  String get headToPickup => 'Head to pickup';

  @override
  String pickupWithDistance(Object distance, Object pickup) {
    return '$pickup · $distance';
  }

  @override
  String get min => 'MIN';

  @override
  String get iveArrivedAtPickup => 'I\'ve arrived at pickup';

  @override
  String get cancelTrip => 'Cancel trip';

  @override
  String get youEarned => 'You earned';

  @override
  String get addedToToday => 'Added to today\'s earnings';

  @override
  String get kmUnit => 'km';

  @override
  String get minUnit => 'min';

  @override
  String get paymentLabel => 'payment';

  @override
  String get pickupLabel => 'PICKUP';

  @override
  String get dropoffLabel => 'DROP-OFF';

  @override
  String get tripFare => 'Trip fare';

  @override
  String get serviceFee => 'Service fee (–8%)';

  @override
  String get peakBonus => 'Peak bonus';

  @override
  String get yourEarnings => 'Your earnings';

  @override
  String get findNextRide => 'Find next ride';

  @override
  String get riderCancelled => 'The rider cancelled this trip.';

  @override
  String get tripFareLabel => 'Trip fare';

  @override
  String passengerRating(Object method, Object rating) {
    return '$rating · $method';
  }

  @override
  String get acceptance => 'Acceptance';

  @override
  String get completion => 'Completion';

  @override
  String get editProfileTitle => 'Edit profile';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get callPassenger => 'Call passenger';

  @override
  String get messagePassenger => 'Message passenger';

  @override
  String get communicationFailed =>
      'Couldn\'t open call / messages. Please try again.';
}
