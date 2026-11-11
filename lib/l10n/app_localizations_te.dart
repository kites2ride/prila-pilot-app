// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appName => 'Prila Pilot';

  @override
  String get helloPilot => 'నమస్కారం, పైలట్';

  @override
  String get continueCta => 'కొనసాగించండి';

  @override
  String get phoneLoginTitle => 'మీ ఫోన్ నంబర్ ఇవ్వండి';

  @override
  String get phoneLoginSubtitle => 'మేము ఒక OTP పంపుతాము';

  @override
  String get phoneHint => '10 అంకెల మొబైల్ నంబర్';

  @override
  String get sendOtp => 'OTP పంపండి';

  @override
  String get otpTitle => 'OTP నమోదు చేయండి';

  @override
  String otpSubtitle(String phone) {
    return '$phone కు కోడ్ పంపబడింది';
  }

  @override
  String get verifyOtp => 'నిర్ధారించండి';

  @override
  String get permissionsTitle => 'లొకేషన్ & నోటిఫికేషన్లు అనుమతించండి';

  @override
  String get permissionsBody =>
      'మీరు ఆన్‌లైన్‌లో ఉన్నప్పుడు రైడ్ రిక్వెస్ట్‌ల కోసం లొకేషన్ అవసరం.';

  @override
  String get allowPermissions => 'అనుమతించండి';

  @override
  String get skipForNow => 'ఇప్పుడు కాదు';

  @override
  String get maintenanceTitle => 'త్వరలో తిరిగి వస్తాము';

  @override
  String get updateRequiredTitle => 'అప్‌డేట్ అవసరం';

  @override
  String get updateOptionalTitle => 'అప్‌డేట్ అందుబాటులో ఉంది';

  @override
  String get updateNow => 'ఇప్పుడు అప్‌డేట్ చేయండి';

  @override
  String get later => 'తర్వాత';

  @override
  String get requestTab => 'రిక్వెస్ట్';

  @override
  String get earningTab => 'నా ఆదాయం';

  @override
  String get reviewTab => 'నా రివ్యూ';

  @override
  String get walletTab => 'వాలెట్';

  @override
  String get youAreOnline => 'మీరు ఆన్‌లైన్‌లో ఉన్నారు';

  @override
  String get youAreOffline => 'మీరు ఆఫ్‌లైన్‌లో ఉన్నారు';

  @override
  String get accept => 'అంగీకరించు';

  @override
  String get skip => 'దాటవేయి';

  @override
  String get kycTitle => 'KYC పూర్తి చేయండి';

  @override
  String get kycSubtitle => 'సమీక్ష కోసం అవసరమైన పత్రాలు అప్‌లోడ్ చేయండి';

  @override
  String get underReviewTitle => 'సమీక్షలో ఉంది';

  @override
  String get underReviewBody =>
      'మా టీమ్ మీ పత్రాలను తనిఖీ చేస్తోంది. ఆమోదం తర్వాత తెలియజేస్తాము.';

  @override
  String get rejectedTitle => 'KYC తిరస్కరించబడింది';

  @override
  String get resubmit => 'మళ్లీ సమర్పించండి';

  @override
  String get darkMode => 'డార్క్ మోడ్';

  @override
  String get language => 'భాష';

  @override
  String get logOut => 'లాగ్ అవుట్';

  @override
  String get deleteAccount => 'అకౌంట్ తొలగించండి';

  @override
  String get retry => 'మళ్లీ ప్రయత్నించండి';

  @override
  String get errorGeneric => 'ఏదో తప్పు జరిగింది';

  @override
  String get emptyGeneric => 'ఇంకా ఏమీ లేదు';

  @override
  String get upload => 'అప్‌లోడ్';

  @override
  String get submitKyc => 'సమీక్షకు సమర్పించండి';

  @override
  String get vehicleType => 'వాహన రకం';

  @override
  String get vehicleNumber => 'వాహన నంబర్';

  @override
  String get nameHint => 'మీ పేరు';

  @override
  String get save => 'సేవ్';

  @override
  String get pilotAccount => 'పైలట్ అకౌంట్';

  @override
  String versionLabel(String version) {
    return 'వెర్షన్ $version';
  }

  @override
  String get activeRide => 'యాక్టివ్ రైడ్';

  @override
  String get pickup => 'పికప్';

  @override
  String get drop => 'డ్రాప్';

  @override
  String get fare => 'ఛార్జీ';

  @override
  String get iveArrived => 'నేను వచ్చాను';

  @override
  String get enterRideOtp => 'రైడ్ OTP నమోదు';

  @override
  String get startTrip => 'ట్రిప్ ప్రారంభించండి';

  @override
  String get completeTrip => 'పూర్తి చేసి క్యాష్ తీసుకోండి';

  @override
  String get waitingOffers => 'రైడ్ ఆఫర్ల కోసం వేచి ఉన్నారు…';

  @override
  String get continueTrip => 'ట్రిప్ కొనసాగించండి';

  @override
  String get todaysEarnings => 'నేటి ఆదాయం';

  @override
  String get completedTrips => 'పూర్తైన ట్రిప్స్';

  @override
  String get rangeToday => 'ఈరోజు';

  @override
  String get rangeWeek => 'వారం';

  @override
  String get rangeMonth => 'నెల';

  @override
  String get netEarnings => 'నికర ఆదాయం';

  @override
  String get platformFee => 'ప్లాట్‌ఫామ్ ఫీజు';

  @override
  String get earningsChart => 'ఆదాయ చార్ట్';

  @override
  String get transactions => 'లావాదేవీలు';

  @override
  String get fromReviews => 'రివ్యూల నుండి';

  @override
  String get noReviewsYet => 'ఇంకా రివ్యూలు లేవు';

  @override
  String get withdrawableBalance => 'ఉపసంహరించదగిన బ్యాలెన్స్';

  @override
  String get platformDues => 'ప్లాట్‌ఫామ్ బకాయిలు';

  @override
  String get lifetimeNet => 'మొత్తం నికరం';

  @override
  String get requestPayout => 'పేఅవుట్ అభ్యర్థన';

  @override
  String get amountInr => 'మొత్తం (₹)';

  @override
  String get upiId => 'UPI ID';

  @override
  String get payoutHistory => 'పేఅవుట్ చరిత్ర';

  @override
  String get payoutRequested => 'పేఅవుట్ అభ్యర్థించబడింది';
}
