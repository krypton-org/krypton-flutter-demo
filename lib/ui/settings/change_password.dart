import 'package:krypton_flutter_demo/redux/actions/auth_actions.dart';
import 'package:krypton_flutter_demo/redux/states/auth_state.dart';
import 'package:krypton_flutter_demo/redux/states/app_state.dart';
import 'package:krypton_flutter_demo/routes.dart';
import 'package:krypton_flutter_demo/utils/device/device_utils.dart';
import 'package:krypton_flutter_demo/utils/locale/app_localization.dart';
import 'package:krypton_flutter_demo/widgets/progress_indicator_widget.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  //text controllers:-----------------------------------------------------------
  TextEditingController _actualPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();

  //focus node:-----------------------------------------------------------------
  FocusNode _newPasswordFocusNode = FocusNode();

  //form key:-------------------------------------------------------------------
  final _formKey = GlobalKey<FormState>();

  bool actualPasswordVisible = false;
  bool newPasswordVisible = false;

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
        title: Text(
            AppLocalizations.of(context).translate('settings_change_password')),
        actions: <Widget>[_buildValidateButton()]);
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Material(
      child: Stack(children: <Widget>[
        Column(
          children: <Widget>[
            Center(child: _buildActualPasswordField()),
            Center(child: _buildNewPasswordField()),
          ],
        ),
        StoreConnector<AppState, bool>(
          converter: (store) => store.state.auth.isLoading,
          builder: (context, isLoading) => Visibility(
            visible: isLoading,
            child: CustomProgressIndicatorWidget(),
          ),
        )
      ]),
    );
  }

  Widget _buildActualPasswordField() {
    return Container(
        padding: new EdgeInsets.all(10.0),
        child: TextFormField(
          decoration: InputDecoration(
            icon: Icon(Icons.lock),
            hintText: AppLocalizations.of(context)
                .translate('settings_actual_password'),
            contentPadding: EdgeInsets.only(top: 16.0),
            suffixIcon: IconButton(
              icon: Icon(
                actualPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  actualPasswordVisible = !actualPasswordVisible;
                });
              },
            ),
          ),
          controller: _actualPasswordController,
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_newPasswordFocusNode);
          },
          validator: _validatePassword,
          obscureText: !actualPasswordVisible,
          autocorrect: false,
        ));
  }

  String _validatePassword(String password) {
    if (password.isEmpty) {
      return "Password can't be empty";
    } else if (password.length < 8) {
      return "Password must be at-least 8 characters long";
    }
    return null;
  }

  Widget _buildNewPasswordField() {
    return Container(
        padding: new EdgeInsets.all(10.0),
        child: TextFormField(
          decoration: InputDecoration(
            icon: Icon(Icons.lock),
            hintText:
                AppLocalizations.of(context).translate('settings_new_password'),
            contentPadding: EdgeInsets.only(top: 16.0),
            suffixIcon: IconButton(
              icon: Icon(
                newPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  newPasswordVisible = !newPasswordVisible;
                });
              },
            ),
          ),
          controller: _newPasswordController,
          focusNode: _newPasswordFocusNode,
          validator: _validatePassword,
          obscureText: !newPasswordVisible,
          autocorrect: false,
        ));
  }

  Widget _buildValidateButton() {
    return StoreConnector<AppState, _ChangePasswordModel>(
        converter: (store) => _ChangePasswordModel(
            state: store.state,
            changePassword: (String actualPassword, String newPassword) =>
                store.dispatch(changePassword(actualPassword, newPassword))),
        onWillChange: (previousViewModel, newViewModel) => {
              if (previousViewModel.state.auth.transactionType ==
                      AuthTransactionType.CHANGE_PASSWORD &&
                  previousViewModel.state.auth.isLoading == true &&
                  newViewModel.state.auth.isSuccess == true)
                {navigateToSettings(context)}
              else if (previousViewModel.state.auth.transactionType ==
                      AuthTransactionType.CHANGE_PASSWORD &&
                  previousViewModel.state.auth.isLoading == true &&
                  newViewModel.state.auth.isSuccess == false)
                {_showErrorMessage(newViewModel.state.auth.error)}
            },
        builder: (context, model) => IconButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  DeviceUtils.hideKeyboard(context);
                  model.changePassword(_actualPasswordController.text,
                      _newPasswordController.text);
                } else {
                  _showErrorMessage('Please fill in all fields');
                }
              },
              icon: Icon(
                Icons.check,
              ),
            ));
  }

  Widget navigateToSettings(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(Routes.settings);
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
    _actualPasswordController.dispose();
    _newPasswordController.dispose();
    _newPasswordFocusNode.dispose();
    super.dispose();
  }
}

class _ChangePasswordModel {
  final AppState state;
  final Function(String, String) changePassword;
  _ChangePasswordModel({this.state, this.changePassword});
}
