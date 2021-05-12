import 'package:flutter/material.dart';
import 'package:rcd_s/services/globals.dart' as globals;

Widget simpleButton(BuildContext context, String lable, Function function) {
  /*return Container(
    child: InkWell(
      splashColor: Color.fromARGB(255, 45, 47, 122),
      child: Text(
        '$lable',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      onTap: function as void Function(),
    ),
    alignment: Alignment.center,
    color: Theme.of(context).accentColor,
    width: MediaQuery.of(context).size.width * 0.3,
    padding: EdgeInsets.symmetric(vertical: 7),
    decoration: BoxDecoration(
      boxShadow: 
    ),
  );*/
  return MaterialButton(
    child: Text(
      '$lable',
      style: TextStyle(color: Colors.white, fontSize: 18),
    ),
    splashColor: Color.fromARGB(255, 45, 47, 122),
    //onPressed: function as void Function(),
    color: Theme.of(context).accentColor,
    minWidth: MediaQuery.of(context).size.width * 0.3,
    elevation: 0,
    highlightElevation: 0,
    disabledElevation: 0,
    disabledColor: Color.fromARGB(255, 170, 170, 170),
    onPressed: (globals.isAdmin) ? function as void Function() : null,
  );
}
