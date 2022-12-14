import 'dart:io';

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
  @Deprecated('Use [localeResolutionCallback] instead.')
  static String decideLang({String? customLang}) {
    // return 'zh';
    final lang = customLang ?? Intl.getCurrentLocale();
    print('system lang: ${Intl.defaultLocale}');
    final logger = Logger('Localisation|decideLang');
    logger.info('System locale is $lang');
    final langCode = lang.toLowerCase();
    final langIndex = validGameLanguages.indexWhere(
      (lang) => langCode.startsWith(lang),
    );

    if (langIndex >= 0) {
      return validGameLanguages[langIndex];
    }

    // if it contains '_' or '-', get the first part of the language code.
    if (langCode.contains('_') || langCode.contains('-')) {
      final localeCode = langCode.split(r'[_\-]').first;
      if (validGameLanguages.contains(localeCode)) {
        logger.info('Using locale `$localeCode`');
        return localeCode;
      }
    }

    logger.warning('Unsupported locale $langCode, falling back to en');
    return 'en';
  }

  static Locale? localeResolutionCallback(
    Locale? locale,
    Iterable<Locale> supportedLocale,
  ) {
    for (final supported in supportedLocales) {
      if (supported.languageCode == locale?.languageCode) {
        return supported;
      }
    }

    return locale;
  }

  /// The default locale based on the device language.
  static Locale defaultLocale() {
    final lang = decideLang();
    return Locale(lang, '');
  }

  /// The list of valid game languages.
  static const validGameLanguages = ['en', 'zh'];
}
