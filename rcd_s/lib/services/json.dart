import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:rcd_s/models/userModel.dart';

class JsonService {
  static void createUser(Map<String, dynamic> user) async {
    final directory = await getApplicationDocumentsDirectory();
    final File file = File(directory.path + '/data/users.json');

    String jsonString = await file.readAsString();

    Map<String, dynamic> users;
    if (jsonString == "") {
      users.addAll(user);
    } else {
      jsonString = jsonString.replaceAll(new RegExp(r'[\\]+'), '');
      jsonString = jsonString.replaceFirst('"', "");
      jsonString =
          jsonString.replaceRange(jsonString.length - 1, jsonString.length, "");

      Map<String, dynamic> users = jsonDecode(jsonString);
      List<dynamic> usersList = [users];
      usersList.add(user);

      //Map<String, dynamic> usersJson = jsonDecode(usersList.toString());
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

  static Future<bool> isAdminExist() async {
    final directory = await getApplicationDocumentsDirectory();
    final File file = File(directory.path + '/data/users.json');

    /*if (!file.existsSync()) {
      new File(directory.path + '/data/users.json').create(recursive: true);
    } else {
      File(directory.path + '/data/users.json').deleteSync();
      File(directory.path + '/data/users.json').createSync(recursive: true);
    }*/

    String jsonString = await file.readAsString();

    if (jsonString == "") {
      return false;
    } else {
      return true;
    }
  }

  static Future<String> checkUser(String login, String password) async {
    final directory = await getApplicationDocumentsDirectory();
    final File file = File(directory.path + '/data/users.json');

    String jsonString = await file.readAsString();

    jsonString = jsonString.replaceAll(new RegExp(r'[\\]+'), '');
    jsonString = jsonString.replaceFirst('"', "");
    jsonString =
        jsonString.replaceRange(jsonString.length - 1, jsonString.length, "");

    Map<String, dynamic> users = jsonDecode(jsonString);
    List<dynamic> usersList = [users];
    UserModel admin = UserModel("Sub", "222", false);
    Map<String, dynamic> adminJson = admin.toJson();
    usersList.add(adminJson);

    for (var ul in usersList) {
      if (ul["login"] == login) {
        if (password == ul['password']) {
          return "true";
        } else {
          return "Неверный пароль. Убедитесь, что логин или пароль введены верно";
        }
      }
    }
    return "Пользователя с таким именем не существует";
  }
}
