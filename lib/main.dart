import 'package:krypton_flutter_demo/constants/app_theme.dart';
import 'package:krypton_flutter_demo/constants/strings.dart';
import 'package:krypton_flutter_demo/redux/states/language_state.dart';
import 'package:krypton_flutter_demo/redux/store.dart';
import 'package:krypton_flutter_demo/routes.dart';
import 'package:krypton_flutter_demo/ui/init/init.dart';
import 'package:krypton_flutter_demo/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:redux_thunk/redux_thunk.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) async {
    final persistor = Persistor<AppState>(
        storage: FlutterStorage(),
        serializer: JsonSerializer<AppState>(AppState.fromJson));
    final savedState = await persistor.load();
    runApp(new App(
        store: Store<AppState>(
      appStateReducer,
      initialState: savedState ?? initState(),
      middleware: [thunkMiddleware, persistor.createMiddleware()],
    )));
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
                  home: InitScreen(),
                )));
  }
}

class _MaterialModel {
  String locale;
  bool isDark;
  _MaterialModel({this.isDark, this.locale});
}
