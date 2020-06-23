import 'package:boilerplate/redux/actions/todo_action.dart';
import 'package:boilerplate/redux/states/todo_state.dart';
import 'package:boilerplate/redux/store.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).pushReplacementNamed(Routes.addTodo),
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.dependOnInheritedWidgetOfExactType();
  }

  // app bar methods:-----------------------------------------------------------
  Widget _buildAppBar() {
    return AppBar(
      title: Text(AppLocalizations.of(context).translate('home_title')),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
      _buildSettingsButton(),
    ];
  }

  Widget _buildSettingsButton() {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pushNamed(Routes.settings);
      },
      icon: Icon(
        Icons.settings,
      ),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Stack(
      key: scaffoldKey,
      children: <Widget>[
        _handleErrorMessage(),
        _buildMainContent(),
        StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (context, state) => Visibility(
            visible: state.todos.isLoading,
            child: CustomProgressIndicatorWidget(),
          ),
        )
      ],
    );
  }

  Widget _buildMainContent() {
    return StoreConnector<AppState, _TodoListModel>(
        converter: (store) => _TodoListModel(
            todos: store.state.todos.todos,
            isLoading: store.state.todos.isLoading,
            isSuccess: store.state.todos.isSuccess,
            error: store.state.todos.error,
            fetchTodos: () => store.dispatch(fetchTodos())),
        onWillChange: (previousViewModel, newViewModel) => {
              // if (previousViewModel.isLoading == true &&
              //     newViewModel.isSuccess == false)
              //   {_showErrorMessage(newViewModel.error)}
            },
        onInitialBuild: (model) =>
            {if (model.todos == null) model.fetchTodos()},
        builder: (context, model) => _buildList(model.todos));
  }

  Widget _buildList(List<Todo> todos) {
    if (todos == null || todos.length == 0) {
      return Center(
        child: Text(
          AppLocalizations.of(context).translate('home_no_todos'),
        ),
      );
    } else {
      return ListView.separated(
        itemCount: todos.length,
        separatorBuilder: (context, position) {
          return Divider();
        },
        itemBuilder: (context, position) {
          return _buildListItem(todos[position]);
        },
      );
    }
  }

  Widget _buildListItem(Todo todo) {
    return StoreConnector<AppState, _TodoModel>(
        converter: (store) => _TodoModel(
            completeTodo: (String id) => store.dispatch(completeTodo(id)),
            deleteTodo: (String id) => store.dispatch(deleteTodo(id))),
        builder: (context, model) => ListTile(
              dense: true,
              leading: todo.isCompleted
                  ? Icon(Icons.check, color: Colors.green[500])
                  : Icon(Icons.access_time, color: Colors.grey[500]),
              trailing: PopupMenuButton(
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                        PopupMenuItem(
                            value: "CompleteTodo",
                            child: FlatButton(
                                padding: EdgeInsets.all(0.0),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(right: 15.0),
                                      child: Icon(Icons.check),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)
                                          .translate('todos_item_menu_done'),
                                    )
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.pop(context, "CompleteTodo");
                                  model.completeTodo(todo.id);
                                })),
                        PopupMenuItem(
                            value: "DeleteTodo",
                            child: FlatButton(
                                padding: EdgeInsets.all(0.0),
                                child: Row(children: [
                                  Container(
                                      padding: EdgeInsets.only(right: 15.0),
                                      child: Icon(Icons.delete_forever)),
                                  Text(
                                    AppLocalizations.of(context)
                                        .translate('todos_item_menu_delete'),
                                  )
                                ]),
                                onPressed: () {
                                  Navigator.pop(context, "DeleteTodo");
                                  model.deleteTodo(todo.id);
                                }))
                      ]),
              //Icon(Icons.more_vert),
              onTap: () {},
              title: Text(
                '${todo.text}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: Theme.of(context).textTheme.title,
              ),
            ));
  }

  Widget _handleErrorMessage() {
    return ListTile();
  }

  // General Methods:-----------------------------------------------------------
  _showErrorMessage(String message) {
    // Future.delayed(Duration(milliseconds: 0), () {
    //   if (message != null && message.isNotEmpty) {
    //     FlushbarHelper.createError(
    //       message: message,
    //       title: AppLocalizations.of(context).translate('global_error'),
    //       duration: Duration(seconds: 3),
    //     )..show(context);
    //   }
    // });

    // return SizedBox.shrink();
  }
}

class _TodoListModel {
  final List<Todo> todos;
  final bool isLoading;
  final bool isSuccess;
  final String error;
  final Function() fetchTodos;
  _TodoListModel(
      {this.todos,
      this.fetchTodos,
      this.isLoading,
      this.isSuccess,
      this.error});
}

class _TodoModel {
  final Function(String) completeTodo;
  final Function(String) deleteTodo;
  _TodoModel({this.completeTodo, this.deleteTodo});
}
