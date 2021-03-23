import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget simpleAlert(String title, String message, BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("$title"),
          content: Text("$message"),
        );
      });
}
