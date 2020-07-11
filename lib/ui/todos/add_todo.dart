import 'package:krypton_flutter_demo/redux/actions/todo_action.dart';
import 'package:krypton_flutter_demo/redux/states/todo_state.dart';
import 'package:krypton_flutter_demo/redux/states/app_state.dart';
import 'package:krypton_flutter_demo/routes.dart';
import 'package:krypton_flutter_demo/utils/device/device_utils.dart';
import 'package:krypton_flutter_demo/utils/locale/app_localization.dart';
import 'package:krypton_flutter_demo/widgets/progress_indicator_widget.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class AddTodoScreen extends StatefulWidget {
  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  //text controllers:-----------------------------------------------------------
  TextEditingController _todoController = TextEditingController();

  //form key:-----------------------------------------------------------------
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
          appBar: _buildAppBar(),
          body: _buildBody(),
        ));
  }

  // app bar methods:-----------------------------------------------------------
  Widget _buildAppBar() {
    return AppBar(
        leading: _buildHistoryBackButton(),
        title: Text(AppLocalizations.of(context).translate('todos_add_item')),
        actions: <Widget>[_buildValidateButton()]);
  }

  Widget _buildValidateButton() {
    return StoreConnector<AppState, _AddTodoModel>(
        converter: (store) => _AddTodoModel(
            state: store.state,
            addTodo: (String text) => store.dispatch(addTodo(text))),
        onWillChange: (previousViewModel, newViewModel) => {
              if (previousViewModel.state.todos.transactionType ==
                      TodoTransactionType.ADD_TODO &&
                  previousViewModel.state.todos.isLoading == true &&
                  newViewModel.state.todos.isSuccess == true)
                {navigateToHome(context)}
              else if (previousViewModel.state.todos.transactionType ==
                      TodoTransactionType.ADD_TODO &&
                  previousViewModel.state.todos.isLoading == true &&
                  newViewModel.state.todos.isSuccess == false)
                {_showErrorMessage(newViewModel.state.todos.error)}
            },
        builder: (context, model) => IconButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  DeviceUtils.hideKeyboard(context);
                  model.addTodo(_todoController.text);
                } else {
                  _showErrorMessage('Please fill in all fields');
                }
              },
              icon: Icon(
                Icons.check,
              ),
            ));
  }

  Widget _buildHistoryBackButton() {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pushReplacementNamed(Routes.home);
      },
      icon: Icon(
        Icons.arrow_back_ios,
      ),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Material(
        child: Stack(
      children: <Widget>[
        Center(child: _buildTodoField()),
        StoreConnector<AppState, bool>(
          converter: (store) => store.state.todos.isLoading,
          builder: (context, isLoading) => Visibility(
            visible: isLoading,
            child: CustomProgressIndicatorWidget(),
          ),
        )
      ],
    ));
  }

  Widget _buildTodoField() {
    return Container(
        padding: new EdgeInsets.all(10.0),
        child: new ConstrainedBox(
            constraints: new BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              maxWidth: MediaQuery.of(context).size.width,
              minHeight: 25.0,
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              reverse: true,
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _todoController,
                textInputAction: TextInputAction.newline,
                autocorrect: true,
                validator: _validateToto,
              ),
            )));
  }

  String _validateToto(String email) {
    if (email.isEmpty) {
      return "Todo can't be empty";
    }
    return null;
  }

  // General Methods:-----------------------------------------------------------
  _showErrorMessage(String message) {
    Future.delayed(Duration(milliseconds: 0), () {
      if (message != null && message.isNotEmpty) {
        FlushbarHelper.createError(
          message: message,
          title: AppLocalizations.of(context).translate('global_error'),
          duration: Duration(seconds: 3),
        )..show(context);
      }
    });

    return SizedBox.shrink();
  }

  navigateToHome(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(Routes.home);
  }

  // dispose:-------------------------------------------------------------------
  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _todoController.dispose();
    super.dispose();
  }
}

class _AddTodoModel {
  final AppState state;
  final Function(String) addTodo;
  _AddTodoModel({this.state, this.addTodo});
}
