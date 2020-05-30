import 'package:boilerplate/redux/reducers/auth_reducer.dart';
import 'package:boilerplate/redux/reducers/language_reducer.dart';
import 'package:boilerplate/redux/reducers/notifier_reducer.dart';
import 'package:boilerplate/redux/reducers/theme_reducer.dart';
import 'package:boilerplate/redux/reducers/todo_reducer.dart';
import 'package:boilerplate/redux/states/auth_state.dart';
import 'package:boilerplate/redux/states/language_state.dart';
import 'package:boilerplate/redux/states/notify_state.dart';
import 'package:boilerplate/redux/states/theme_state.dart';
import 'package:boilerplate/redux/states/todo_state.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class AppState {
  AuthState auth;
  LanguageState language;
  Notification notification;
  ThemeState theme;
  TodoState todos;
  AppState(this.auth, this.language, this.notification, this.theme, this.todos);
}

AppState appStateReducer(AppState state, action) => new AppState(
  authReducer(state.auth, action),
  languageReducer(state.language, action),
  notifyReducer(state.notification, action),
  themeReducer(state.theme, action),
  todoReducer(state.todos, action),
);

AppState initState() => AppState(
  getInitAuthState(),
  getInitLanguageState(),
  getInitNotifyState(),
  getInitThemeState(),
  getInitTodoState()
);

Store<AppState> getStore() => Store<AppState>(
    appStateReducer,
    initialState: initState(),
    middleware: [thunkMiddleware],
  );
