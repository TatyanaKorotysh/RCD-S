import 'package:flutter/material.dart';
import 'package:rcd_s/screens/authorization.dart';
import 'package:rcd_s/screens/localConnect.dart';
import 'package:rcd_s/services/json.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<bool>(
        future: JsonService.isAdminExist(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.data == true) {
            return Authorization();
          } else {
            return LocalConnect();
          }
        },
      ),
    );
  }
}
