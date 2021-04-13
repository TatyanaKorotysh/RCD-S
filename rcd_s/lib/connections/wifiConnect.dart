import 'package:flutter/material.dart';
import 'package:rcd_s/components/qrReader.dart';
import 'package:rcd_s/components/simpleAlert.dart';
import 'package:rcd_s/models/wifiModel.dart';
import 'package:rcd_s/screens/devices.dart';
import 'package:rcd_s/services/json.dart';
import 'package:wifi/wifi.dart';

Future connectToWiFi(String ssid, String password, BuildContext context) async {
  //ssid = "Simple Solutions BN";
  //password = "296147896";
  ssid = "qas";
  password = "qasPioner422";
  Wifi.connection(ssid, password).then((value) {
    switch (value) {
      case WifiState.error:
        simpleAlert(
            "Не удается подключиться к этой сети",
            "Возможно введенные данные неверны или сеть на данный момент недоступна",
            context);
        break;
      case WifiState.success:
        JsonService.createWifi(WifiModel(ssid, password).toJson());
        break;
      case WifiState.already:
        simpleAlert("Подключение активно",
            "Приложение уже подключено к этой сети", context);
        break;
    }
  });
}
