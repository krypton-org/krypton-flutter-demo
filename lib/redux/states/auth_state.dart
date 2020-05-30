enum AuthTransactionType {
  CHECK_LOGIN_STATE,
  LOGIN,
  REGISTER,
  UPDATE_EMAIL,
  DELETE_ACCOUNT,
  CHANGE_PASSWORD,
  RECOVER_PASSWORD,
  LOGOUT,
}

class AuthState {
  bool isLoading;
  bool isSuccess;
  bool isLoggedIn;
  Map<String, dynamic> user;
  String error;
  AuthTransactionType transactionType;
  AuthState(
      {this.isLoading,
      this.isSuccess,
      this.isLoggedIn,
      this.error,
      this.user,
      this.transactionType});
}

AuthState getInitAuthState() =>
    AuthState(isLoading: false, isSuccess: false, isLoggedIn: false);
