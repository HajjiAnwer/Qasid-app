# Qasid Portal App - Localization Guide

## Overview

This app now has complete multi-language support with native localization for Arabic (AR) and English (EN).

## How Localization Works

### 1. **Translation Files** (`lib/l10n/`)

- **`app_en.arb`** - English translations (JSON format)
- **`app_ar.arb`** - Arabic translations (JSON format)
- **`app_localizations.dart`** - Service class for accessing translations

### 2. **Using Translations in Widgets**

The easiest way to use translations in any widget:

```dart
final l10n = context.l10n;

// Access translations as properties
Text(l10n.home)          // "Home" or "الرئيسية"
Text(l10n.nextPrayer)    // "Next Prayer" or "الأذان التالي"
Text(l10n.imam)          // "Imam" or "الإمام"
```

### 3. **Adding New Translations**

To add a new translation, follow these steps:

1. **Add to English file** (`lib/l10n/app_en.arb`):
```json
{
  "myNewKey": "My new text in English"
}
```

2. **Add to Arabic file** (`lib/l10n/app_ar.arb`):
```json
{
  "myNewKey": "نصي الجديد بالعربية"
}
```

3. **Add getter to `app_localizations.dart`**:
```dart
String get myNewKey => tr('myNewKey');
```

4. **Use in your widget**:
```dart
final l10n = context.l10n;
Text(l10n.myNewKey);
```

## Current Supported Strings

### Navigation
- `home` - Home screen
- `alfatiha` - Al-Fatiha page
- `recitations` - Recitations page
- `message` - Message page
- `settings` - Settings page

### Mosques
- `alHaram` - Al-Haram Mosque (Mecca)
- `anNabawi` - An-Nabawi Mosque (Madinah)

### Prayer
- `nextPrayer` - Next Prayer
- `tomorrow` - Tomorrow
- `imam` - Imam name
- `muezzin` - Muezzin (Caller of prayer)

### Services
- `islamicTerms` - Islamic Terms
- `islamicTermsDesc` - Description
- `haramRecitations` - Haram Recitations
- `haramRecitationsDesc` - Description
- `selectedSupplications` - Selected Supplications
- `selectedSupplicationsDesc` - Description
- `howToPerformWudu` - How to Perform Wudu
- `howToPerformWuduDesc` - Description
- `howToPray` - How to Pray
- `howToPrayDesc` - Description
- `holyPlaces` - Holy Places
- `holyPlacesDesc` - Description

### Pages
- `maqdaahAlHarameen` - Maqraa Al-Harameen
- `risalaAlHarameen` - Risala Al-Harameen
- `electronicServices` - Electronic Services (Header text)

### General
- `loading` - Loading message
- `error` - Error message
- `tryAgain` - Try Again button
- `noData` - No Data Available

## Language Switching

Users can switch languages through the Settings page. The app automatically updates all UI elements when the language is changed.

The language preference is stored in `AppState` and persisted using `shared_preferences`.

## Extension Helper

For convenience, an extension is available to access translations:

```dart
// In any widget build method:
final l10n = context.l10n;

// Or use it directly:
Text(context.l10n.home)
```

## Files Updated

- `lib/main.dart` - Added AppLocalizations delegate
- `lib/widgets/app_scaffold.dart` - Updated to use localization
- `lib/features/home/home_page.dart` - Updated to use localization
- `lib/features/home/home_services_section.dart` - Refactored to use localization keys
- `lib/features/settings/settings_page.dart` - Updated to use localization
- `pubspec.yaml` - Added `generate: true` flag

## Testing Localization

To test different languages:

1. Go to Settings page
2. Select desired language (Arabic/English)
3. All UI elements should update immediately

## Future Enhancements

To add more languages in the future:

1. Create new ARB file (e.g., `app_fr.arb` for French)
2. Add language code to supported locales in `main.dart`
3. Add translations for all keys
4. Add getter methods to `AppLocalizations` class

---

**Note**: This localization system uses a custom implementation. It does NOT require external packages like `easy_localization` or `intl_utils`.
