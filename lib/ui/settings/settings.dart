import 'package:boilerplate/data/sharedpref/constants/preferences.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/stores/auth/auth_store.dart';
import 'package:boilerplate/stores/language/language_store.dart';
import 'package:boilerplate/stores/theme/theme_store.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  LanguageStore _languageStore;
  ThemeStore _themeStore;
  AuthStore _authStore;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _languageStore = Provider.of<LanguageStore>(context);
    _themeStore = Provider.of<ThemeStore>(context);
    _authStore = Provider.of<AuthStore>(context);
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
      title: Text(AppLocalizations.of(context).translate('settings_title')),
    );
  }

  Widget _buildHistoryBackButton() {
    return Observer(
      builder: (context) {
        return IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(Routes.home);
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
      child: Column(
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
    );
  }

  _buildAccountSettingsList() {
    return ListView(shrinkWrap: true, children: <Widget>[
      ListTile(
        dense: true,
        leading: Icon(Icons.email),
        title: FlatButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(Routes.changeEmail);
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
              Navigator.of(context).pushReplacementNamed(Routes.changePassword);
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
              Navigator.of(context).pushReplacementNamed(Routes.deleteAccount);
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
              Navigator.of(context).pushReplacementNamed(Routes.darkMode);
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
        title: FlatButton(
            onPressed: () async {
              var preference = await SharedPreferences.getInstance();
              preference.setBool(Preferences.is_logged_in, false);
              await _authStore.logout();
              Navigator.of(context).pushReplacementNamed(Routes.login);
            },
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context).translate('settings_logout'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: Theme.of(context).textTheme.title,
                ))),
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
          AppLocalizations.of(context).translate('home_tv_choose_language'),
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
        children: _languageStore.supportedLanguages
            .map(
              (object) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(0.0),
                title: Text(
                  object.language,
                  style: TextStyle(
                    color: _languageStore.locale == object.locale
                        ? Theme.of(context).primaryColor
                        : _themeStore.darkMode ? Colors.white : Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // change user language based on selected locale
                  _languageStore.changeLanguage(object.locale);
                },
              ),
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
          title: AppLocalizations.of(context).translate('home_tv_error'),
          duration: Duration(seconds: 3),
        )..show(context);
      }
    });

    return SizedBox.shrink();
  }
}
