import 'package:boilerplate/models/language/Language.dart';

List<Language> supportedLanguages = [
  Language(code: 'US', locale: 'en', language: 'English'),
  Language(code: 'DK', locale: 'da', language: 'Danish'),
  Language(code: 'ES', locale: 'es', language: 'España'),
];

class LanguageState {
  String _locale = "en";

  String get locale => _locale;

  LanguageState(this._locale);

  String getCode() {
    var code;
    if (_locale == 'en') {
      code = "US";
    } else if (_locale == 'da') {
      code = "DK";
    } else if (_locale == 'es') {
      code = "ES";
    }
    return code;
  }

  String getLanguage() {
    return supportedLanguages[supportedLanguages
            .indexWhere((language) => language.locale == _locale)]
        .language;
  }
}

LanguageState getInitLanguageState() => LanguageState('en');
