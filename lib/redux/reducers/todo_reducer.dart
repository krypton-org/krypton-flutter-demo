import 'package:boilerplate/redux/states/todo_state.dart';
import 'package:redux/redux.dart';

class TransactionStartAction {
  TodoTransactionType transactionType;
  TransactionStartAction(this.transactionType);
}

class TransactionFailAction {
  String error;
  TransactionFailAction(this.error);
}

class TransactionSucceedAction {
  List<Todo> todos;
  TransactionSucceedAction(this.todos);
}

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
