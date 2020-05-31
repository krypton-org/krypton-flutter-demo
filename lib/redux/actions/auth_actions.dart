import 'package:boilerplate/models/krypton/krypton_singleton.dart';
import 'package:boilerplate/redux/states/auth_state.dart';
import 'package:boilerplate/redux/states/notify_state.dart';
import 'package:krypton/krypton.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../store.dart';
import 'notify_action.dart';

KryptonClient krypton = KryptonSingleton.getInstance();

ThunkAction<AppState> checkLoginState() {
  return (Store<AppState> store) async {
    store.dispatch(
        new TransactionStartAction(AuthTransactionType.CHECK_LOGIN_STATE));
    try {
      bool isLoggedIn = await krypton.isLoggedIn();
      store.dispatch(TransactionSucceedAction());
      if (isLoggedIn) {
        store.dispatch(new AddloggedUserAction(krypton.user));
      }
    } catch (e) {
      store.dispatch(TransactionFailAction(e.message));
    }
  };
}

ThunkAction<AppState> login(String email, String password) {
  return (Store<AppState> store) async {
    store.dispatch(new TransactionStartAction(AuthTransactionType.LOGIN));
    try {
      await krypton.login(email, password);
      store.dispatch(TransactionSucceedAction());
      store.dispatch(new AddloggedUserAction(krypton.user));
    } catch (e) {
      store.dispatch(TransactionFailAction(e.message));
    }
  };
}

ThunkAction<AppState> registerAndLogin(String email, String password) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(new TransactionStartAction(AuthTransactionType.REGISTER));
      await krypton.register(email, password);
      store.dispatch(TransactionSucceedAction());
      store.dispatch(new TransactionStartAction(AuthTransactionType.LOGIN));
      await krypton.login(email, password);
      store.dispatch(TransactionSucceedAction());
      store.dispatch(new AddloggedUserAction(krypton.user));
    } catch (e) {
      store.dispatch(TransactionFailAction(e.message));
    }
  };
}

ThunkAction<AppState> recoverPassword(String email) {
  return (Store<AppState> store) async {
    store.dispatch(
        new TransactionStartAction(AuthTransactionType.RECOVER_PASSWORD));
    try {
      await krypton.recoverPassword(email);
      store.dispatch(TransactionSucceedAction());
      store.dispatch(NotifyAction(
          new Notification("NLS - Un email a été envoyé", Severity.SUCCESS)));
    } catch (e) {
      store.dispatch(TransactionFailAction(e.message));
    }
  };
}

ThunkAction<AppState> changePassword(
    String actualPassword, String newPassword) {
  return (Store<AppState> store) async {
    store.dispatch(
        new TransactionStartAction(AuthTransactionType.CHANGE_PASSWORD));
    try {
      await krypton.changePassword(actualPassword, newPassword);
      store.dispatch(TransactionSucceedAction());
    } catch (e) {
      store.dispatch(TransactionFailAction(e.message));
    }
  };
}

ThunkAction<AppState> deleteAccount(String password) {
  return (Store<AppState> store) async {
    store.dispatch(
        new TransactionStartAction(AuthTransactionType.DELETE_ACCOUNT));
    try {
      await krypton.delete(password);
      store.dispatch(TransactionSucceedAction());
    } catch (e) {
      store.dispatch(TransactionFailAction(e.message));
    }
  };
}

ThunkAction<AppState> updateEmail(String email) {
  return (Store<AppState> store) async {
    store
        .dispatch(new TransactionStartAction(AuthTransactionType.UPDATE_EMAIL));
    try {
      await krypton.update({'email': email});
      store.dispatch(TransactionSucceedAction());
      store.dispatch(new AddloggedUserAction(krypton.user));
    } catch (e) {
      store.dispatch(TransactionFailAction(e.message));
    }
  };
}

ThunkAction<AppState> logout() {
  return (Store<AppState> store) async {
    store.dispatch(new TransactionStartAction(AuthTransactionType.LOGOUT));
    try {
      await krypton.logout();
      store.dispatch(TransactionSucceedAction());
      store.dispatch(new RemoveloggedUserAction());
    } catch (e) {
      store.dispatch(TransactionFailAction(e.message));
    }
  };
}

class TransactionStartAction {
  AuthTransactionType transactionType;
  TransactionStartAction(this.transactionType);
}

class TransactionFailAction {
  String error;
  TransactionFailAction(this.error);
}

class TransactionSucceedAction {}

class AddloggedUserAction {
  Map<String, dynamic> user;
  AddloggedUserAction(this.user);
}

class RemoveloggedUserAction {}
