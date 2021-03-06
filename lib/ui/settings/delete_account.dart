import 'package:krypton_flutter_demo/redux/actions/app_actions.dart';
import 'package:krypton_flutter_demo/redux/actions/auth_actions.dart';
import 'package:krypton_flutter_demo/redux/states/auth_state.dart';
import 'package:krypton_flutter_demo/redux/states/app_state.dart';
import 'package:krypton_flutter_demo/routes.dart';
import 'package:krypton_flutter_demo/utils/locale/app_localization.dart';
import 'package:krypton_flutter_demo/widgets/progress_indicator_widget.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:material_dialog/material_dialog.dart';

class DeleteAccountScreen extends StatefulWidget {
  @override
  _DeleteAccountScreenState createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  //text controllers:-----------------------------------------------------------
  TextEditingController _passwordController = TextEditingController();

  bool passwordVisible = false;

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
      title: Text(
          AppLocalizations.of(context).translate('settings_delete_account')),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Material(
      child: Stack(
        children: <Widget>[
          Card(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            ListTile(
              leading: Icon(Icons.delete),
              title: Text(AppLocalizations.of(context)
                  .translate('settings_delete_account_question')),
            ),
            Container(
                padding: EdgeInsets.all(10.0),
                child: CupertinoButton(
                  child: Text(
                      AppLocalizations.of(context)
                          .translate('settings_delete_account_confirm'),
                      style: new TextStyle(color: Colors.white)),
                  color: Theme.of(context).errorColor,
                  onPressed: () {
                    _buildPasswordDialog();
                  },
                ))
          ])),
        ],
      ),
    );
  }

  _buildPasswordDialog() {
    _showDialog<String>(
      context: context,
      child: MaterialDialog(
          borderRadius: 5.0,
          enableFullWidth: true,
          title: Text(
            AppLocalizations.of(context)
                .translate('settings_delete_account_title'),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          headerColor: Theme.of(context).primaryColor,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          closeButtonColor: Colors.white,
          enableCloseButton: true,
          enableBackButton: false,
          onCloseButtonClicked: () {
            Navigator.of(context).pop();
          },
          children: <Widget>[
            _buildPasswordField(),
            StoreConnector<AppState, _DeleteModel>(
                converter: (store) => _DeleteModel(
                    state: store.state,
                    deleteAccount: (String password) =>
                        store.dispatch(deleteAccount(password)),
                    resetState: () => store.dispatch(new ResetStateAction())),
                onWillChange: (previousViewModel, newViewModel) {
                  if (previousViewModel.state.auth.transactionType ==
                          AuthTransactionType.DELETE_ACCOUNT &&
                      previousViewModel.state.auth.isLoading == true &&
                      newViewModel.state.auth.isSuccess == true) {
                    navigateToLogin(context);
                    newViewModel.resetState();
                  } else if (previousViewModel.state.auth.transactionType ==
                          AuthTransactionType.DELETE_ACCOUNT &&
                      previousViewModel.state.auth.isLoading == true &&
                      newViewModel.state.auth.isSuccess == false) {
                    _showErrorMessage(newViewModel.state.auth.error);
                  }
                },
                builder: (context, model) => Container(
                    padding: EdgeInsets.all(10.0),
                    child: CupertinoButton(
                      child: Text(
                          AppLocalizations.of(context)
                              .translate('settings_delete_account_confirm'),
                          style: new TextStyle(color: Colors.white)),
                      color: Theme.of(context).errorColor,
                      onPressed: () {
                        model.deleteAccount(_passwordController.text);
                      },
                    )))
          ]),
    );
  }

  Widget _buildPasswordField() {
    return Container(
        padding: new EdgeInsets.all(10.0),
        child: TextFormField(
          decoration: InputDecoration(
            icon: Icon(Icons.lock),
            hintText: AppLocalizations.of(context)
                .translate('login_et_user_password'),
            contentPadding: EdgeInsets.only(top: 16.0),
            suffixIcon: IconButton(
              icon: Icon(
                passwordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  passwordVisible = !passwordVisible;
                });
              },
            ),
          ),
          controller: _passwordController,
          validator: _validatePassword,
          obscureText: !passwordVisible,
          autocorrect: false,
        ));
  }

  void navigateToLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(Routes.login);
  }

  String _validatePassword(String password) {
    if (password.isEmpty) {
      return "Password can't be empty";
    } else if (password.length < 8) {
      return "Password must be at-least 8 characters long";
    }
    return null;
  }

  _showDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    );
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

  // dispose:-------------------------------------------------------------------
  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _passwordController.dispose();
    super.dispose();
  }
}

class _DeleteModel {
  final AppState state;
  final Function(String) deleteAccount;
  final Function resetState;
  _DeleteModel({this.state, this.deleteAccount, this.resetState});
}
