import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Wassalny Captain'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Drive. Earn. Repeat.'**
  String get appTagline;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'v2.4.0'**
  String get appVersion;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @earnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earnings;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alerts;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @logOutQuestion.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logOutQuestion;

  /// No description provided for @logOutMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ll need to sign in again to go back online.'**
  String get logOutMessage;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get somethingWentWrong;

  /// Map marker for trip pickup location
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get pickup;

  /// Map marker for trip drop-off location
  ///
  /// In en, this message translates to:
  /// **'Drop-off'**
  String get dropoff;

  /// No description provided for @driverLocation.
  ///
  /// In en, this message translates to:
  /// **'Your location'**
  String get driverLocation;

  /// No description provided for @myLocation.
  ///
  /// In en, this message translates to:
  /// **'My location'**
  String get myLocation;

  /// No description provided for @splashWelcome.
  ///
  /// In en, this message translates to:
  /// **'Wassalny'**
  String get splashWelcome;

  /// No description provided for @splashCaptain.
  ///
  /// In en, this message translates to:
  /// **'Captain'**
  String get splashCaptain;

  /// No description provided for @splashTapToContinue.
  ///
  /// In en, this message translates to:
  /// **'Tap to continue'**
  String get splashTapToContinue;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Captain login'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to start driving.'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// No description provided for @newCaptain.
  ///
  /// In en, this message translates to:
  /// **'New captain? '**
  String get newCaptain;

  /// No description provided for @registerToDrive.
  ///
  /// In en, this message translates to:
  /// **'Register to drive'**
  String get registerToDrive;

  /// No description provided for @accountRemovedTitle.
  ///
  /// In en, this message translates to:
  /// **'Account no longer active'**
  String get accountRemovedTitle;

  /// No description provided for @accountRemovedBody.
  ///
  /// In en, this message translates to:
  /// **'Your captain account has been removed by the Wassalny team. If you think this is a mistake, please contact support.'**
  String get accountRemovedBody;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get backToLogin;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered phone and we\'ll send a reset code.'**
  String get resetPasswordSubtitle;

  /// No description provided for @sendResetCode.
  ///
  /// In en, this message translates to:
  /// **'Send reset code'**
  String get sendResetCode;

  /// No description provided for @verifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your number'**
  String get verifyTitle;

  /// No description provided for @verifySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 4-digit code sent to'**
  String get verifySubtitle;

  /// No description provided for @didntGetCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get a code? '**
  String get didntGetCode;

  /// No description provided for @resendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in {time}'**
  String resendIn(Object time);

  /// No description provided for @verifyAndStart.
  ///
  /// In en, this message translates to:
  /// **'Verify & start'**
  String get verifyAndStart;

  /// No description provided for @signupTitle.
  ///
  /// In en, this message translates to:
  /// **'Become a captain'**
  String get signupTitle;

  /// No description provided for @signupAccountInfo.
  ///
  /// In en, this message translates to:
  /// **'Account information'**
  String get signupAccountInfo;

  /// No description provided for @signupAccountInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your captain account using your email and password.'**
  String get signupAccountInfoSubtitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullNameLabel;

  /// No description provided for @emailAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddressLabel;

  /// No description provided for @emailHintSignup.
  ///
  /// In en, this message translates to:
  /// **'You will use this email to sign in.'**
  String get emailHintSignup;

  /// No description provided for @passwordHintSignup.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters.'**
  String get passwordHintSignup;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordLabel;

  /// No description provided for @driverInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Driver information'**
  String get driverInfoTitle;

  /// No description provided for @driverInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the information that will be reviewed by our team.'**
  String get driverInfoSubtitle;

  /// No description provided for @nationalIdLabel.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get nationalIdLabel;

  /// No description provided for @licenseNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Driving license number'**
  String get licenseNumberLabel;

  /// No description provided for @vehicleInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle information'**
  String get vehicleInfoTitle;

  /// No description provided for @vehicleModelLabel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle model'**
  String get vehicleModelLabel;

  /// No description provided for @yearLabel.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get yearLabel;

  /// No description provided for @plateNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Plate number'**
  String get plateNumberLabel;

  /// No description provided for @requiredDocumentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Required documents'**
  String get requiredDocumentsTitle;

  /// No description provided for @requiredDocumentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload clear photos of the documents below.'**
  String get requiredDocumentsSubtitle;

  /// No description provided for @drivingLicense.
  ///
  /// In en, this message translates to:
  /// **'Driving license'**
  String get drivingLicense;

  /// No description provided for @drivingLicenseDesc.
  ///
  /// In en, this message translates to:
  /// **'Front and back of your driving license.'**
  String get drivingLicenseDesc;

  /// No description provided for @vehicleRegistration.
  ///
  /// In en, this message translates to:
  /// **'Vehicle registration'**
  String get vehicleRegistration;

  /// No description provided for @vehicleRegistrationDesc.
  ///
  /// In en, this message translates to:
  /// **'A clear photo of the vehicle registration.'**
  String get vehicleRegistrationDesc;

  /// No description provided for @insurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get insurance;

  /// No description provided for @insuranceDesc.
  ///
  /// In en, this message translates to:
  /// **'A valid vehicle insurance document.'**
  String get insuranceDesc;

  /// No description provided for @submitApplication.
  ///
  /// In en, this message translates to:
  /// **'Submit application'**
  String get submitApplication;

  /// No description provided for @applicationReview.
  ///
  /// In en, this message translates to:
  /// **'Application review'**
  String get applicationReview;

  /// No description provided for @applicationReviewBody.
  ///
  /// In en, this message translates to:
  /// **'After submitting your application, your account will remain pending until an admin reviews and approves your information.'**
  String get applicationReviewBody;

  /// No description provided for @accountStep.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountStep;

  /// No description provided for @driverStep.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get driverStep;

  /// No description provided for @documentsStep.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documentsStep;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Please complete all required fields.'**
  String get fieldRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters.'**
  String get passwordTooShort;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordMismatch;

  /// No description provided for @driverFieldsRequired.
  ///
  /// In en, this message translates to:
  /// **'Please complete all driver and vehicle fields.'**
  String get driverFieldsRequired;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneLabel;

  /// No description provided for @documentUploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get documentUploaded;

  /// No description provided for @documentAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get documentAdd;

  /// No description provided for @dashboardOnline.
  ///
  /// In en, this message translates to:
  /// **'You\'re online'**
  String get dashboardOnline;

  /// No description provided for @dashboardOffline.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline'**
  String get dashboardOffline;

  /// No description provided for @dashboardOfflineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Go online to start receiving ride requests near you.'**
  String get dashboardOfflineSubtitle;

  /// No description provided for @goOnline.
  ///
  /// In en, this message translates to:
  /// **'Go online'**
  String get goOnline;

  /// No description provided for @nearbyRequests.
  ///
  /// In en, this message translates to:
  /// **'Nearby requests'**
  String get nearbyRequests;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live;

  /// No description provided for @minAway.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min away'**
  String minAway(Object minutes);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @trips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get trips;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @dashboardError.
  ///
  /// In en, this message translates to:
  /// **'Could not load your dashboard.'**
  String get dashboardError;

  /// No description provided for @earningsTitle.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earningsTitle;

  /// No description provided for @earningsDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get earningsDay;

  /// No description provided for @earningsWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get earningsWeek;

  /// No description provided for @earningsMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get earningsMonth;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// No description provided for @bonusEarned.
  ///
  /// In en, this message translates to:
  /// **'Bonus earned'**
  String get bonusEarned;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @ridesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} rides'**
  String ridesCount(Object count);

  /// No description provided for @totalEarnings.
  ///
  /// In en, this message translates to:
  /// **'Total earnings'**
  String get totalEarnings;

  /// No description provided for @avgPerTrip.
  ///
  /// In en, this message translates to:
  /// **'Avg / trip'**
  String get avgPerTrip;

  /// No description provided for @tripHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip history'**
  String get tripHistoryTitle;

  /// No description provided for @noTripsYet.
  ///
  /// In en, this message translates to:
  /// **'No trips yet'**
  String get noTripsYet;

  /// No description provided for @noTripsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Completed rides will appear here.'**
  String get noTripsSubtitle;

  /// No description provided for @searchTrips.
  ///
  /// In en, this message translates to:
  /// **'Search trips'**
  String get searchTrips;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get filterToday;

  /// No description provided for @filterThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get filterThisWeek;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// No description provided for @allCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up'**
  String get allCaughtUp;

  /// No description provided for @allCaughtUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'New alerts about payouts and ratings show up here.'**
  String get allCaughtUpSubtitle;

  /// No description provided for @earlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get earlier;

  /// No description provided for @vehicleTitle.
  ///
  /// In en, this message translates to:
  /// **'My vehicle'**
  String get vehicleTitle;

  /// No description provided for @plateNumberTitle.
  ///
  /// In en, this message translates to:
  /// **'Plate number'**
  String get plateNumberTitle;

  /// No description provided for @serviceTierTitle.
  ///
  /// In en, this message translates to:
  /// **'Service tier'**
  String get serviceTierTitle;

  /// No description provided for @documentsInsurance.
  ///
  /// In en, this message translates to:
  /// **'Documents & insurance'**
  String get documentsInsurance;

  /// No description provided for @activeApproved.
  ///
  /// In en, this message translates to:
  /// **'Active & approved'**
  String get activeApproved;

  /// No description provided for @docValid.
  ///
  /// In en, this message translates to:
  /// **'Valid'**
  String get docValid;

  /// No description provided for @docRenewSoon.
  ///
  /// In en, this message translates to:
  /// **'Renew soon'**
  String get docRenewSoon;

  /// No description provided for @docPassed.
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get docPassed;

  /// No description provided for @walletTitle.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get walletTitle;

  /// No description provided for @payoutAccount.
  ///
  /// In en, this message translates to:
  /// **'Payout account'**
  String get payoutAccount;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @availableBalance.
  ///
  /// In en, this message translates to:
  /// **'Available balance'**
  String get availableBalance;

  /// No description provided for @withdrawEarnings.
  ///
  /// In en, this message translates to:
  /// **'Withdraw earnings'**
  String get withdrawEarnings;

  /// No description provided for @withdrawalRequested.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal requested.'**
  String get withdrawalRequested;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @vehicleManagement.
  ///
  /// In en, this message translates to:
  /// **'Vehicle management'**
  String get vehicleManagement;

  /// No description provided for @walletAndPayouts.
  ///
  /// In en, this message translates to:
  /// **'Wallet & payouts'**
  String get walletAndPayouts;

  /// No description provided for @documentsLabel.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documentsLabel;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @supportCenter.
  ///
  /// In en, this message translates to:
  /// **'Support center'**
  String get supportCenter;

  /// No description provided for @supportTitle.
  ///
  /// In en, this message translates to:
  /// **'Support center'**
  String get supportTitle;

  /// No description provided for @callHotline.
  ///
  /// In en, this message translates to:
  /// **'Call hotline'**
  String get callHotline;

  /// No description provided for @reportIncident.
  ///
  /// In en, this message translates to:
  /// **'Report incident'**
  String get reportIncident;

  /// No description provided for @safetyAccidents.
  ///
  /// In en, this message translates to:
  /// **'Safety & accidents'**
  String get safetyAccidents;

  /// No description provided for @frequentlyAsked.
  ///
  /// In en, this message translates to:
  /// **'Frequently asked'**
  String get frequentlyAsked;

  /// No description provided for @liveChatSupport.
  ///
  /// In en, this message translates to:
  /// **'Live chat support'**
  String get liveChatSupport;

  /// No description provided for @toDestination.
  ///
  /// In en, this message translates to:
  /// **'To destination'**
  String get toDestination;

  /// No description provided for @sos.
  ///
  /// In en, this message translates to:
  /// **'SOS'**
  String get sos;

  /// No description provided for @tripTo.
  ///
  /// In en, this message translates to:
  /// **'Trip to {destination}'**
  String tripTo(Object destination);

  /// No description provided for @completeTrip.
  ///
  /// In en, this message translates to:
  /// **'Complete trip'**
  String get completeTrip;

  /// No description provided for @arrivedAtPickup.
  ///
  /// In en, this message translates to:
  /// **'You\'ve arrived at pickup'**
  String get arrivedAtPickup;

  /// No description provided for @waitingTime.
  ///
  /// In en, this message translates to:
  /// **'Waiting time'**
  String get waitingTime;

  /// No description provided for @meetingAt.
  ///
  /// In en, this message translates to:
  /// **'Meeting at {pickup}'**
  String meetingAt(Object pickup);

  /// No description provided for @startTrip.
  ///
  /// In en, this message translates to:
  /// **'Start trip'**
  String get startTrip;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'SECONDS'**
  String get seconds;

  /// No description provided for @pickupDistance.
  ///
  /// In en, this message translates to:
  /// **'PICKUP · {distance}'**
  String pickupDistance(Object distance);

  /// No description provided for @dropoffDistance.
  ///
  /// In en, this message translates to:
  /// **'DROP-OFF · {distance}'**
  String dropoffDistance(Object distance);

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @acceptFare.
  ///
  /// In en, this message translates to:
  /// **'Send offer · {fare}'**
  String acceptFare(Object fare);

  /// No description provided for @passengerFare.
  ///
  /// In en, this message translates to:
  /// **'Passenger fare'**
  String get passengerFare;

  /// No description provided for @yourFare.
  ///
  /// In en, this message translates to:
  /// **'Your fare'**
  String get yourFare;

  /// No description provided for @egpCurrency.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get egpCurrency;

  /// No description provided for @headToPickup.
  ///
  /// In en, this message translates to:
  /// **'Head to pickup'**
  String get headToPickup;

  /// No description provided for @pickupWithDistance.
  ///
  /// In en, this message translates to:
  /// **'{pickup} · {distance}'**
  String pickupWithDistance(Object distance, Object pickup);

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'MIN'**
  String get min;

  /// No description provided for @iveArrivedAtPickup.
  ///
  /// In en, this message translates to:
  /// **'I\'ve arrived at pickup'**
  String get iveArrivedAtPickup;

  /// No description provided for @cancelTrip.
  ///
  /// In en, this message translates to:
  /// **'Cancel trip'**
  String get cancelTrip;

  /// No description provided for @youEarned.
  ///
  /// In en, this message translates to:
  /// **'You earned'**
  String get youEarned;

  /// No description provided for @addedToToday.
  ///
  /// In en, this message translates to:
  /// **'Added to today\'s earnings'**
  String get addedToToday;

  /// No description provided for @kmUnit.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get kmUnit;

  /// No description provided for @minUnit.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minUnit;

  /// No description provided for @paymentLabel.
  ///
  /// In en, this message translates to:
  /// **'payment'**
  String get paymentLabel;

  /// No description provided for @pickupLabel.
  ///
  /// In en, this message translates to:
  /// **'PICKUP'**
  String get pickupLabel;

  /// No description provided for @dropoffLabel.
  ///
  /// In en, this message translates to:
  /// **'DROP-OFF'**
  String get dropoffLabel;

  /// No description provided for @tripFare.
  ///
  /// In en, this message translates to:
  /// **'Trip fare'**
  String get tripFare;

  /// No description provided for @serviceFee.
  ///
  /// In en, this message translates to:
  /// **'Service fee (–8%)'**
  String get serviceFee;

  /// No description provided for @peakBonus.
  ///
  /// In en, this message translates to:
  /// **'Peak bonus'**
  String get peakBonus;

  /// No description provided for @yourEarnings.
  ///
  /// In en, this message translates to:
  /// **'Your earnings'**
  String get yourEarnings;

  /// No description provided for @findNextRide.
  ///
  /// In en, this message translates to:
  /// **'Find next ride'**
  String get findNextRide;

  /// No description provided for @riderCancelled.
  ///
  /// In en, this message translates to:
  /// **'The rider cancelled this trip.'**
  String get riderCancelled;

  /// No description provided for @tripFareLabel.
  ///
  /// In en, this message translates to:
  /// **'Trip fare'**
  String get tripFareLabel;

  /// No description provided for @passengerRating.
  ///
  /// In en, this message translates to:
  /// **'{rating} · {method}'**
  String passengerRating(Object method, Object rating);

  /// No description provided for @acceptance.
  ///
  /// In en, this message translates to:
  /// **'Acceptance'**
  String get acceptance;

  /// No description provided for @completion.
  ///
  /// In en, this message translates to:
  /// **'Completion'**
  String get completion;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfileTitle;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @callPassenger.
  ///
  /// In en, this message translates to:
  /// **'Call passenger'**
  String get callPassenger;

  /// No description provided for @messagePassenger.
  ///
  /// In en, this message translates to:
  /// **'Message passenger'**
  String get messagePassenger;

  /// No description provided for @communicationFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open call / messages. Please try again.'**
  String get communicationFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
