import 'package:boilerplate/redux/states/todo_state.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../store.dart';

// export const addTodo = (text: string) => {
//     return async (dispatch: any, getState: () => RootState) => {
//         dispatch(transactionBegin(TodoTransactionType.ADD_TODO));
//         try {
//             const graphQLQuery = addTodoQuery(text, getState().auth.krypton.getUser()._id);
//             const res = await sendRequest(getState().auth.krypton.getAuthorizationHeader(), graphQLQuery);
//             if (res.data) {
//                 const todo = res.data.todoCreateOne.record;
//                 dispatch(transactionSuccess([todo, ...getState().todo.list]));
//             } else {
//                 throw new Error('Transaction failed');
//             }
//         } catch (err) {
//             dispatch(transactionFailure());
//             dispatch(
//                 notify({
//                     message: err.message,
//                     date: new Date(),
//                     type: Severity.DANGER,
//                 }),
//             );
//         }
//     };
// };

ThunkAction<AppState> addTodo(String text) {
  return (Store<AppState> store) async {
    store.dispatch(
        new TransactionStartAction(TodoTransactionType.ADD_TODO));
    try {
      const graphQLQuery = "";//addTodoQuery(text, getState().auth.krypton.getUser()._id);
      const res = null;//await sendRequest(getState().auth.krypton.getAuthorizationHeader(), graphQLQuery);
      if (res.data) {
          Todo todo = new Todo();//res.data.todoCreateOne.record;
          store.state.todos.todos.add(todo);
          store.dispatch(new TransactionSucceedAction(store.state.todos.todos));
      } else {
          throw new Exception('Transaction failed');
      }
    } catch (e) {
      store.dispatch(TransactionFailAction(e.toString()));
    }
  };
}


// export const deleteTodo = (todoId: string) => {
//     return async (dispatch: any, getState: () => RootState) => {
//         dispatch(transactionBegin(TodoTransactionType.DELETE_TODO));
//         try {
//             const graphQLQuery = deleteTodoQuery(todoId);
//             const res = await sendRequest(getState().auth.krypton.getAuthorizationHeader(), graphQLQuery);
//             if (res.data) {
//                 const todos = getState().todo.list.filter((todo) => todo._id !== res.data.todoRemoveById.record._id);
//                 dispatch(transactionSuccess(todos));
//             } else {
//                 throw new Error('Transaction failed');
//             }
//         } catch (err) {
//             dispatch(transactionFailure());
//             dispatch(
//                 notify({
//                     message: err.message,
//                     date: new Date(),
//                     type: Severity.DANGER,
//                 }),
//             );
//         }
//     };
// };

ThunkAction<AppState> deleteTodo(String todoId) {
  return (Store<AppState> store) async {
    store.dispatch(
        new TransactionStartAction(TodoTransactionType.DELETE_TODO));
    try {
      const graphQLQuery = "";//addTodoQuery(text, getState().auth.krypton.getUser()._id);
      const res = null;//await sendRequest(getState().auth.krypton.getAuthorizationHeader(), graphQLQuery);
      if (res.data) {
          Todo todo = new Todo();//res.data.todoCreateOne.record;
          store.state.todos.todos.add(todo);
          store.dispatch(new TransactionSucceedAction(store.state.todos.todos));
      } else {
          throw new Exception('Transaction failed');
      }
    } catch (e) {
      store.dispatch(TransactionFailAction(e.toString()));
    }
  };
}

// export const completeTodo = (todoId: string) => {
//     return async (dispatch: any, getState: () => RootState) => {
//         dispatch(transactionBegin(TodoTransactionType.UPDATE_TODO));
//         try {
//             const graphQLQuery = completeTodoQuery(todoId);
//             const res = await sendRequest(getState().auth.krypton.getAuthorizationHeader(), graphQLQuery);
//             if (res.data) {
//                 const todo = res.data.todoUpdateById.record;
//                 dispatch(
//                     transactionSuccess(
//                         getState().todo.list.map((currTodo) => (currTodo._id === todo._id ? todo : currTodo)),
//                     ),
//                 );
//             } else {
//                 throw new Error('Transaction failed');
//             }
//         } catch (err) {
//             dispatch(transactionFailure());
//             dispatch(
//                 notify({
//                     message: err.message,
//                     date: new Date(),
//                     type: Severity.DANGER,
//                 }),
//             );
//         }
//     };
// };

ThunkAction<AppState> completeTodo(String todoId) {
  return (Store<AppState> store) async {
    store.dispatch(
        new TransactionStartAction(TodoTransactionType.UPDATE_TODO));
    try {
      const graphQLQuery = "";//addTodoQuery(text, getState().auth.krypton.getUser()._id);
      const res = null;//await sendRequest(getState().auth.krypton.getAuthorizationHeader(), graphQLQuery);
      if (res.data) {
          Todo todo = new Todo();//res.data.todoCreateOne.record;
          store.state.todos.todos.add(todo);
          store.dispatch(new TransactionSucceedAction(store.state.todos.todos));
      } else {
          throw new Exception('Transaction failed');
      }
    } catch (e) {
      store.dispatch(TransactionFailAction(e.toString()));
    }
  };
}

// export const fetchTodo = () => {
//     return async (dispatch: any, getState: () => RootState) => {
//         dispatch(transactionBegin(TodoTransactionType.FETCH_TODO));
//         try {
//             const graphQLQuery = fetchTodoQuery(getState().auth.krypton.getUser()._id);
//             const res = await sendRequest(getState().auth.krypton.getAuthorizationHeader(), graphQLQuery);
//             if (res.data) {
//                 dispatch(transactionSuccess(res.data.todoMany));
//             } else {
//                 throw new Error('Transaction failed');
//             }
//         } catch (err) {
//             dispatch(transactionFailure());
//             dispatch(
//                 notify({
//                     message: err.message,
//                     date: new Date(),
//                     type: Severity.DANGER,
//                 }),
//             );
//         }
//     };
// };

ThunkAction<AppState> fetchTodo(String todoId) {
  return (Store<AppState> store) async {
    store.dispatch(
        new TransactionStartAction(TodoTransactionType.FETCH_TODO));
    try {
      const graphQLQuery = "";//addTodoQuery(text, getState().auth.krypton.getUser()._id);
      const res = null;//await sendRequest(getState().auth.krypton.getAuthorizationHeader(), graphQLQuery);
      if (res.data) {
          Todo todo = new Todo();//res.data.todoCreateOne.record;
          store.state.todos.todos.add(todo);
          store.dispatch(new TransactionSucceedAction(store.state.todos.todos));
      } else {
          throw new Exception('Transaction failed');
      }
    } catch (e) {
      store.dispatch(TransactionFailAction(e.toString()));
    }
  };
}


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