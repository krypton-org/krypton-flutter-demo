import 'package:krypton_flutter_demo/utils/language/Language.dart';

List<Language> supportedLanguages = [
  Language(code: 'US', locale: 'en', language: 'English'),
  Language(code: 'DK', locale: 'da', language: 'Danish'),
  Language(code: 'ES', locale: 'es', language: 'España'),
];

class LanguageState {
  String _locale = "en";

  String get locale => _locale;

  LanguageState(this._locale);

  static LanguageState fromJson(dynamic json) => LanguageState(json["locale"]);

  dynamic toJson() => {'locale': _locale};

  String getLanguage() {
    return supportedLanguages[supportedLanguages
            .indexWhere((language) => language.locale == _locale)]
        .language;
  }
}
// Pass null in argument to use the phone's defined language.
LanguageState getInitLanguageState() => LanguageState(null);
