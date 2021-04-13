import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rcd_s/connections/mqttConnect.dart';
import 'package:rcd_s/screens/appLang.dart';
import 'package:rcd_s/screens/authorization.dart';
import 'package:rcd_s/screens/localConnect.dart';
import 'package:rcd_s/services/json.dart';
import 'package:rcd_s/services/translate.dart';
import 'package:toast/toast.dart';

class Loading extends StatefulWidget {
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: JsonService.isAdminExist(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == true) {
            //JsonService.deleteFiles();
            return Authorization();
          } else {
            JsonService.creatrFiles();
            return AppLang();
          }
        } else {
          //вставить сюда картинку?
          return Text("");
        }
      },
    );
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        Toast.show(
            AppLocalizations.of(context).translate('wifiActive'), context,
            duration: Toast.LENGTH_LONG);
        //проверка: если данные для подключения есть, то вызываем функцию
        //connectToMqtt("code", context, onFailure: () {});
        break;
      case ConnectivityResult.mobile:
        Toast.show(
            AppLocalizations.of(context).translate('wifiMobile'), context,
            duration: Toast.LENGTH_LONG);
        break;
      case ConnectivityResult.none:
        Toast.show(AppLocalizations.of(context).translate('wifiNone'), context,
            duration: Toast.LENGTH_LONG);
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }
}
