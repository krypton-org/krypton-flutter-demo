import 'package:boilerplate/redux/actions/auth_actions.dart';
import 'package:boilerplate/redux/states/auth_state.dart';
import 'package:redux/redux.dart';

final Reducer<AuthState> authReducer = combineReducers<AuthState>([
  TypedReducer<AuthState, TransactionStartAction>(transactionStart),
  TypedReducer<AuthState, TransactionFailAction>(transactionFail),
  TypedReducer<AuthState, TransactionSucceedAction>(transactionSucceed),
  TypedReducer<AuthState, AddloggedUserAction>(addLoggedUser),
  TypedReducer<AuthState, RemoveloggedUserAction>(removeLoggedUser),
]);

AuthState addLoggedUser(AuthState state, AddloggedUserAction action) =>
    new AuthState(
      isLoading: state.isLoading,
      isSuccess: state.isSuccess,
      transactionType: state.transactionType,
      isLoggedIn: true,
      user: action.user,
    );

AuthState removeLoggedUser(AuthState state, RemoveloggedUserAction action) =>
    new AuthState(
      isLoading: state.isLoading,
      isSuccess: state.isSuccess,
      transactionType: state.transactionType,
      isLoggedIn: false,
      user: null,
    );

AuthState transactionStart(AuthState state, TransactionStartAction action) =>
    new AuthState(
        isLoading: true,
        isSuccess: false,
        transactionType: action.transactionType,
        isLoggedIn: state.isLoggedIn,
        user: state.user);

AuthState transactionFail(AuthState state, TransactionFailAction action) =>
    new AuthState(
        isLoading: false,
        isSuccess: false,
        error: action.error,
        isLoggedIn: state.isLoggedIn,
        user: state.user);

AuthState transactionSucceed(
        AuthState state, TransactionSucceedAction action) =>
    new AuthState(
        isLoading: false,
        isSuccess: true,
        isLoggedIn: state.isLoggedIn,
        user: state.user);
