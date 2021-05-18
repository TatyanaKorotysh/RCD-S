import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rcd_s/components/input.dart';
import 'package:rcd_s/screens/qrReader.dart';
import 'package:rcd_s/components/simpleButton.dart';
import 'package:rcd_s/connections/wifiConnect.dart';
import 'package:rcd_s/models/wifiModel.dart';
import 'package:rcd_s/services/json.dart';
import 'package:rcd_s/services/translate.dart';

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
  void dispose() {
    _wifiController.dispose();
    _wifiPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              Text(AppLocalizations.of(context).translate('createWifi')),
              input(AppLocalizations.of(context).translate('wifiName'),
                  TextInputType.name, _wifiController, false, context),
              input(AppLocalizations.of(context).translate('password'),
                  TextInputType.name, _wifiPasswordController, true, context),
              Padding(padding: EdgeInsets.all(20.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  simpleButton(context,
                      AppLocalizations.of(context).translate('back'), cancel),
                  Padding(padding: EdgeInsets.all(20.0)),
                  simpleButton(
                      context,
                      AppLocalizations.of(context).translate('connect'),
                      connect),
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
    WifiModel wifi = WifiModel(
        _wifiController.text.trim(), _wifiPasswordController.text.trim());
    Map<String, dynamic> wifiJson = wifi.toJson();

    JsonService.createWifi(wifiJson);

    connectToWiFi(_wifiController.text.trim(),
        _wifiPasswordController.text.trim(), context);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QrReader()),
    );
  }
}
