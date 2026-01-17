import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import 'theme.dart';
import 'localization.dart';

class MahadreApp extends StatelessWidget {
  const MahadreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'محاضر',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'SA'),
        Locale('en', 'US'),
      ],
      locale: const Locale('ar', 'SA'),
      home: const SplashScreen(),
    );
  }
}