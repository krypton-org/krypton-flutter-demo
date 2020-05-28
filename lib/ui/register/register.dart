import 'package:boilerplate/redux/actions/auth_actions.dart';
import 'package:boilerplate/redux/states/auth_state.dart';
import 'package:boilerplate/redux/store.dart';
import 'package:boilerplate/routes.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //text controllers:-----------------------------------------------------------
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  //focus node:-----------------------------------------------------------------
  FocusNode _passwordFocusNode;

  //form key:-------------------------------------------------------------------
  final _formKey = GlobalKey<FormState>();

  //stores:---------------------------------------------------------------------

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
                  )),
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
              _buildSignUpButton(),
              _buildLogInButton(),
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
                login: (String email, String password) async =>
                    await store.dispatch(login(email, password)),
                register: (String email, String password) async =>
                    await store.dispatch(register(email, password))),
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
                    await model.register(
                        _userEmailController.text, _passwordController.text);
                    await model.login(
                        _userEmailController.text, _passwordController.text);
                  },
                )));
  }

  Widget navigateToHome(BuildContext context) {
    Future.delayed(Duration(milliseconds: 0), () {
      Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.home, (Route<dynamic> route) => false);
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
          title: AppLocalizations.of(context).translate('home_tv_error'),
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
    _userEmailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}

class _RegisterModel {
  final AppState state;
  final Function(String, String) register;
  final Function(String, String) login;

  _RegisterModel({this.state, this.login, this.register});
}
