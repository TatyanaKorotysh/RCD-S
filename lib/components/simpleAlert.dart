import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<dynamic> simpleAlert(
    String title, String message, BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("$title"),
          content: Text("$message"),
        );
      });
}
