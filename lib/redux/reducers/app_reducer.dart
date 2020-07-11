import 'package:krypton_flutter_demo/redux/actions/app_actions.dart';
import 'package:krypton_flutter_demo/redux/reducers/auth_reducer.dart';
import 'package:krypton_flutter_demo/redux/reducers/language_reducer.dart';
import 'package:krypton_flutter_demo/redux/reducers/notifier_reducer.dart';
import 'package:krypton_flutter_demo/redux/reducers/theme_reducer.dart';
import 'package:krypton_flutter_demo/redux/reducers/todo_reducer.dart';
import 'package:krypton_flutter_demo/redux/states/app_state.dart';
import 'package:redux/redux.dart';

final Reducer<AppState> appReducer = combineReducers<AppState>([
  TypedReducer<AppState, ResetStateAction>(resetState),
  TypedReducer<AppState, dynamic>(subReducers),
]);

AppState resetState(AppState state, ResetStateAction action) =>
    initState();
AppState subReducers(AppState state, dynamic action) =>
    new AppState(
      auth: authReducer(state.auth, action),
      language: languageReducer(state.language, action),
      notification: notifyReducer(state.notification, action),
      theme: themeReducer(state.theme, action),
      todos: todoReducer(state.todos, action),
    );