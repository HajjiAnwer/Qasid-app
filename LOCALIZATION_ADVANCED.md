# Advanced Localization System - Implementation Guide

## What Changed?

Your app now uses a **JSON-based dynamic localization system** instead of static maps. This is production-ready and scalable to 1000+ strings!

## Architecture Overview

```
assets/
  └── i18n/
      ├── en.json        ← English translations (JSON format)
      ├── ar.json        ← Arabic translations (JSON format)
      └── fr.json        ← Future: French translations (just add this file!)

lib/l10n/
  └── app_localizations.dart   ← Service that loads JSON files dynamically
```

## Key Benefits

✅ **Scalable** - Handle 1000+ strings easily
✅ **Easy to add languages** - Just add a new JSON file
✅ **No code changes needed** - Add strings to JSON, they work automatically
✅ **Professional** - Used by major apps like Google, Facebook
✅ **Easy maintenance** - JSON files are human-readable
✅ **Translation-friendly** - Can be managed by translators without code knowledge

## How It Works

1. **At app startup**, when locale changes → `AppLocalizationsDelegate.load()` is called
2. **Loads the JSON file** from `assets/i18n/{languageCode}.json`
3. **Parses JSON** into a Map
4. **Returns AppLocalizations** instance with loaded strings
5. **Usage**: `context.l10n.home` returns the correct translation

## Adding a New Language (e.g., French)

### Step 1: Create `assets/i18n/fr.json`

```json
{
  "appTitle": "Portail Qasid",
  "home": "Accueil",
  "settings": "Paramètres",
  "alfatiha": "Al-Fatiha",
  "recitations": "Récitations",
  "message": "Message",
  "alHaram": "Al-Haram",
  "anNabawi": "An-Nabawi",
  "nextPrayer": "Prière suivante",
  "tomorrow": "Demain",
  "imam": "Imam",
  "muezzin": "Muezzin",
  "islamicTerms": "Termes islamiques",
  "islamicTermsDesc": "Un service expliquant les termes juridiques islamiques de manière simplifiée et claire",
  "haramRecitations": "Récitations du Haram",
  "haramRecitationsDesc": "Service audio pour les récitations des Imams de la Mosquée Sacrée",
  "selectedSupplications": "Supplications sélectionnées",
  "selectedSupplicationsDesc": "Un service offrant des supplications rapportées sélectionnées sous leur forme authentique",
  "howToPerformWudu": "Comment faire les ablutions",
  "howToPerformWuduDesc": "Un service pour l'explication concise et simple des ablutions du Prophète",
  "howToPray": "Comment prier",
  "howToPrayDesc": "Un service illustrant la manière de prier du Prophète étape par étape avec clarté",
  "holyPlaces": "Lieux sacrés",
  "holyPlacesDesc": "Un service d'introduction sur les lieux sacrés en Islam et leur grand statut",
  "maqdaahAlHarameen": "Maqraa Al-Harameen",
  "risalaAlHarameen": "Risala Al-Harameen",
  "electronicServices": "Services électroniques\npour les Deux Mosquées Sacrées",
  "tawafRecitations": "Récitations de Tawaf",
  "tawafRecitationsDesc": "Service audio pour les récitations des Imams de la Mosquée du Prophète",
  "loading": "Chargement...",
  "error": "Erreur",
  "tryAgain": "Réessayer",
  "noData": "Aucune donnée disponible"
}
```

### Step 2: Update `main.dart` to support French

```dart
supportedLocales: const [
  Locale('ar'),   // Arabic
  Locale('en'),   // English
  Locale('fr'),   // ← Add French
],
```

### Step 3: Update `app_localizations.dart` delegate

```dart
@override
bool isSupported(Locale locale) {
  return ['en', 'ar', 'fr'].contains(locale.languageCode);  // ← Add 'fr'
}
```

**That's it!** The French language now works automatically! 🎉

## Adding New Translation Keys

### To add a new string (e.g., "welcome"):

1. **Add to all JSON files:**

**en.json:**
```json
{
  ...
  "welcome": "Welcome to Qasid Portal",
  ...
}
```

**ar.json:**
```json
{
  ...
  "welcome": "أهلا وسهلا بك في بوابة القاصد",
  ...
}
```

2. **Add getter to `app_localizations.dart`** (optional, but recommended):

```dart
String get welcome => tr('welcome');
```

3. **Use in your widget:**

```dart
Text(context.l10n.welcome);
// OR
Text(context.l10n.tr('welcome'));
```

## File Structure

```
qasid_app/
├── assets/
│   └── i18n/
│       ├── en.json          (English - 30+ strings)
│       ├── ar.json          (Arabic - 30+ strings)
│       └── fr.json          (French - optional, 30+ strings)
├── lib/
│   ├── l10n/
│   │   └── app_localizations.dart  (Service - handles loading)
│   ├── main.dart            (Configure supported locales)
│   └── ...
└── pubspec.yaml            (Assets declared)
```

## API Reference

### In any Widget:

```dart
// Get localization instance
final l10n = context.l10n;

// Use pre-defined getters
Text(l10n.home)           // "Home" or "الرئيسية"
Text(l10n.settings)       // "Settings" or "الإعدادات"

// Use dynamic translation
Text(l10n.tr('customKey')) // Works for any key in JSON
```

### Available Keys

Current supported keys:
- Navigation: `home`, `alfatiha`, `recitations`, `message`, `settings`
- Mosques: `alHaram`, `anNabawi`
- Prayer: `nextPrayer`, `tomorrow`, `imam`, `muezzin`
- Services: `islamicTerms`, `haramRecitations`, `selectedSupplications`, `howToPerformWudu`, `howToPray`, `holyPlaces`
- General: `loading`, `error`, `tryAgain`, `noData`

## Performance

✨ **Optimized for performance:**
- JSON loaded only once per language
- Cached in memory
- No repeated file reads
- Fallback to English if key not found
- No external dependencies needed

## Troubleshooting

### Strings not updating after language change?

Make sure you're using `context.l10n` inside a widget that rebuilds when locale changes.

```dart
// ✅ Correct
Widget build(BuildContext context) {
  final l10n = context.l10n;  // Gets new instance when locale changes
  return Text(l10n.home);
}

// ❌ Avoid
final l10n = context.l10n;    // Called outside build()
```

### Missing translations for a language?

The app will fallback to English. Check:
1. JSON file exists: `assets/i18n/{languageCode}.json`
2. File is listed in `pubspec.yaml` under assets
3. Locale is in `supportedLocales` in `main.dart`
4. Language code is in `isSupported()` in `AppLocalizationsDelegate`

### JSON syntax error?

Use a JSON validator: https://jsonlint.com/
Common issues:
- Missing commas between properties
- Unescaped quotes in strings
- Trailing commas

## Future Enhancements

- Add Localization UI screenshot validation
- Auto-generate getters from JSON
- Add Firebase Realtime Config for dynamic updates
- Cloud-based translation management

---

**Questions?** This system is production-ready and used by companies worldwide! 🚀
