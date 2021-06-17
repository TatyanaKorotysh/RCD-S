import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
//import 'package:rcd_s/connections/mqttAppState.dart';
import 'package:rcd_s/connections/mqttConnect.dart';
import 'package:rcd_s/devices/command_manager.dart';
import 'package:rcd_s/models/device.dart';
import 'package:rcd_s/models/group.dart';
import 'package:rcd_s/models/settings_8767.dart';
import 'package:rcd_s/screens/loading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rcd_s/services/theme.dart';
import 'package:rcd_s/services/translate.dart';
import 'package:rcd_s/services/globals.dart' as globals;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:rcd_s/splash_screen.dart';
import 'package:rcd_s/storage/group_storage.dart';
import 'package:rcd_s/storage/local_storage.dart';
import 'package:rcd_s/storage/settings_storage.dart';
import 'package:path_provider/path_provider.dart' as part_provider;

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

  final appDocumentDirectory =
      await part_provider.getApplicationDocumentsDirectory();

  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(DeviceAdapter());
  Hive.registerAdapter(GroupAdapter());
  Hive.registerAdapter(Settings8767Adapter());

  await Hive.openBox<Device>("devices");
  await Hive.openBox<Group>("groups");
  await Hive.openBox<Settings8767>("settings");

  var mqttManager = MqttManager();
  var settings8767Storage = Settings8767Storage();
  var _deviceStorage = DeviceLocalStorage(settings8767Storage);
  var _groupsStorage = GroupLocalStorage(settings8767Storage);
  CommandManager commandManager = CommandManager(
      _deviceStorage, _groupsStorage, mqttManager, settings8767Storage);

  //CommandManagerChanger commandManagerChanger;

  runApp(MultiProvider(
    providers: [
      ListenableProvider<CommandManager>(
        //ChangeNotifierProvider<CommandManagerChanger>(
        create: (context) => commandManager,
      ),
      Provider<DeviceLocalStorage>(
        //ChangeNotifierProvider<CommandManagerChanger>(
        create: (_) => _deviceStorage,
      ),
      Provider<GroupLocalStorage>(
        //ChangeNotifierProvider<CommandManagerChanger>(
        create: (_) => _groupsStorage,
      ),
      ChangeNotifierProvider<AppLanguage>(
        create: (_) => appLanguage,
      ),
    ],
    child: MyApp(
      appLanguage: appLanguage,
    ),
  ));
}

class MyApp extends StatelessWidget {
  //static MqttManager model = new MqttManager();
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
                ? ThemeChanger(
                    ThemeData(
                        brightness: Brightness.light,
                        primaryColor: Color.fromARGB(255, 56, 140, 203),
                        accentColor: Color.fromARGB(255, 56, 140, 203),
                        fontFamily: 'Raleway'),
                  )
                : ThemeChanger(
                    ThemeData(
                      brightness: Brightness.dark,
                      primaryColor: Color.fromARGB(255, 56, 140, 203),
                      accentColor: Color.fromARGB(255, 56, 140, 203),
                      fontFamily: 'Raleway',
                    ),
                  ),
            //child: ChangeNotifierProvider<MqttAppState>(
            // create: (_) => MqttAppState(),
            child: Screen(model),
            //  ),
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
      home: SplashScreen(), //Loading(),
    );
  }
}
