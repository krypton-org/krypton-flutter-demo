import 'package:boilerplate/ui/home/home.dart';
import 'package:boilerplate/ui/init/init.dart';
import 'package:boilerplate/ui/login/login.dart';
import 'package:boilerplate/ui/todos/add_todo.dart';
import 'package:boilerplate/ui/register/register.dart';
import 'package:boilerplate/ui/settings/change_email.dart';
import 'package:boilerplate/ui/settings/change_password.dart';
import 'package:boilerplate/ui/settings/dark_mode.dart';
import 'package:boilerplate/ui/settings/delete_account.dart';
import 'package:boilerplate/ui/settings/settings.dart';
import 'package:flutter/material.dart';


class Routes {
  Routes._();

  //static variables
  static const String forgorPasswordSplash = '/forgorPasswordSplash';
  static const String splash = '/init';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String changePassword = '/changePassword';
  static const String changeEmail = '/changeEmail';
  static const String darkMode = '/darkMode';
  static const String deleteAccount = '/deleteAccount';
  static const String addTodo = '/addAccount';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => InitScreen(),
    register: (BuildContext context) => RegisterScreen(),
    login: (BuildContext context) => LoginScreen(),
    home: (BuildContext context) => HomeScreen(),
    settings: (BuildContext context) => SettingsScreen(),
    changePassword: (BuildContext context) => ChangePasswordScreen(),
    changeEmail: (BuildContext context) => ChangeEmailScreen(),
    darkMode: (BuildContext context) => DarkModeScreen(),
    deleteAccount: (BuildContext context) => DeleteAccountScreen(),
    addTodo: (BuildContext context) => AddTodoScreen(),
  };
}



