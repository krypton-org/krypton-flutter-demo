import 'package:boilerplate/redux/actions/auth_actions.dart';
import 'package:boilerplate/redux/states/auth_state.dart';
import 'package:boilerplate/redux/store.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/utils/device/device_utils.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:validators/validators.dart';

class ChangeEmailScreen extends StatefulWidget {
  @override
  _ChangeEmailScreenState createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  //text controllers:-----------------------------------------------------------
  TextEditingController _emailController = TextEditingController();

  //form key:-------------------------------------------------------------------
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
        title: Text(
            AppLocalizations.of(context).translate('settings_change_email')),
        actions: <Widget>[_buildValidateButton()]);
  }

  Widget _buildValidateButton() {
    return StoreConnector<AppState, _ChangeEmailModel>(
        converter: (store) => _ChangeEmailModel(
            state: store.state,
            updateEmail: (String email) => store.dispatch(updateEmail(email))),
        onWillChange: (previousViewModel, newViewModel) => {
              if (previousViewModel.state.auth.transactionType ==
                      AuthTransactionType.UPDATE_EMAIL &&
                  previousViewModel.state.auth.isLoading == true &&
                  newViewModel.state.auth.isSuccess == true)
                {navigateToSettings(context)}
              else if (previousViewModel.state.auth.transactionType ==
                      AuthTransactionType.UPDATE_EMAIL &&
                  previousViewModel.state.auth.isLoading == true &&
                  newViewModel.state.auth.isSuccess == false)
                {_showErrorMessage(newViewModel.state.auth.error)}
            },
        builder: (context, model) => IconButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  DeviceUtils.hideKeyboard(context);
                  model.updateEmail(_emailController.text);
                } else {
                  _showErrorMessage('Please fill in all fields');
                }
              },
              icon: Icon(
                Icons.check,
              ),
            ));
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Material(
        child: Stack(
      children: <Widget>[
        Center(child: _buildEmailField()),
        StoreConnector<AppState, bool>(
          converter: (store) => store.state.auth.isLoading,
          builder: (context, isLoading) => Visibility(
            visible: isLoading,
            child: CustomProgressIndicatorWidget(),
          ),
        )
      ],
    ));
  }

  Widget _buildEmailField() {
    return Column(children: <Widget>[
      Container(
        padding: new EdgeInsets.all(10.0),
        child: StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            onInit: (store) =>
                _emailController.text = store.state.auth.user['email'],
            builder: (context, state) => TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    hintText:
                        AppLocalizations.of(context).translate('login_email'),
                  ),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: _validateEmail,
                )),
      )
    ]);
  }

  String _validateEmail(String email) {
    if (email.isEmpty) {
      return "Email can't be empty";
    } else if (!isEmail(email)) {
      return 'Please enter a valid email address';
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

  Widget navigateToSettings(BuildContext context) {
    Future.delayed(Duration(milliseconds: 0), () {
      Navigator.of(context).pushReplacementNamed(Routes.settings);
    });
    return Container();
  }

  // dispose:-------------------------------------------------------------------
  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _emailController.dispose();
    super.dispose();
  }
}

class _ChangeEmailModel {
  final AppState state;
  final Function(String) updateEmail;
  _ChangeEmailModel({this.state, this.updateEmail});
}
