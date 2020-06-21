import 'package:boilerplate/redux/actions/auth_actions.dart';
import 'package:boilerplate/redux/actions/language_actions.dart';
import 'package:boilerplate/redux/states/auth_state.dart';
import 'package:boilerplate/redux/states/language_state.dart';
import 'package:boilerplate/redux/store.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/utils/krypton/krypton_singleton.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:redux/redux.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
      title: Text(AppLocalizations.of(context).translate('settings_title')),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Material(
        child: Stack(children: <Widget>[
      Column(
        children: <Widget>[
          Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  padding:
                      new EdgeInsets.only(top: 10.0, left: 10.0, bottom: 5.0),
                  child: Text(
                    AppLocalizations.of(context).translate('settings_account'),
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.title,
                  ))),
          _buildAccountSettingsList(),
          Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  padding:
                      new EdgeInsets.only(top: 10.0, left: 10.0, bottom: 5.0),
                  child: Text(
                      AppLocalizations.of(context)
                          .translate('settings_general'),
                      style: Theme.of(context).textTheme.title))),
          _buildGeneralSettingsList(),
        ],
      ),
      StoreConnector<AppState, bool>(
        converter: (store) => store.state.auth.isLoading,
        builder: (context, isLoading) => Visibility(
          visible: isLoading,
          child: CustomProgressIndicatorWidget(),
        ),
      )
    ]));
  }

  _buildAccountSettingsList() {
    return ListView(shrinkWrap: true, children: <Widget>[
      ListTile(
        dense: true,
        leading: Icon(Icons.email),
        title: FlatButton(
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.changeEmail);
            },
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)
                      .translate('settings_change_email'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: Theme.of(context).textTheme.title,
                ))),
      ),
      ListTile(
        dense: true,
        leading: Icon(Icons.lock),
        title: FlatButton(
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.changePassword);
            },
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)
                      .translate('settings_change_password'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: Theme.of(context).textTheme.title,
                ))),
      ),
      ListTile(
        dense: true,
        leading: Icon(Icons.delete),
        title: FlatButton(
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.deleteAccount);
            },
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)
                      .translate('settings_delete_account'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: Theme.of(context).textTheme.title,
                ))),
      )
    ]);
  }

  _buildGeneralSettingsList() {
    return ListView(shrinkWrap: true, children: <Widget>[
      ListTile(
        dense: true,
        leading: Icon(Icons.language),
        title: FlatButton(
            onPressed: () {
              _buildLanguageDialog();
            },
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context).translate('settings_language'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: Theme.of(context).textTheme.title,
                ))),
      ),
      ListTile(
        dense: true,
        leading: Icon(Icons.brightness_3),
        title: FlatButton(
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.darkMode);
            },
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context).translate('settings_dark_mode'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: Theme.of(context).textTheme.title,
                ))),
      ),
      ListTile(
        dense: true,
        leading: Icon(Icons.power_settings_new),
        title: StoreConnector<AppState, _LogoutTileModel>(
            converter: (store) {
              return _LogoutTileModel(
                  auth: store.state.auth,
                  logout: () => store.dispatch(logout()));
            },
            onWillChange: (previousViewModel, newViewModel) async {
              if (previousViewModel.auth.transactionType ==
                      AuthTransactionType.LOGOUT &&
                  newViewModel.auth.isSuccess == true) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    Routes.login, (Route<dynamic> route) => false);
              }
              if (previousViewModel.auth.transactionType ==
                      AuthTransactionType.LOGOUT &&
                  newViewModel.auth.isSuccess == false) {
                (await KryptonSingleton.getInstance()).reinitialize();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    Routes.login, (Route<dynamic> route) => false);
              }
            },
            builder: (context, model) => FlatButton(
                onPressed: () async {
                  model.logout();
                },
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context).translate('settings_logout'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: Theme.of(context).textTheme.title,
                    )))),
      )
    ]);
  }

  _buildLanguageDialog() {
    _showDialog<String>(
      context: context,
      child: MaterialDialog(
        borderRadius: 5.0,
        enableFullWidth: true,
        title: Text(
          AppLocalizations.of(context).translate('settings_choose_language'),
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
        children: supportedLanguages
            .map(
              (object) => StoreConnector<AppState, Store<AppState>>(
                  converter: (store) => store,
                  builder: (context, store) => ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.all(0.0),
                        title: Text(
                          object.language,
                          style: TextStyle(
                            color: store.state.language.locale == object.locale
                                ? Theme.of(context).primaryColor
                                : store.state.theme.isDark
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          // change user language based on selected locale
                          store.dispatch(
                              new ChangeLanguageAction(object.locale));
                        },
                      )),
            )
            .toList(),
      ),
    );
  }

  _showDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) {
      // The value passed to Navigator.pop() or null.
    });
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
}

class _LogoutTileModel {
  final AuthState auth;
  final VoidCallback logout;
  _LogoutTileModel({this.auth, this.logout});
}
