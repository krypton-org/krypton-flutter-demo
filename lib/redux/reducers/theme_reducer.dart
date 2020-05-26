import 'package:boilerplate/redux/actions/theme_action.dart';
import 'package:boilerplate/redux/states/theme_state.dart';
import 'package:redux/redux.dart';

final Reducer<ThemeState> themeReducer = combineReducers<ThemeState>([
  TypedReducer<ThemeState, DarkThemeAction>(enableDarkTheme),
  TypedReducer<ThemeState, BrightThemeAction>(disableDarkTheme),
]);

ThemeState enableDarkTheme(ThemeState state, DarkThemeAction action) =>
    new ThemeState(true);
ThemeState disableDarkTheme(ThemeState state, BrightThemeAction action) =>
    new ThemeState(false);
