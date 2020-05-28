import 'dart:async';
import 'package:boilerplate/redux/store.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/widgets/app_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

const SPLASH_SCREEN_TIME = 5000;

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, bool>(
        converter: (store) => store.state.auth.isLoggedIn,
        builder: (context, isLoggedIn) => Material(
            child: Center(
                child: AppIconWidget(image: 'assets/icons/ic_appicon.png'))),
        onInitialBuild: (isLoggedIn) => {
              Future.delayed(
                  Duration(milliseconds: SPLASH_SCREEN_TIME),
                  () => {
                        if (isLoggedIn ?? false)
                          {
                            Navigator.of(context)
                                .pushReplacementNamed(Routes.home)
                          }
                        else
                          {
                            Navigator.of(context)
                                .pushReplacementNamed(Routes.login)
                          }
                      })
            });
  }
}
