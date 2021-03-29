import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class JsonService {
  static void createUser(Map<String, dynamic> user) async {
    final directory = await getApplicationDocumentsDirectory();
    final File file = File(directory.path + '/data/users.json');

    if (!file.existsSync()) {
      new File(directory.path + '/data/users.json').create(recursive: true);
    } else {
      File(directory.path + '/data/users.json').deleteSync();
      File(directory.path + '/data/users.json').createSync(recursive: true);
    }

    String jsonString = await file.readAsString();

    Map<String, dynamic> users;
    if (jsonString == "") {
      users = user;
    } else {
      users = json.decode(jsonString);
      users.addAll(user);
    }

    jsonString = json.encode(users);

    file.writeAsString(json.encode(jsonString));
  }

  static void createWifi(Map<String, dynamic> wifi) async {
    final directory = await getApplicationDocumentsDirectory();
    final File file = File(directory.path + '/data/wifi.json');

    if (!file.existsSync()) {
      new File(directory.path + '/data/wifi.json').create(recursive: true);
    } else {
      File(directory.path + '/data/wifi.json').deleteSync();
      File(directory.path + '/data/wifi.json').createSync(recursive: true);
    }

    String jsonString = await file.readAsString();

    Map<String, dynamic> wifis;
    if (jsonString == "") {
      wifis = wifi;
    } else {
      wifis = json.decode(jsonString);
      wifis.addAll(wifi);
    }

    jsonString = json.encode(wifis);

    file.writeAsString(json.encode(jsonString));
  }
}
