import 'package:krypton_flutter_demo/redux/actions/todo_action.dart';
import 'package:krypton_flutter_demo/redux/states/todo_state.dart';
import 'package:redux/redux.dart';

final Reducer<TodoState> todoReducer = combineReducers<TodoState>([
  TypedReducer<TodoState, TransactionStartAction>(transactionStart),
  TypedReducer<TodoState, TransactionFailAction>(transactionFail),
  TypedReducer<TodoState, TransactionSucceedAction>(transactionSucceed),
]);

TodoState transactionStart(TodoState state, TransactionStartAction action) =>
    new TodoState(
        isLoading: true,
        isSuccess: false,
        transactionType: action.transactionType,
        todos: state.todos);

TodoState transactionFail(TodoState state, TransactionFailAction action) =>
    new TodoState(
        isLoading: false,
        isSuccess: false,
        error: action.error,
        transactionType: state.transactionType,
        todos: state.todos);

TodoState transactionSucceed(
        TodoState state, TransactionSucceedAction action) =>
    new TodoState(
        isLoading: false,
        isSuccess: true,
        transactionType: state.transactionType,
        todos: action.todos);
