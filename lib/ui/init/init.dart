import 'package:boilerplate/redux/actions/auth_actions.dart';
import 'package:boilerplate/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:boilerplate/redux/states/auth_state.dart';
import 'package:boilerplate/redux/store.dart';

class InitScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AuthState>(
        converter: (store) => store.state.auth,
        onInit: (store) => store.dispatch(checkLoginState()),
        builder: (context, authState) {
          return Material(child: Center(child: CircularProgressIndicator()));
        },
        onWillChange: (previousState, state) {
          if (previousState.transactionType ==
                  AuthTransactionType.CHECK_LOGIN_STATE &&
              previousState.isLoading == true &&
              state.isLoading == false) {
            if (state.isLoggedIn) {
              Navigator.of(context).pushReplacementNamed(Routes.home);
            } else {
              Navigator.of(context).pushReplacementNamed(Routes.login);
            }
          }
        });
  }
}
