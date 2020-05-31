import 'package:boilerplate/models/krypton/krypton_singleton.dart';
import 'package:boilerplate/redux/states/todo_state.dart';
import 'package:dio/dio.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../store.dart';

Map<String, dynamic> addTodoQuery(String text, String userId){
    return {
        'query': r'''mutation todoCreateOne($text: String!, $userId: String!) {
            todoCreateOne(record: {text: $text, userId: $userId}) {
                record{
                    text
                    isCompleted
                    date
                    _id
                }
            }
        }''',
        'variables': { 'text': text, 'userId': userId },
    };
}

Map<String, dynamic> deleteTodoQuery(String id){
    return {
        'query': r'''mutation todoRemoveById($id: MongoID!){
            todoRemoveById(_id: $id){
                record{
                    text
                    isCompleted
                    date
                    _id
                }
            }
        }''',
        'variables': { 'id': id }
    };
}

Map<String, dynamic> completeTodoQuery(String id){
    return {
        'query': r'''mutation todoUpdateById($id: MongoID!){
            todoUpdateById(record:{_id: $id, isCompleted: true}){
                record{
                    text
                    isCompleted
                    date
                    _id      
                }
            }
        }''',
        'variables': { 'id': id }
    };
}

Map<String, dynamic> fetchTodoQuery(String userId){
    return {
        'query': r'''query todoMany($userId: String!){
            todoMany(filter: {userId: $userId}){
                text
                isCompleted
                date
                _id
            }
        }''',
        'variables': { 'userId': userId }
    };
}

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
    store.dispatch(new TransactionStartAction(TodoTransactionType.ADD_TODO));
    try {
      Response res = await fetch(addTodoQuery(text, store.state.auth.user['_id']));
      if (res.data['errors'] == null && res.data.data?.todoCreateOne?.record != null) {
        Map<String, dynamic> todoData = res.data.data?.todoCreateOne?.record;
        Todo todo = new Todo(
          text: todoData['text'], 
          isCompleted: todoData['isCompleted']);
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
    store.dispatch(new TransactionStartAction(TodoTransactionType.DELETE_TODO));
    try {
      const graphQLQuery =
          ""; //addTodoQuery(text, getState().auth.krypton.getUser()._id);
      const res =
          null; //await sendRequest(getState().auth.krypton.getAuthorizationHeader(), graphQLQuery);
      if (res.data) {
        Todo todo = new Todo(); //res.data.todoCreateOne.record;
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
    store.dispatch(new TransactionStartAction(TodoTransactionType.UPDATE_TODO));
    try {
      const graphQLQuery =
          ""; //addTodoQuery(text, getState().auth.krypton.getUser()._id);
      const res =
          null; //await sendRequest(getState().auth.krypton.getAuthorizationHeader(), graphQLQuery);
      if (res.data) {
        Todo todo = new Todo(); //res.data.todoCreateOne.record;
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



Dio dio = new Dio();
Future<Response> fetch(Map<String, dynamic> query) async {
  var headers = {
    Headers.contentTypeHeader: 'application/json',
    'Authorization':
        await KryptonSingleton.getInstance().getAuthorizationHeader()
  };

  return await dio.post("https://nusid.net/todos",
      data: query, options: Options(headers: headers));
  // if (response.data['errors'] != null) {
  //   throw _parseKryptonException(response.data['errors']);
  // }
  // if (response.data['data'] != null) {
  //   _updateAuthData(response.data['data']);
  // }
  // return response.data['data'];
}


ThunkAction<AppState> fetchTodo(String todoId) {
  return (Store<AppState> store) async {
    store.dispatch(new TransactionStartAction(TodoTransactionType.FETCH_TODO));
    try {
      Response res = await fetch(fetchTodoQuery(store.state.auth.user['_id']));
      if (res.data['errors'] == null && res.data.data?.todoMany != null) {
        List<Map<String, dynamic>> todoData = res.data.data?.todoMany;
        List<Todo> todos = new List<Todo>();
        for (var i = 0; i < todoData.length; i++) {
          todos.add(new Todo(
          text: todoData[0]['text'], 
          isCompleted: todoData[0]['isCompleted']));
        }
        store.dispatch(new TransactionSucceedAction(todos));
      } else {
        throw new Exception('Transaction failed');
      }
    } catch (e) {
      store.dispatch(TransactionFailAction(e.toString()));
    }
  };
}