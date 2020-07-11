import 'package:krypton_flutter_demo/redux/states/app_state.dart';
import 'package:krypton_flutter_demo/redux/states/todo_state.dart';
import 'package:krypton_flutter_demo/utils/krypton/krypton_singleton.dart';
import 'package:dio/dio.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

Map<String, dynamic> addTodoQuery(String text, String userId) {
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
    'variables': {'text': text, 'userId': userId},
  };
}

Map<String, dynamic> deleteTodoQuery(String id) {
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
    'variables': {'id': id}
  };
}

Map<String, dynamic> completeTodoQuery(String id) {
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
    'variables': {'id': id}
  };
}

Map<String, dynamic> fetchTodoQuery(String userId) {
  return {
    'query': r'''query todoMany($userId: String!){
            todoMany(filter: {userId: $userId}){
                text
                isCompleted
                date
                _id
            }
        }''',
    'variables': {'userId': userId}
  };
}

ThunkAction<AppState> addTodo(String text) {
  return (Store<AppState> store) async {
    store.dispatch(new TransactionStartAction(TodoTransactionType.ADD_TODO));
    try {
      Response res = await fetch(
          addTodoQuery(text, KryptonSingleton.getInstance().user['_id']));
      if (res.data['errors'] == null && res.data["data"] != null) {
        dynamic todoData = res.data["data"]["todoCreateOne"]['record'];
        Todo todo = new Todo(
            id: todoData['_id'],
            text: todoData['text'],
            isCompleted: todoData['isCompleted']);
        List<Todo> todos = [...store.state.todos.todos, todo];
        store.dispatch(new TransactionSucceedAction(todos));
      } else {
        throw new Exception('Transaction failed');
      }
    } catch (e) {
      store.dispatch(TransactionFailAction(e.toString()));
    }
  };
}

ThunkAction<AppState> deleteTodo(String todoId) {
  return (Store<AppState> store) async {
    store.dispatch(new TransactionStartAction(TodoTransactionType.DELETE_TODO));
    try {
      Response res = await fetch(deleteTodoQuery(todoId));
      if (res.data['errors'] == null) {
        List<Todo> todos = store.state.todos.todos
            .where((current) => current.id != todoId)
            .toList();
        store.dispatch(new TransactionSucceedAction(todos));
      } else {
        throw new Exception('Transaction failed');
      }
    } catch (e) {
      store.dispatch(TransactionFailAction(e.toString()));
    }
  };
}

ThunkAction<AppState> completeTodo(String todoId) {
  return (Store<AppState> store) async {
    store.dispatch(new TransactionStartAction(TodoTransactionType.UPDATE_TODO));
    try {
      Response res = await fetch(completeTodoQuery(todoId));
      if (res.data['errors'] == null && res.data["data"] != null) {
        dynamic todoData = res.data["data"]["todoUpdateById"]['record'];
        Todo todo = new Todo(
            id: todoData['_id'],
            text: todoData['text'],
            isCompleted: todoData['isCompleted']);
        List<Todo> todos = store.state.todos.todos
            .map((current) => current.id == todo.id ? todo : current)
            .toList();
        store.dispatch(new TransactionSucceedAction(todos));
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

ThunkAction<AppState> fetchTodos() {
  return (Store<AppState> store) async {
    store.dispatch(new TransactionStartAction(TodoTransactionType.FETCH_TODO));
    try {
      Response res = await fetch(fetchTodoQuery(store.state.auth.user['_id']));
      if (res.data['errors'] == null && res.data["data"]["todoMany"] != null) {
        List<dynamic> todoData = res.data["data"]["todoMany"];
        List<Todo> todos = new List<Todo>();
        for (var i = 0; i < todoData.length; i++) {
          todos.add(new Todo(
              id: todoData[i]['_id'],
              text: todoData[i]['text'],
              isCompleted: todoData[i]['isCompleted']));
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
