import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    )!;
  }

  // Delegate
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // 🔤 النصوص
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'Mahadre',
      'welcome': 'Welcome',
    },
    'ar': {
      'app_title': 'محاضر',
      'welcome': 'مرحبا',
    },
  };

  String get appTitle =>
      _localizedValues[locale.languageCode]!['app_title']!;

  String get welcome =>
      _localizedValues[locale.languageCode]!['welcome']!;
}

// 🔧 Delegate class
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
