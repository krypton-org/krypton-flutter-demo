import 'package:boilerplate/redux/states/auth_state.dart';
import 'package:boilerplate/redux/states/notify_state.dart';
import 'package:krypton/krypton.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../store.dart';
import 'notify_action.dart';

KryptonClient krypton = KryptonClient("https://nusid.net/krypton-auth");

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
      store.dispatch(TransactionFailAction(e.toString()));
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
      store.dispatch(TransactionFailAction(e.toString()));
    }
  };
}

ThunkAction<AppState> register(String email, String password) {
  return (Store<AppState> store) async {
    store.dispatch(new TransactionStartAction(AuthTransactionType.REGISTER));
    try {
      await krypton.register(email, password);
      store.dispatch(TransactionSucceedAction());
      store.dispatch(new AddloggedUserAction(krypton.user));
    } catch (e) {
      store.dispatch(TransactionFailAction(e.toString()));
    }
  };
}

ThunkAction<AppState> recoverPassword(String email) {
  return (Store<AppState> store) async {
    store.dispatch(
        new TransactionStartAction(AuthTransactionType.RECOVER_PASSWORD));
    try {
      //await krypton.recoverPassword(email);
      store.dispatch(TransactionSucceedAction());
      store.dispatch(NotifyAction(
          new Notification("NLS - Un email a été envoyé", Severity.SUCCESS)));
    } catch (e) {
      store.dispatch(TransactionFailAction(e.toString()));
    }
  };
}

ThunkAction<AppState> changePassword(
    String actualPassword, String newPassword) {
  return (Store<AppState> store) async {
    store.dispatch(
        new TransactionStartAction(AuthTransactionType.CHANGE_PASSWORD));
    try {
      //await krypton.changePassword(actualPassword, newPassword);
      store.dispatch(TransactionSucceedAction());
    } catch (e) {
      store.dispatch(TransactionFailAction(e.toString()));
    }
  };
}

ThunkAction<AppState> deleteAccount(String password) {
  return (Store<AppState> store) async {
    store.dispatch(
        new TransactionStartAction(AuthTransactionType.DELETE_ACCOUNT));
    try {
      //await krypton.deleteAccount(password);
      store.dispatch(TransactionSucceedAction());
    } catch (e) {
      store.dispatch(TransactionFailAction(e.toString()));
    }
  };
}

ThunkAction<AppState> updateEmail(String password) {
  return (Store<AppState> store) async {
    store
        .dispatch(new TransactionStartAction(AuthTransactionType.UPDATE_EMAIL));
    try {
      //await krypton.update({ email });
      store.dispatch(TransactionSucceedAction());
    } catch (e) {
      store.dispatch(TransactionFailAction(e.toString()));
    }
  };
}

ThunkAction<AppState> logOut() {
  return (Store<AppState> store) async {
    try {
      //await krypton.logOut({ email });
      store.dispatch(TransactionSucceedAction());
      store.dispatch(new RemoveloggedUserAction());
    } catch (e) {
      store.dispatch(TransactionFailAction(e.toString()));
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
