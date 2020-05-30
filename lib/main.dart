import 'package:boilerplate/constants/app_theme.dart';
import 'package:boilerplate/constants/strings.dart';
import 'package:boilerplate/redux/states/language_state.dart';
import 'package:boilerplate/redux/store.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/ui/splash/splash.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() {
  final store = getStore();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) async {
    runApp(new App(store: store));
  });
}

class App extends StatelessWidget {
  final Store<AppState> store;
  
  App({Key key, this.store}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new StoreProvider<AppState>(
        store: store,
        child: StoreConnector<AppState, _MaterialModel>(
            converter: (store) => _MaterialModel(
                isDark: store.state.theme.isDark,
                locale: store.state.language.locale),
            builder: (context, model) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: Strings.appName,
                  theme: model.isDark ? themeDataDark : themeData,
                  routes: Routes.routes,
                  locale: Locale(model.locale),
                  supportedLocales: supportedLanguages
                      .map((language) => Locale(language.locale, language.code))
                      .toList(),
                  localizationsDelegates: [
                    // A class which loads the translations from JSON files
                    AppLocalizations.delegate,
                    // Built-in localization of basic text for Material widgets
                    GlobalMaterialLocalizations.delegate,
                    // Built-in localization for text direction LTR/RTL
                    GlobalWidgetsLocalizations.delegate,
                    // Built-in localization of basic text for Cupertino widgets
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  // Returns a locale which will be used by the app
                  localeResolutionCallback: (locale, supportedLocales) =>
                      // Check if the current device locale is supported
                      supportedLocales.firstWhere(
                          (supportedLocale) =>
                              supportedLocale.languageCode ==
                              locale.languageCode,
                          orElse: () => supportedLocales.first),
                  home: SplashScreen(),
                )));
  }
}

class _MaterialModel {
  String locale;
  bool isDark;
  _MaterialModel({this.isDark, this.locale});
}
