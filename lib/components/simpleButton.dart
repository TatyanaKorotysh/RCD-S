import 'package:flutter/material.dart';

Widget simpleButton(BuildContext context, String lable, Function function) {
  return MaterialButton(
    child: Text('$lable'),
    onPressed: function as void Function(),
    color: Theme.of(context).accentColor,
    minWidth: MediaQuery.of(context).size.width * 0.3,
  );
}
