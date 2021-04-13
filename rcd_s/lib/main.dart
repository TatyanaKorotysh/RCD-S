import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcd_s/connections/mqttConnect.dart';
import 'package:rcd_s/screens/appLang.dart';
import 'package:rcd_s/components/simpleButton.dart';
import 'package:rcd_s/screens/loading.dart';
import 'package:rcd_s/services/json.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rcd_s/services/theme.dart';
import 'package:rcd_s/services/translate.dart';
import 'package:rcd_s/services/globals.dart' as globals;

import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

void _enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _enablePlatformOverrideForDesktop();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  runApp(MyApp(
    appLanguage: appLanguage,
  ));
}

class MyApp extends StatelessWidget {
  final AppLanguage appLanguage;

  MyApp({this.appLanguage});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppLanguage>(
      create: (_) => appLanguage,
      child: Consumer<AppLanguage>(
        builder: (context, model, child) {
          return ChangeNotifierProvider<ThemeChanger>(
            create: (_) => (globals.theme == "light")
                ? ThemeChanger(ThemeData.light())
                : ThemeChanger(ThemeData.dark()),
            child: Screen(model),
          );
        },
      ),
    );
  }
}

class Screen extends StatelessWidget {
  static var model;

  Screen(var val) {
    model = val;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);

    return MaterialApp(
      title: 'RCD-S',
      locale: model.appLocal,
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ru', 'BY'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: theme.getTheme(),
      home: Loading(),
    );
  }
}
