import 'package:boilerplate/redux/actions/todo_action.dart';
import 'package:boilerplate/redux/states/todo_state.dart';
import 'package:boilerplate/redux/store.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  // app bar methods:-----------------------------------------------------------
  Widget _buildAppBar() {
    return AppBar(
      title: Text(AppLocalizations.of(context).translate('home_tv_posts')),
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
        Navigator.of(context).pushReplacementNamed(Routes.settings);
      },
      icon: Icon(
        Icons.settings,
      ),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        _handleErrorMessage(),
        _buildMainContent(),
        StoreConnector<AppState, bool>(
          converter: (store) => store.state.todos.isLoading,
          builder: (context, isLoading) => Visibility(
            visible: isLoading,
            child: CustomProgressIndicatorWidget(),
          ),
        )
      ],
    );
  }

  Widget _buildMainContent() {
    return StoreConnector<AppState, _HomeModel>(
        converter: (store) => _HomeModel(
            todos: store.state.todos.todos, fetchTodos: () => store.dispatch(fetchTodos())),
        onInitialBuild: (model) => model.fetchTodos(),
        builder: (context, model) => _buildList(model.todos));
  }

  Widget _buildList(List<Todo> todos) {
    if (todos == null || todos.length == 0) {
      return Center(
        child: Text(
          AppLocalizations.of(context).translate('home_tv_no_post_found'),
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
    return ListTile(
      dense: true,
      leading: todo.isCompleted ? Icon(Icons.check, color: Colors.green[500]) : Icon(Icons.access_time, color: Colors.grey[500]),
      title: Text(
        '${todo.text}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: Theme.of(context).textTheme.title,
      ),
    );
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
    //       title: AppLocalizations.of(context).translate('home_tv_error'),
    //       duration: Duration(seconds: 3),
    //     )..show(context);
    //   }
    // });

    // return SizedBox.shrink();
  }
}

class _HomeModel {
  final List<Todo> todos;
  final Function() fetchTodos;
  _HomeModel({this.todos, this.fetchTodos});
}
