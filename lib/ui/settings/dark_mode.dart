import 'package:boilerplate/redux/actions/theme_action.dart';
import 'package:boilerplate/redux/store.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_redux/flutter_redux.dart';

class DarkModeScreen extends StatefulWidget {
  @override
  _DarkModeScreenState createState() => _DarkModeScreenState();
}

class _DarkModeScreenState extends State<DarkModeScreen> {
  //stores:---------------------------------------------------------------------

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
      title: Text(AppLocalizations.of(context).translate('settings_dark_mode')),
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
  //            _themeStore.changeBrightnessToDark(!_themeStore.darkMode);

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Material(
      child: Column(children: <Widget>[
        MergeSemantics(
            child: StoreConnector<AppState, _SwitchDarkModeModel>(
                converter: (store) => _SwitchDarkModeModel(
                    isDark: store.state.theme.isDark,
                    setBrightMode: () =>
                        store.dispatch(new BrightThemeAction()),
                    setDarkMode: () => store.dispatch(new DarkThemeAction())),
                builder: (context, model) => ListTile(
                      title: Container(
                          padding: new EdgeInsets.only(
                              top: 5.0, left: 10.0, bottom: 5.0),
                          child: Text(
                              AppLocalizations.of(context)
                                  .translate('settings_enable_dark_mode'),
                              style: Theme.of(context).textTheme.title)),
                      trailing: CupertinoSwitch(
                        value: model.isDark,
                        onChanged: (bool value) {
                          if (value) {
                            model.setDarkMode();
                          } else {
                            model.setBrightMode();
                          }
                        },
                      ),
                      onTap: () {
                        if (model.isDark) {
                          model.setBrightMode();
                        } else {
                          model.setDarkMode();
                        }
                      },
                    )))
      ]),
    );
  }
}

class _SwitchDarkModeModel {
  final bool isDark;
  final Function() setBrightMode;
  final Function() setDarkMode;
  _SwitchDarkModeModel({this.isDark, this.setBrightMode, this.setDarkMode});
}
