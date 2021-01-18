import 'package:flutter/material.dart';
import 'package:rcd_s/devices.dart';

class Menu extends StatelessWidget {
  static String currentTitle;
  static var currentContext;

  Menu(String title, var context) {
    currentTitle = title;
    currentContext = context;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }

  Widget menu = Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text(
            '$currentTitle',
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
          decoration: BoxDecoration(
            color: Colors.indigo,
          ),
        ),
        ListTile(
          title: Text('Профиль'),
          onTap: () {
            //Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Устройства'),
          onTap: () {
            Navigator.push(currentContext,
                MaterialPageRoute(builder: (context) {
              return Devices();
            }));
          },
        ),
        ListTile(
          title: Text('Сценарии'),
          onTap: () {
            //Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Роли'),
          onTap: () {
            //Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Настройки'),
          onTap: () {
            //Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
