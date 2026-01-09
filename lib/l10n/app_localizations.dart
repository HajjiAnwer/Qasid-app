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

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this) ?? AppLocalizations.defaultLocalization;
}

abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
  static final AppLocalizations defaultLocalization = AppLocalizationsAr();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
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

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Qasid Portal'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @alfatiha.
  ///
  /// In en, this message translates to:
  /// **'Al-Fatiha'**
  String get alfatiha;

  /// No description provided for @recitations.
  ///
  /// In en, this message translates to:
  /// **'Recitations'**
  String get recitations;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @alHaram.
  ///
  /// In en, this message translates to:
  /// **'Al-Haram'**
  String get alHaram;

  /// No description provided for @anNabawi.
  ///
  /// In en, this message translates to:
  /// **'An-Nabawi'**
  String get anNabawi;

  /// No description provided for @nextPrayer.
  ///
  /// In en, this message translates to:
  /// **'Next Prayer'**
  String get nextPrayer;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @imam.
  ///
  /// In en, this message translates to:
  /// **'Imam'**
  String get imam;

  /// No description provided for @muezzin.
  ///
  /// In en, this message translates to:
  /// **'Muezzin'**
  String get muezzin;

  /// No description provided for @islamicTerms.
  ///
  /// In en, this message translates to:
  /// **'Islamic Terms'**
  String get islamicTerms;

  /// No description provided for @islamicTermsDesc.
  ///
  /// In en, this message translates to:
  /// **'A service explaining Islamic legal terms in a simplified and clear manner'**
  String get islamicTermsDesc;

  /// No description provided for @haramRecitations.
  ///
  /// In en, this message translates to:
  /// **'Haram Recitations'**
  String get haramRecitations;

  /// No description provided for @haramRecitationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Audio service for the recitations of the Imams of the Sacred Mosque'**
  String get haramRecitationsDesc;

  /// No description provided for @selectedSupplications.
  ///
  /// In en, this message translates to:
  /// **'Selected Supplications'**
  String get selectedSupplications;

  /// No description provided for @selectedSupplicationsDesc.
  ///
  /// In en, this message translates to:
  /// **'A service offering selected reported supplications in their authentic form'**
  String get selectedSupplicationsDesc;

  /// No description provided for @howToPerformWudu.
  ///
  /// In en, this message translates to:
  /// **'How to Perform Wudu'**
  String get howToPerformWudu;

  /// No description provided for @howToPerformWuduDesc.
  ///
  /// In en, this message translates to:
  /// **'A service for the concise and simple explanation of the Prophet\'s ablution'**
  String get howToPerformWuduDesc;

  /// No description provided for @howToPray.
  ///
  /// In en, this message translates to:
  /// **'How to Pray'**
  String get howToPray;

  /// No description provided for @howToPrayDesc.
  ///
  /// In en, this message translates to:
  /// **'A service illustrating the Prophet\'s manner of prayer step by step with clarity'**
  String get howToPrayDesc;

  /// No description provided for @holyPlaces.
  ///
  /// In en, this message translates to:
  /// **'Holy Places'**
  String get holyPlaces;

  /// No description provided for @holyPlacesDesc.
  ///
  /// In en, this message translates to:
  /// **'An introductory service on the sacred places in Islam and their great status'**
  String get holyPlacesDesc;

  /// No description provided for @maqdaahAlHarameen.
  ///
  /// In en, this message translates to:
  /// **'Maqraa Al-Harameen'**
  String get maqdaahAlHarameen;

  /// No description provided for @risalaAlHarameen.
  ///
  /// In en, this message translates to:
  /// **'Risala Al-Harameen'**
  String get risalaAlHarameen;

  /// No description provided for @electronicServices.
  ///
  /// In en, this message translates to:
  /// **'Electronic Services\nfor the Two Holy Mosques'**
  String get electronicServices;

  /// No description provided for @tawafRecitations.
  ///
  /// In en, this message translates to:
  /// **'Tawaf Recitations'**
  String get tawafRecitations;

  /// No description provided for @tawafRecitationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Audio service for the recitations of the Imams of the Sacred Mosque'**
  String get tawafRecitationsDesc;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @fajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get fajr;

  /// No description provided for @preFajr.
  ///
  /// In en, this message translates to:
  /// **'Pre-Fajr'**
  String get preFajr;

  /// No description provided for @dhuhr.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get dhuhr;

  /// No description provided for @asr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get asr;

  /// No description provided for @maghrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get maghrib;

  /// No description provided for @isha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get isha;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectMosque.
  ///
  /// In en, this message translates to:
  /// **'Select Mosque'**
  String get selectMosque;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get version;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Qasid application'**
  String get appName;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @titleApp.
  ///
  /// In en, this message translates to:
  /// **'Qasid application'**
  String get titleApp;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @liveStream.
  ///
  /// In en, this message translates to:
  /// **'Live Stream'**
  String get liveStream;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
