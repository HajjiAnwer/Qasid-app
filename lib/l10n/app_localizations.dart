import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this) ?? AppLocalizations.defaultLocalization;
}

class AppLocalizations {
  final Locale locale;
  late Map<String, String> _strings;
  bool _isLoaded = false;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = AppLocalizationsDelegate();

  static final AppLocalizations defaultLocalization = AppLocalizations(const Locale('en'));

  /// Load translation strings from JSON file
  Future<void> load() async {
    if (_isLoaded) return; // Prevent reloading

    try {
      final String languageCode = locale.languageCode;
      final String jsonPath = 'assets/i18n/$languageCode.json';
      
      final String jsonString = await rootBundle.loadString(jsonPath);
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      
      _strings = jsonMap.cast<String, String>();
      _isLoaded = true;
    } catch (e) {
      // Fallback to empty map if file not found
      debugPrint('Error loading translations for ${locale.languageCode}: $e');
      _strings = {};
      _isLoaded = true;
    }
  }

  /// Get translation by key with fallback
  String tr(String key) {
    return _strings[key] ?? key;
  }

  // Getters for all strings
  String get appTitle => tr('appTitle');
  String get home => tr('home');
  String get alfatiha => tr('alfatiha');
  String get recitations => tr('recitations');
  String get message => tr('message');
  String get settings => tr('settings');
  String get alHaram => tr('alHaram');
  String get anNabawi => tr('anNabawi');
  String get nextPrayer => tr('nextPrayer');
  String get tomorrow => tr('tomorrow');
  String get imam => tr('imam');
  String get muezzin => tr('muezzin');
  String get islamicTerms => tr('islamicTerms');
  String get islamicTermsDesc => tr('islamicTermsDesc');
  String get haramRecitations => tr('haramRecitations');
  String get haramRecitationsDesc => tr('haramRecitationsDesc');
  String get selectedSupplications => tr('selectedSupplications');
  String get selectedSupplicationsDesc => tr('selectedSupplicationsDesc');
  String get howToPerformWudu => tr('howToPerformWudu');
  String get howToPerformWuduDesc => tr('howToPerformWuduDesc');
  String get howToPray => tr('howToPray');
  String get howToPrayDesc => tr('howToPrayDesc');
  String get holyPlaces => tr('holyPlaces');
  String get holyPlacesDesc => tr('holyPlacesDesc');
  String get maqdaahAlHarameen => tr('maqdaahAlHarameen');
  String get risalaAlHarameen => tr('risalaAlHarameen');
  String get electronicServices => tr('electronicServices');
  String get tawafRecitations => tr('tawafRecitations');
  String get tawafRecitationsDesc => tr('tawafRecitationsDesc');
  String get loading => tr('loading');
  String get error => tr('error');
  String get tryAgain => tr('tryAgain');
  String get noData => tr('noData');
  String get fajr => tr('fajr');
  String get preFajr => tr('preFajr');
  String get dhuhr => tr('dhuhr');
  String get asr => tr('asr');
  String get maghrib => tr('maghrib');
  String get isha => tr('isha');
  String get language => tr('language');
  String get selectMosque => tr('selectMosque');
  String get about => tr('about');
  String get version => tr('version');
  String get appName => tr('appName');
  String get arabic => tr('arabic');
  String get english => tr('english');
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
