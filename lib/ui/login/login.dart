import 'package:boilerplate/data/sharedpref/constants/preferences.dart';
import 'package:boilerplate/redux/actions/auth_actions.dart';
import 'package:boilerplate/redux/states/auth_state.dart';
import 'package:boilerplate/redux/store.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/utils/device/device_utils.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/app_icon_widget.dart';
import 'package:boilerplate/widgets/empty_app_bar_widget.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:boilerplate/widgets/textfield_widget.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //text controllers:-----------------------------------------------------------
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  //focus node:-----------------------------------------------------------------
  FocusNode _passwordFocusNode;

  //form key:-------------------------------------------------------------------
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _passwordFocusNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
          MediaQuery.of(context).orientation == Orientation.landscape
              ? Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: _buildLeftSide(),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildRightSide(),
                    ),
                  ],
                )
              : Center(child: _buildRightSide()),
          StoreConnector<AppState, bool>(
            converter: (store) => store.state.auth.isLoading,
            builder: (context, isLoading) => Visibility(
              visible: isLoading,
              child: CustomProgressIndicatorWidget(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLeftSide() {
    return SizedBox.expand(
      child: Image.asset(
        'assets/images/img_login.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildRightSide() {
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
              _buildUserIdField(),
              _buildPasswordField(),
              _buildForgotPasswordButton(),
              _buildLogInButton(),
              _buildSignUpButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserIdField() {
    return Observer(
      builder: (context) {
        return Container(
            child: StoreConnector<AppState, bool>(
                converter: (store) => store.state.theme.isDark,
                builder: (context, isDark) => TextFieldWidget(
                      hint:
                          AppLocalizations.of(context).translate('login_email'),
                      inputType: TextInputType.emailAddress,
                      icon: Icons.person,
                      iconColor: isDark ? Colors.white70 : Colors.black54,
                      textController: _userEmailController,
                      inputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                      errorText: _validateEmail(_userEmailController.text),
                    )),
            margin: const EdgeInsets.only(bottom: 0.0));
      },
    );
  }

  String _validateEmail(String email) {
    if (email.isEmpty) {
      return "Email can't be empty";
    } else if (!isEmail(email)) {
      return 'Please enter a valid email address';
    } else {
      return "";
    }
  }

  Widget _buildPasswordField() {
    return Observer(
      builder: (context) {
        return StoreConnector<AppState, bool>(
            converter: (store) => store.state.theme.isDark,
            builder: (context, isDark) => TextFieldWidget(
                  hint: AppLocalizations.of(context)
                      .translate('login_et_user_password'),
                  isObscure: true,
                  padding: EdgeInsets.only(top: 16.0),
                  icon: Icons.lock,
                  iconColor: isDark ? Colors.white70 : Colors.black54,
                  textController: _passwordController,
                  focusNode: _passwordFocusNode,
                  errorText: _validatePassword(_passwordController.text),
                ));
      },
    );
  }

  String _validatePassword(String password) {
    if (password.isEmpty) {
      return "Password can't be empty";
    } else if (password.length < 8) {
      return "Password must be at-least 8 characters long";
    } else {
      return "";
    }
  }

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: FractionalOffset.centerRight,
      child: FlatButton(
        padding: EdgeInsets.all(0.0),
        child: Text(
          AppLocalizations.of(context).translate('login_btn_forgot_password'),
          style: Theme.of(context)
              .textTheme
              .caption
              .copyWith(color: Colors.blue[300]),
        ),
        onPressed: () async {
          _buildForgotPasswordDialog();
        },
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Container(
        margin: EdgeInsets.only(top: 20.0),
        child: Center(
          child: FlatButton(
            child: Text(
              AppLocalizations.of(context).translate('login_no_account_yet'),
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: Colors.blue[300]),
            ),
            onPressed: () async {
              navigateToRegister(context);
            },
          ),
        ));
  }

  Widget _buildLogInButton() {
    return StoreConnector<AppState, _LoginModel>(
        converter: (store) => _LoginModel(
            state: store.state,
            login: (String email, String password) =>
                store.dispatch(login(email, password))),
        onWillChange: (previousViewModel, newViewModel) => {
              if (previousViewModel.state.auth.transactionType ==
                      AuthTransactionType.LOGIN &&
                  previousViewModel.state.auth.isLoading == true &&
                  newViewModel.state.auth.isSuccess == true)
                {navigateToHome(context)}
              else if (previousViewModel.state.auth.transactionType ==
                      AuthTransactionType.LOGIN &&
                  previousViewModel.state.auth.isLoading == true &&
                  newViewModel.state.auth.isSuccess == false)
                {_showErrorMessage(newViewModel.state.auth.error)}
            },
        builder: (context, model) => CupertinoButton(
              child: Text(
                  AppLocalizations.of(context).translate('login_btn_log_in'),
                  style: new TextStyle(color: Colors.white)),
              color: Theme.of(context).buttonColor,
              onPressed: () async {
                if (isEmail(_userEmailController.text) &&
                    _passwordController.text.length > 8) {
                  DeviceUtils.hideKeyboard(context);
                  model.login(
                      _userEmailController.text, _passwordController.text);
                } else {
                  _showErrorMessage('Please fill in all fields');
                }
              },
            ));
  }

  Widget _buildSendEmailButton() {
    return Container(
      margin: const EdgeInsets.only(top: 25.0),
      child: CupertinoButton(
        child: new Text(
            AppLocalizations.of(context)
                .translate('login_btn_send_password_recovery_email'),
            style: new TextStyle(color: Colors.white)),
        color: Theme.of(context).buttonColor,
        onPressed: () async {
          // if (_store.canLogin) {
          //   DeviceUtils.hideKeyboard(context);
          //   _store.login();
          // } else {
          //   _showErrorMessage('Please fill in all fields');
          // }
        },
      ),
    );
  }

  Widget navigateToHome(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(Preferences.is_logged_in, true);
    });

    Future.delayed(Duration(milliseconds: 0), () {
      Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.home, (Route<dynamic> route) => false);
    });

    return Container();
  }

  Widget navigateToRegister(BuildContext context) {
    Future.delayed(Duration(milliseconds: 0), () {
      Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.register, (Route<dynamic> route) => false);
    });

    return Container();
  }

  // General Methods:-----------------------------------------------------------
  _showErrorMessage(String message) {
    Future.delayed(Duration(milliseconds: 0), () {
      if (message != null && message.isNotEmpty) {
        FlushbarHelper.createError(
          message: message,
          title: AppLocalizations.of(context).translate('home_tv_error'),
          duration: Duration(seconds: 3),
        )..show(context);
      }
    });

    return SizedBox.shrink();
  }

  _showDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) {
      // The value passed to Navigator.pop() or null.
    });
  }

  _buildForgotPasswordDialog() {
    _showDialog<String>(
      context: context,
      child: MaterialDialog(
          borderRadius: 5.0,
          enableFullWidth: true,
          title: Text(
            AppLocalizations.of(context)
                .translate('login_send_password_recovery_email_title'),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          headerColor: Colors.blue[400],
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          closeButtonColor: Colors.white,
          enableCloseButton: true,
          enableBackButton: false,
          onCloseButtonClicked: () {
            Navigator.of(context).pop();
          },
          children: <Widget>[_buildUserIdField(), _buildSendEmailButton()]),
    );
  }

  // dispose:-------------------------------------------------------------------
  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _userEmailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}

class _LoginModel {
  final AppState state;
  final Function(String, String) login;
  _LoginModel({this.state, this.login});
}
