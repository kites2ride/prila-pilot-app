// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Prila Pilot';

  @override
  String get helloPilot => 'Hello, Pilot';

  @override
  String get continueCta => 'Continue';

  @override
  String get phoneLoginTitle => 'Enter your phone number';

  @override
  String get phoneLoginSubtitle => 'We\'ll send a one-time password';

  @override
  String get phoneHint => '10-digit mobile number';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get otpTitle => 'Enter OTP';

  @override
  String otpSubtitle(String phone) {
    return 'Code sent to $phone';
  }

  @override
  String get verifyOtp => 'Verify';

  @override
  String get permissionsTitle => 'Allow location & notifications';

  @override
  String get permissionsBody =>
      'Prila Pilot needs location while you are online to receive ride requests.';

  @override
  String get allowPermissions => 'Allow access';

  @override
  String get skipForNow => 'Not now';

  @override
  String get maintenanceTitle => 'We\'ll be right back';

  @override
  String get updateRequiredTitle => 'Update required';

  @override
  String get updateOptionalTitle => 'Update available';

  @override
  String get updateNow => 'Update now';

  @override
  String get later => 'Later';

  @override
  String get requestTab => 'Request';

  @override
  String get earningTab => 'My Earning';

  @override
  String get reviewTab => 'My Review';

  @override
  String get walletTab => 'Wallet';

  @override
  String get youAreOnline => 'You\'re Online';

  @override
  String get youAreOffline => 'You\'re Offline';

  @override
  String get accept => 'Accept';

  @override
  String get skip => 'Skip';

  @override
  String get kycTitle => 'Complete KYC';

  @override
  String get kycSubtitle => 'Upload required documents for review';

  @override
  String get underReviewTitle => 'Under review';

  @override
  String get underReviewBody =>
      'Our team is checking your documents. You\'ll be notified when approved.';

  @override
  String get rejectedTitle => 'KYC rejected';

  @override
  String get resubmit => 'Resubmit';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get logOut => 'Log Out';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get retry => 'Retry';

  @override
  String get errorGeneric => 'Something went wrong';

  @override
  String get emptyGeneric => 'Nothing here yet';

  @override
  String get upload => 'Upload';

  @override
  String get submitKyc => 'Submit for review';

  @override
  String get vehicleType => 'Vehicle type';

  @override
  String get vehicleNumber => 'Vehicle number';

  @override
  String get nameHint => 'Your name';

  @override
  String get save => 'Save';

  @override
  String get pilotAccount => 'Pilot Account';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get activeRide => 'Active ride';

  @override
  String get pickup => 'Pickup';

  @override
  String get drop => 'Drop';

  @override
  String get fare => 'Fare';

  @override
  String get iveArrived => 'I\'ve arrived';

  @override
  String get enterRideOtp => 'Enter ride OTP';

  @override
  String get startTrip => 'Start trip';

  @override
  String get completeTrip => 'Complete & collect cash';

  @override
  String get waitingOffers => 'Waiting for ride offers…';

  @override
  String get continueTrip => 'Continue trip';

  @override
  String get todaysEarnings => 'Today\'s Earnings';

  @override
  String get completedTrips => 'Completed Trips';

  @override
  String get rangeToday => 'Today';

  @override
  String get rangeWeek => 'Week';

  @override
  String get rangeMonth => 'Month';

  @override
  String get netEarnings => 'Net earnings';

  @override
  String get platformFee => 'Platform fee';

  @override
  String get earningsChart => 'Earnings chart';

  @override
  String get transactions => 'Transactions';

  @override
  String get fromReviews => 'From reviews';

  @override
  String get noReviewsYet => 'No reviews yet';

  @override
  String get withdrawableBalance => 'Withdrawable balance';

  @override
  String get platformDues => 'Platform dues';

  @override
  String get lifetimeNet => 'Lifetime net';

  @override
  String get requestPayout => 'Request payout';

  @override
  String get amountInr => 'Amount (₹)';

  @override
  String get upiId => 'UPI ID';

  @override
  String get payoutHistory => 'Payout history';

  @override
  String get payoutRequested => 'Payout requested';
}
