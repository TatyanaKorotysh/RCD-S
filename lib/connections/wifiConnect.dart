import 'package:flutter/material.dart';
import 'package:rcd_s/components/simpleAlert.dart';
import 'package:rcd_s/components/qrReader.dart';
import 'package:wifi/wifi.dart';

Future<Null> connectToWiFi(
    String ssid, String password, BuildContext context) async {
  ssid = "Simple Solutions BN";
  password = "296147896";
  //ssid = "qas";
  //password = "qasPioner422";
  Wifi.connection(ssid, password).then((value) {
    switch (value) {
      case WifiState.already:
        simpleAlert("Подключение активно",
            "Приложение уже подключено к этой сети", context);
        break;
      case WifiState.error:
        simpleAlert(
            "Не удается подключиться к этой сети",
            "Возможно введенные данные неверны или сеть на данный момент недоступна",
            context);
        break;
      case WifiState.success:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QrReader()),
        );
        break;
    }
  });
}
