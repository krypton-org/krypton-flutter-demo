import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/redux/actions/auth_actions.dart';
import 'package:boilerplate/redux/states/auth_state.dart';
import 'package:boilerplate/redux/store.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/utils/device/device_utils.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/app_icon_widget.dart';
import 'package:boilerplate/widgets/empty_app_bar_widget.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:validators/validators.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //text controllers:-----------------------------------------------------------
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  //focus node:-----------------------------------------------------------------
  FocusNode _passwordFocusNode;

  //form key:-------------------------------------------------------------------
  final _formKey = GlobalKey<FormState>();

  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      appBar: EmptyAppBar(),
      body: _buildBody(),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Material(
      child: Stack(
        children: <Widget>[
          Center(child: _buildForm()),
          StoreConnector<AppState, bool>(
              converter: (store) => store.state.auth.isLoading,
              builder: (context, isLoading) => Visibility(
                    visible: isLoading,
                    child: CustomProgressIndicatorWidget(),
                  )),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AppIconWidget(image: 'assets/icons/ic_appicon.png'),
              SizedBox(height: 50.0),
              _buildEmailField(),
              _buildPasswordField(),
              _buildSignUpButton(),
              _buildLogInButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Container(
        child: StoreConnector<AppState, bool>(
            converter: (store) => store.state.theme.isDark,
            builder: (context, isDark) => TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.email,
                        color: isDark ? Colors.white70 : Colors.black54),
                    hintText:
                        AppLocalizations.of(context).translate('login_email'),
                  ),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                  autocorrect: false,
                  validator: _validateEmail,
                  // onChanged: (_) {
                  //   _formKey.currentState.validate();
                  // },
                )),
        margin: const EdgeInsets.only(bottom: 0.0));
  }

  String _validateEmail(String email) {
    if (email.isEmpty) {
      return "Email can't be empty";
    } else if (!isEmail(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  Widget _buildPasswordField() {
    return StoreConnector<AppState, bool>(
        converter: (store) => store.state.theme.isDark,
        builder: (context, isDark) => TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.lock,
                    color: isDark ? Colors.white70 : Colors.black54),
                hintText: AppLocalizations.of(context)
                    .translate('login_et_user_password'),
                contentPadding: EdgeInsets.only(top: 16.0),
                suffixIcon: IconButton(
                  icon: Icon(
                    passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                ),
              ),
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              validator: _validatePassword,
              obscureText: !passwordVisible,
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

  Widget _buildLogInButton() {
    return Container(
        margin: EdgeInsets.only(top: 20.0),
        child: Center(
          child: FlatButton(
            child: Text(
              AppLocalizations.of(context)
                  .translate('register_already_have_an_account'),
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: Colors.blue[300]),
            ),
            onPressed: () async {
              navigateToLogin(context);
            },
          ),
        ));
  }

  Widget _buildSignUpButton() {
    return Container(
        margin: EdgeInsets.only(top: 20.0),
        child: StoreConnector<AppState, _RegisterModel>(
            converter: (store) => _RegisterModel(
                state: store.state,
                registerAndLogin: (String email, String password) async =>
                    await store.dispatch(registerAndLogin(email, password))),
            onWillChange: (previousViewModel, newViewModel) => {
                  if (previousViewModel.state.auth.transactionType ==
                          AuthTransactionType.LOGIN &&
                      previousViewModel.state.auth.isLoading == true &&
                      newViewModel.state.auth.isSuccess == true)
                    {navigateToHome(context)}
                  else if (previousViewModel.state.auth.transactionType ==
                          AuthTransactionType.REGISTER &&
                      previousViewModel.state.auth.isLoading == true &&
                      newViewModel.state.auth.isSuccess == false)
                    {_showErrorMessage(newViewModel.state.auth.error)}
                  else if (previousViewModel.state.auth.transactionType ==
                          AuthTransactionType.LOGIN &&
                      previousViewModel.state.auth.isLoading == true &&
                      newViewModel.state.auth.isSuccess == false)
                    {_showErrorMessage(newViewModel.state.auth.error)}
                },
            builder: (context, model) => CupertinoButton(
                  child: Text(
                      AppLocalizations.of(context)
                          .translate('register_btn_sign_up'),
                      style: new TextStyle(color: Colors.white)),
                  color: Theme.of(context).buttonColor,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      DeviceUtils.hideKeyboard(context);
                      await model.registerAndLogin(
                          _emailController.text, _passwordController.text);
                    } else {
                      _showErrorMessage('Please fill in all fields');
                    }
                  },
                )));
  }

  Widget navigateToHome(BuildContext context) {
    Future.delayed(Duration(milliseconds: 0), () {
      Navigator.of(context).pushReplacementNamed(Routes.home);
    });

    return Container();
  }

  Widget navigateToLogin(BuildContext context) {
    Future.delayed(Duration(milliseconds: 0), () {
      Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.login, (Route<dynamic> route) => false);
    });

    return Container();
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
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}

class _RegisterModel {
  final AppState state;
  final Function(String, String) registerAndLogin;

  _RegisterModel({this.state, this.registerAndLogin});
}
