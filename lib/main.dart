import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app_state.dart';
import 'l10n/app_localizations.dart';
import 'widgets/app_scaffold.dart';
import 'features/Loading/loading_screen.dart';
import 'models/person.dart';
import 'models/prayer_time.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppInitializer());
}

/// AppInitializer ensures async setup is safe for cold launch
class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  late final Future<AppState> _appStateFuture;

  @override
  void initState() {
    super.initState();
    _appStateFuture = _initializeApp();
  }

  Future<AppState> _initializeApp() async {
    try {
      // Hive setup
      await Hive.initFlutter();
      Hive.registerAdapter(PersonAdapter());
      Hive.registerAdapter(PrayerTimeAdapter());

      await Hive.openBox('prayer_cache');
      await Hive.openBox('prayer_cache_meta');

      // Load AppState
      final appState = AppState();
      await appState.load();
      return appState;
    } catch (e, st) {
      print("App initialization failed: $e\n$st");
      // Return default AppState so app still opens
      return AppState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppState>(
      future: _appStateFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          // Temporary loading screen
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final appState = snapshot.data!;

        return ChangeNotifierProvider.value(
          value: appState,
          child: const QasidApp(),
        );
      },
    );
  }
}

class QasidApp extends StatelessWidget {
  const QasidApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'تطبيق القاصد',
      locale: appState.locale,
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supported) {
        if (locale == null) return const Locale('ar');
        for (var s in supported) {
          if (s.languageCode == locale.languageCode) return s;
        }
        return const Locale('ar');
      },
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'SF Pro',
        brightness: Brightness.light,
      ),
      builder: (context, child) {
        final scale = appState.fontScale;
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
          child: Directionality(
            textDirection:
            appState.locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
            child: child ?? const SizedBox(),
          ),
        );
      },
      home: const LoadingScreen(),
    );
  }
}
