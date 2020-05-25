import 'package:boilerplate/routes.dart';
import 'package:boilerplate/stores/auth/auth_store.dart';
import 'package:boilerplate/utils/device/device_utils.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:boilerplate/widgets/textfield_widget.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../stores/theme/theme_store.dart';

class ChangeEmailScreen extends StatefulWidget {
  @override
  _ChangeEmailScreenState createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  //text controllers:-----------------------------------------------------------
  TextEditingController _emailController;

  //stores:---------------------------------------------------------------------
  ThemeStore _themeStore;
  AuthStore _authStore;

  //form key:-------------------------------------------------------------------
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authStore = Provider.of<AuthStore>(context);
    _themeStore = Provider.of<ThemeStore>(context);
    _emailController = TextEditingController()..text = "toto@toto.com";
    _authStore.setUserEmail(_emailController.text);
  }

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
        leading: _buildHistoryBackButton(),
        title: Text(
            AppLocalizations.of(context).translate('settings_change_email')),
        actions: <Widget>[_buildValidateButton()]);
  }

  Widget _buildValidateButton() {
    return Observer(
      builder: (context) {
        return IconButton(
          onPressed: () async {
            if (_authStore.canUpdateEmail) {
              DeviceUtils.hideKeyboard(context);
              _authStore.updateEmail();
            } else {
              _showErrorMessage('Please fill in all fields');
            }
          },
          icon: Icon(
            Icons.check,
          ),
        );
      },
    );
  }

  Widget _buildHistoryBackButton() {
    return Observer(
      builder: (context) {
        return IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(Routes.settings);
          },
          icon: Icon(
            Icons.arrow_back_ios,
          ),
        );
      },
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Material(
        child: Stack(
      children: <Widget>[
        Center(child: _buildEmailForm()),
        Observer(
          builder: (context) {
            return _authStore.success
                ? navigateToSettings(context)
                : _showErrorMessage(_authStore.errorStore.errorMessage);
          },
        ),
        Observer(
          builder: (context) {
            return Visibility(
              visible: _authStore.loading,
              child: CustomProgressIndicatorWidget(),
            );
          },
        )
      ],
    ));
  }

  _buildEmailForm() {
    return Observer(
      builder: (context) {
        return Column(children: <Widget>[ Container(
          padding: new EdgeInsets.all(10.0),
          child: TextFieldWidget(
                hint: AppLocalizations.of(context).translate('login_email'),
                inputType: TextInputType.emailAddress,
                icon: Icons.person,
                iconColor:
                    _themeStore.darkMode ? Colors.white70 : Colors.black54,
                textController: _emailController,
                inputAction: TextInputAction.next,
                onChanged: (value) {
                  _authStore.setUserEmail(_emailController.text);
                },
                errorText: _authStore.formErrorStore.userEmail),
        )]);
      },
    );
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
