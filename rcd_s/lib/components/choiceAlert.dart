import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<dynamic> choiceAlert(String title, String message, String buttonText,
    Function function, BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("$title"),
          content: Text("$message"),
          actions: <Widget>[
            TextButton(
              child: Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('$buttonText'),
              onPressed: () {
                Navigator.of(context).pop();
                function();
              },
            ),
          ],
        );
      });
}
