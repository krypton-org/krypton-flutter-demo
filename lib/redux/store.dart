import 'package:krypton_flutter_demo/redux/reducers/auth_reducer.dart';
import 'package:krypton_flutter_demo/redux/reducers/language_reducer.dart';
import 'package:krypton_flutter_demo/redux/reducers/notifier_reducer.dart';
import 'package:krypton_flutter_demo/redux/reducers/theme_reducer.dart';
import 'package:krypton_flutter_demo/redux/reducers/todo_reducer.dart';
import 'package:krypton_flutter_demo/redux/states/auth_state.dart';
import 'package:krypton_flutter_demo/redux/states/language_state.dart';
import 'package:krypton_flutter_demo/redux/states/notify_state.dart';
import 'package:krypton_flutter_demo/redux/states/theme_state.dart';
import 'package:krypton_flutter_demo/redux/states/todo_state.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class AppState {
  AuthState auth;
  LanguageState language;
  Notification notification;
  ThemeState theme;
  TodoState todos;
  AppState(
      {this.auth, this.language, this.notification, this.theme, this.todos});

  static AppState fromJson(dynamic json) {
    if (json == null) {
      return null;
    } else {
      return AppState(
          auth: getInitAuthState(),
          language: LanguageState.fromJson(json["language"]),
          notification: getInitNotifyState(),
          theme: ThemeState.fromJson(json["theme"]),
          todos: getInitTodoState());
    }
  }

  dynamic toJson() => {'language': language.toJson(), 'theme': theme.toJson()};
}

AppState appStateReducer(AppState state, action) => new AppState(
      auth: authReducer(state.auth, action),
      language: languageReducer(state.language, action),
      notification: notifyReducer(state.notification, action),
      theme: themeReducer(state.theme, action),
      todos: todoReducer(state.todos, action),
    );

AppState initState() => AppState(
    auth: getInitAuthState(),
    language: getInitLanguageState(),
    notification: getInitNotifyState(),
    theme: getInitThemeState(),
    todos: getInitTodoState());
