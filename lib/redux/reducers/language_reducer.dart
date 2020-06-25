import 'package:krypton_flutter_demo/redux/actions/language_actions.dart';
import 'package:krypton_flutter_demo/redux/states/language_state.dart';
import 'package:redux/redux.dart';

final Reducer<LanguageState> languageReducer = combineReducers<LanguageState>([
  TypedReducer<LanguageState, ChangeLanguageAction>(changeLanguage),
]);

LanguageState changeLanguage(
        LanguageState state, ChangeLanguageAction action) =>
    new LanguageState(action.local);
