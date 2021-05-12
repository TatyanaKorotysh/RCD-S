import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rcd_s/connections/mqttConnect.dart';
import 'package:rcd_s/devices/command_manager.dart';
import 'package:rcd_s/screens/appLang.dart';
import 'package:rcd_s/screens/authorization.dart';
import 'package:rcd_s/services/json.dart';
import 'package:rcd_s/services/translate.dart';
import 'package:rcd_s/storage/settings_storage.dart';
import 'package:toast/toast.dart';
import 'package:rcd_s/services/globals.dart' as globals;

class Loading extends StatefulWidget {
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  var mqttManager;
  //StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    //initConnectivity();
    //_connectivitySubscription =
    //   _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  @override
  void dispose() {
    // _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ConnectivityResult>(
      future: initConnectivity(),
      builder:
          (BuildContext context, AsyncSnapshot<ConnectivityResult> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != ConnectivityResult.none) {
            return Scaffold(
              body: FutureBuilder<bool>(
                future: JsonService.isAdminExist(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == true) {
                      //JsonService.deleteFiles();
                      return Authorization();
                    } else {
                      //JsonService.creatrFiles();
                      return AppLang();
                    }
                  } else {
                    return Image(
                      image: AssetImage("assets/img/preloader.gif"),
                      width: MediaQuery.of(context).size.width * 0.3,
                    );
                  }
                },
              ),
            );
          } else {
            return Scaffold(
              body: SingleChildScrollView(
                child: Center(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (globals.theme == "light")
                            ? Image(
                                image: AssetImage("assets/img/logo.png"),
                                width: MediaQuery.of(context).size.height * 0.5)
                            : Image(
                                image: AssetImage("assets/img/logo_light.png"),
                                width:
                                    MediaQuery.of(context).size.height * 0.5),
                        Padding(padding: EdgeInsets.only(top: 50)),
                        Text(
                          "Для использования приложения необходимо подключение к Интернет. Пожалуйста убедитесь что сеть доступна",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.2),
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.55,
                    decoration: new BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(50, 56, 140, 203),
                          spreadRadius: 5.0,
                          blurRadius: 7.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        } else {
          return Image(
            image: AssetImage("assets/img/preloader.gif"),
            width: MediaQuery.of(context).size.width * 0.3,
          );
        }
      },
    );
  }

  Future<ConnectivityResult> initConnectivity() async {
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

    //setState(() {
    //  result = result;
    //});
    _updateConnectionStatus(result);
    print(result);
    return result;
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
        setState(() => _connectionStatus = result);
        break;
      default:
        setState(() => _connectionStatus = ConnectivityResult.none);
        break;
    }
  }
}
