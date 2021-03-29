import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rcd_s/components/simpleButton.dart';
import 'package:rcd_s/screens/createAdmin.dart';

class LocalConnect extends StatefulWidget {
  const LocalConnect({Key key}) : super(key: key);

  @override
  _LocalConnectState createState() => _LocalConnectState();
}

class _LocalConnectState extends State<LocalConnect> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          simpleButton(context, "Далее >>", next),
        ],
      ),
    );
  }

  void next() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateAdmin()),
    );
  }
}
