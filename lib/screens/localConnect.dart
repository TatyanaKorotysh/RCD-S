import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rcd_s/components/simpleButton.dart';
import 'package:rcd_s/screens/createAdmin.dart';
import 'package:rcd_s/services/translate.dart';

class LocalConnect extends StatefulWidget {
  const LocalConnect({Key key}) : super(key: key);

  @override
  _LocalConnectState createState() {
    return _LocalConnectState();
  }
}

class _LocalConnectState extends State<LocalConnect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          simpleButton(
              context, AppLocalizations.of(context).translate('next'), next),
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
