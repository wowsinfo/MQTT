import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

/// This repository manages localised strings from the Game Data
class Localisation {
  static const localizationsDelegates = AppLocalizations.localizationsDelegates;
  static const supportedLocales = AppLocalizations.supportedLocales;

  /// The wrapper of [AppLocalizations].
  static AppLocalizations of(BuildContext context) {
    final i10n = AppLocalizations.of(context);
    if (i10n == null) {
      throw Exception('AppLocalizations is not working as expected.');
    }

    return i10n;
  }

  /// Decide the data language based on the device language.
  static String decideLang({String? customLang}) {
    // return 'zh';
    final lang = customLang ?? Intl.getCurrentLocale();
    final logger = Logger('Localisation|decideLang');
    logger.info('System locale is $lang');
    final langCode = lang.toLowerCase();
    if (validGameLanguages.contains(langCode)) {
      return langCode;
    }

    if (langCode.contains('_')) {
      final localeCode = langCode.split('_')[0];
      if (validGameLanguages.contains(localeCode)) {
        logger.info('Using locale `$localeCode`');
        return localeCode;
      }
    }

    logger.warning('Unsupported locale $langCode, falling back to en');
    return 'en';
  }

  /// The default locale based on the device language.
  static Locale defaultLocale() {
    final lang = decideLang();
    return Locale(lang, '');
  }

  /// The list of valid game languages.
  static const validGameLanguages = ['en', 'zh'];
}
