import 'package:boilerplate/redux/states/language_state.dart';
import 'package:redux/redux.dart';

class ChangeLanguageAction {
  String local;
  ChangeLanguageAction(this.local);
}

final Reducer<LanguageState> languageReducer = combineReducers<LanguageState>([
  TypedReducer<LanguageState, ChangeLanguageAction>(changeLanguage),
]);

LanguageState changeLanguage(
        LanguageState state, ChangeLanguageAction action) =>
    new LanguageState(action.local);
