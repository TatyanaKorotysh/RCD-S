import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rcd_s/components/input.dart';
import 'package:rcd_s/components/simpleButton.dart';
import 'package:rcd_s/connections/wifiConnect.dart';
import 'package:rcd_s/models/wifi.dart';
import 'package:rcd_s/services/json.dart';

class WifiConnect extends StatefulWidget {
  const WifiConnect({Key key}) : super(key: key);

  @override
  _WifiConnectState createState() => _WifiConnectState();
}

class _WifiConnectState extends State<WifiConnect> {
  TextEditingController _wifiController = TextEditingController();
  TextEditingController _wifiPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              input(
                  "Имя Wi-Fi сети", TextInputType.name, _wifiController, false),
              input(
                  "Пароль", TextInputType.name, _wifiPasswordController, true),
              Padding(padding: EdgeInsets.all(20.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  simpleButton(context, "Назад", cancel),
                  Padding(padding: EdgeInsets.all(20.0)),
                  simpleButton(context, "Подключить", connect),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void cancel() {
    Navigator.pop(context);
  }

  void connect() {
    WifiModel wifi =
        WifiModel(_wifiController.text, _wifiPasswordController.text);
    Map<String, dynamic> wifiJson = wifi.toJson();

    JsonService.createWifi(wifiJson);

    connectToWiFi(_wifiController.text, _wifiPasswordController.text, context);
  }
}
