import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'l10n/app_localizations.dart';
import 'widgets/app_scaffold.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = AppState();
  await appState.load();
  runApp(
    ChangeNotifierProvider.value(
      value: appState,
      child: const QasidApp(),
    ),
  );
}

class QasidApp extends StatelessWidget {
  const QasidApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'بوابة القاصد',
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
        final appState = context.watch<AppState>();
        final scale = appState.textScale;
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
          child: Directionality(
            textDirection: appState.locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
            child: child ?? const SizedBox(),
          ),
        );
      },
      home: const AppScaffold(),
    );
  }
}