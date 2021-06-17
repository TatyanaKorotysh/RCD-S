import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rcd_s/connections/wifiConnect.dart';
import 'package:rcd_s/models/preferencesModel.dart';
import 'package:rcd_s/services/translate.dart';
import 'globals.dart' as globals;

class JsonService {
  static creatrFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    new File(directory.path + '/data/users.json').create(recursive: true);
    new File(directory.path + '/data/wifi.json').create(recursive: true);
    new File(directory.path + '/data/preferences.json').create(recursive: true);
    new File(directory.path + '/data/connection.json').create(recursive: true);
  }

  static deleteFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    new File(directory.path + '/data/users.json').delete();
    new File(directory.path + '/data/wifi.json').delete();
    new File(directory.path + '/data/preferences.json').delete();
    new File(directory.path + '/data/connection.json').delete();
  }

  static Future<bool> createUser(Map<String, dynamic> user) async {
    final directory = await getApplicationDocumentsDirectory();
    final File file = File(directory.path + '/data/users.json');

    String jsonString = await file.readAsString();
    var usersMap;

    if (jsonString == "") {
      usersMap = user;
    } else {
      usersMap = jsonDecode(jsonString);
      if (usersMap["${user.keys.first}"] == null) {
        usersMap["${user.keys.first}"] = user["${user.keys.first}"];
      } else {
        return false;
      }
    }

    jsonString = json.encode(usersMap);
    file.writeAsString(jsonString);

    applyPreferences(
        PreferencesModel(user.keys.first, globals.lang, globals.theme)
            .toJson());

    return true;
  }

  static Future<bool> isQRExist() async {
    final directory = await getApplicationDocumentsDirectory();
    final File file = File(directory.path + '/data/connection.json');

    if (file.existsSync()) {
      String jsonString = await file.readAsString();

      if (jsonString == "") {
        return false;
      } else {
        return true;
      }
    }
    return false;
  }

  static Future<String> checkUser(
      String login, String password, BuildContext context) async {
    final directory = await getApplicationDocumentsDirectory();
    final File file = File(directory.path + '/data/users.json');

    String jsonString = await file.readAsString();

    var usersMap = jsonDecode(jsonString);

    if (usersMap["$login"] != null) {
      if (password == usersMap["$login"][0]) {
        globals.isAdmin = usersMap["$login"][1];
        globals.login = login;
        return "true";
      } else {
        return AppLocalizations.of(context).translate('paswordError');
      }
    }
    return AppLocalizations.of(context).translate('userError');
  }

  static Future<Map> getUsers() async {
    final directory = await getApplicationDocumentsDirectory();
    final File file = File(directory.path + '/data/users.json');

    String jsonString = await file.readAsString();

    var userMap = jsonDecode(jsonString);
    return userMap;
  }

  static Future<bool> chacgeUser(String key, Map<String, dynamic> user) async {
    final directory = await getApplicationDocumentsDirectory();
    final File file = File(directory.path + '/data/users.json');

    String jsonString = await file.readAsString();
    var usersMap = jsonDecode(jsonString);

    usersMap["${user.keys.first}"] = user["${user.keys.first}"];

    jsonString = json.encode(usersMap);
    file.writeAsString(jsonString);
    return true;
  }

  static void deleteUser(String key) async {
    final directory = await getApplicationDocumentsDirectory();
    final File file = File(directory.path + '/data/users.json');

    String jsonString = await file.readAsString();
    var usersMap = jsonDecode(jsonString);

    usersMap.remove('$key');

    jsonString = json.encode(usersMap);
    file.writeAsString(jsonString);

    deletePreferences(key);
  }

  static Future<bool> createWifi(Map<String, dynamic> wifi) async {
    final directory = await getApplicationDocumentsDirectory();
    final File file = File(directory.path + '/data/wifi.json');

    String jsonString = await file.readAsString();
    var usersMap;

    if (jsonString == "") {
      usersMap = wifi;
    } else {
      usersMap = jsonDecode(jsonString);
      if (usersMap["${wifi.keys.first}"] == null) {
        usersMap["${wifi.keys.first}"] = wifi["${wifi.keys.first}"];
      } else {
        return false;
      }
    }

    jsonString = json.encode(usersMap);
    file.writeAsString(jsonString);

    return true;
  }

  static Future<bool> applyPreferences(Map<String, dynamic> pref) async {
    final directory = await getApplicationDocumentsDirectory();
    final File file = File(directory.path + '/data/preferences.json');

    String jsonString = await file.readAsString();
    var prefMap;

    if (jsonString == "") {
      prefMap = pref;
    } else {
      prefMap = jsonDecode(jsonString);
      prefMap["${pref.keys.first}"] = pref["${pref.keys.first}"];
    }

    jsonString = json.encode(prefMap);
    file.writeAsString(jsonString);

    return true;
  }

  static Future<Map> getPreferences() async {
    final directory = await getApplicationDocumentsDirectory();
    final File file = File(directory.path + '/data/preferences.json');

    String jsonString = await file.readAsString();

    if (jsonString == "") {
      await applyPreferences(
          PreferencesModel(globals.login.trim(), "Русский", "light").toJson());
      String jsonString = await file.readAsString();
    }

    var prefMap = jsonDecode(jsonString);

    return prefMap;
  }

  static void deletePreferences(String key) async {
    final directory = await getApplicationDocumentsDirectory();
    final File file = File(directory.path + '/data/preferences.json');

    String jsonString = await file.readAsString();
    var usersMap = jsonDecode(jsonString);

    usersMap.remove('$key');

    jsonString = json.encode(usersMap);
    file.writeAsString(jsonString);
  }

  static Future<void> wifiConnect(BuildContext context) async {
    final directory = await getApplicationDocumentsDirectory();
    final File file = File(directory.path + '/data/wifi.json');

    String jsonString = await file.readAsString();
    if (jsonString != "") {
      var wifiMap = jsonDecode(jsonString);
      connectToWiFi(wifiMap["ssid"], wifiMap["password"], context);
    }
  }

  static Future<void> writeQr(String data) async {
    final directory = await getApplicationDocumentsDirectory();
    final File file = File(directory.path + '/data/connection.json');
    file.writeAsString(data);
  }

  static Future<Map> readQr() async {
    final directory = await getApplicationDocumentsDirectory();
    final File file = File(directory.path + '/data/connection.json');

    String jsonString = await file.readAsString();
    print(jsonString);
    var prefMap = jsonDecode(jsonString);
    print(prefMap);

    return prefMap;
  }
}
