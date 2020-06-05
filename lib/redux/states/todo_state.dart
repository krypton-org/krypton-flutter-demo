class TodoState {
  bool isLoading;
  bool isSuccess;
  String error;
  TodoTransactionType transactionType;
  List<Todo> todos;
  TodoState(
      {this.isLoading,
      this.isSuccess,
      this.error,
      this.transactionType,
      this.todos});
}

enum TodoTransactionType {
  ADD_TODO,
  DELETE_TODO,
  UPDATE_TODO,
  FETCH_TODO,
}

class Todo {
  String text;
  bool isCompleted;
  DateTime date;
  String id;
  Todo({this.text, this.isCompleted, this.date, this.id});
}

TodoState getInitTodoState() =>
    TodoState(isLoading: false, isSuccess: false, todos: null);
