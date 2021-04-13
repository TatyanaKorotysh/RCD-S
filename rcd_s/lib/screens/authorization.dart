import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rcd_s/components/input.dart';
import 'package:rcd_s/components/qrReader.dart';
import 'package:rcd_s/connections/mqttConnect.dart';
import 'package:rcd_s/connections/wifiConnect.dart';
import 'package:rcd_s/screens/devices.dart';
import 'package:rcd_s/services/json.dart';
import 'package:rcd_s/services/translate.dart';
import 'package:toast/toast.dart';
import 'package:rcd_s/services/globals.dart' as globals;

class Authorization extends StatefulWidget {
  @override
  AuthorizationState createState() {
    return AuthorizationState();
  }
}

class AuthorizationState extends State<Authorization> {
  final _formKey = GlobalKey<FormState>();
  final _sizeTextWhite = const TextStyle(fontSize: 20.0, color: Colors.white);

  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              input(AppLocalizations.of(context).translate('login'),
                  TextInputType.name, _loginController, false),
              input(AppLocalizations.of(context).translate('password'),
                  TextInputType.text, _passwordController, true),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: MaterialButton(
                  onPressed: submit,
                  child: Text(AppLocalizations.of(context).translate('logIn'),
                      style: _sizeTextWhite),
                  color: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submit() {
    Future<String> result = JsonService.checkUser(
        _loginController.text.trim(), _passwordController.text.trim(), context);

    result.then((String r) => {
          if (r == "true")
            {
              //connectToWiFi("ssid", "password", context),
              connectToMqtt("code", context, onFailure: () {}),
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Devices()),
              ),
              JsonService.getPreferences().then((Map prefMap) {
                //print(prefMap);
                globals.lang = prefMap[_loginController.text.trim()][0];
                //globals.theme = prefMap[_loginController.text.trim()][1];
              })
              /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QrReader()),
              )*/
            }
          else
            {Toast.show(r, context, duration: Toast.LENGTH_LONG)}
        });

    //_loginController.clear();
    //_passwordController.clear();
  }
}
