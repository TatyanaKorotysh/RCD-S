import 'package:flutter/material.dart';
import 'package:rcd_s/screens/authorization.dart';
import 'package:rcd_s/screens/devices.dart';
import 'package:rcd_s/screens/preferences.dart';
import 'package:rcd_s/screens/users.dart';

class Menu extends StatefulWidget {
  static String currentTitle;
  static var currentContext;

  Menu(String title, var context) {
    currentTitle = title;
    currentContext = context;
  }

  @override
  _MenuState createState() => _MenuState(currentTitle, currentContext);
}

class _MenuState extends State<Menu> {
  static String currentTitle;
  static var currentContext;

  _MenuState(String title, var context) {
    currentTitle = title;
    currentContext = context;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              '$currentTitle',
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
            ),
          ),
          ListTile(
            leading: Icon(Icons.devices_other_rounded),
            title: Text('Устройства'),
            onTap: () {
              Navigator.push(currentContext,
                  MaterialPageRoute(builder: (context) {
                return Devices();
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.schedule_rounded),
            title: Text('Сценарии'),
            onTap: () {
              //Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.supervised_user_circle_rounded),
            title: Text('Пользователи'),
            onTap: () {
              Navigator.push(currentContext,
                  MaterialPageRoute(builder: (context) {
                return Users();
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Настройки'),
            onTap: () {
              Navigator.push(currentContext,
                  MaterialPageRoute(builder: (context) {
                return Preferences();
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app_rounded),
            title: Text('Выйти'),
            onTap: () {
              Navigator.push(currentContext,
                  MaterialPageRoute(builder: (context) {
                return Authorization();
              }));
            },
          ),
        ],
      ),
    );
  }
}
