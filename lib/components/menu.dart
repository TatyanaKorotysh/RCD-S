import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rcd_s/screens/qrReader.dart';
import 'package:rcd_s/screens/authorization.dart';
import 'package:rcd_s/screens/devices.dart';
import 'package:rcd_s/screens/groups.dart';
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
            padding: EdgeInsets.all(20),
            child: Text(
              '$currentTitle',
              style: TextStyle(fontSize: 26.0, color: Colors.white),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          ListTile(
            //leading: Icon(Icons.devices_other_rounded),
            leading: SvgPicture.asset(
              'assets/SVG/devices.svg',
              color: Color.fromARGB(255, 56, 140, 203),
              width: 30,
            ),
            title: Text(
              'Устройства',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.push(currentContext,
                  MaterialPageRoute(builder: (context) {
                return Devices();
              }));
            },
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          ListTile(
            //leading: Icon(Icons.schedule_rounded),
            leading: SvgPicture.asset(
              'assets/SVG/group.svg',
              color: Color.fromARGB(255, 56, 140, 203),
              width: 30,
            ),
            title: Text(
              'Группы',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.push(currentContext,
                  MaterialPageRoute(builder: (context) {
                return Groups();
              }));
            },
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          ListTile(
            //leading: Icon(Icons.supervised_user_circle_rounded),
            leading: SvgPicture.asset(
              'assets/SVG/users.svg',
              color: Color.fromARGB(255, 56, 140, 203),
              width: 30,
            ),
            title: Text(
              'Пользователи',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.push(currentContext,
                  MaterialPageRoute(builder: (context) {
                return Users();
              }));
            },
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Color.fromARGB(255, 56, 140, 203),
              size: 30,
            ),
            title: Text(
              'Настройки',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.push(currentContext,
                  MaterialPageRoute(builder: (context) {
                return Preferences();
              }));
            },
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          ListTile(
            leading: Icon(Icons.exit_to_app_rounded,
                color: Color.fromARGB(255, 56, 140, 203), size: 30),
            title: Text(
              'Выйти',
              style: TextStyle(fontSize: 16),
            ),
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
