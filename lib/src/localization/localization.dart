library localization;

import 'package:flutter/widgets.dart'
    show Locale, LocalizationsDelegate, BuildContext, Localizations;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';
export 'package:flutter_localizations/flutter_localizations.dart';

const List<Locale> supportedLocales = <Locale>[
  Locale('en', ''), // English
  Locale('de', ''), // German
];

const List<LocalizationsDelegate<dynamic>> localizationDelegates =
    <LocalizationsDelegate<dynamic>>[
  Localization.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

Locale currentLocale(BuildContext context) => Localizations.localeOf(context);
bool isGermanLocaleActive(BuildContext context) =>
    Localizations.localeOf(context).isGermanLocale;
bool isEnglishLocaleActive(BuildContext context) =>
    Localizations.localeOf(context).isEnglishLocale;

extension LocaleIdentifier on Locale {
  bool get isGermanLocale => languageCode == 'de';
  bool get isEnglishLocale => languageCode == 'en';
}
