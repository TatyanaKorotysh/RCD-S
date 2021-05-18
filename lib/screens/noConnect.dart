import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rcd_s/components/simpleButton.dart';
import 'package:rcd_s/services/globals.dart' as globals;
import 'package:rcd_s/services/isConnect.dart';

class NoConnect extends StatefulWidget {
  _NoConnectState createState() => _NoConnectState();
}

class _NoConnectState extends State<NoConnect> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        width: MediaQuery.of(context).size.height * 0.5),
                Padding(padding: EdgeInsets.only(top: 50)),
                Text(
                  "Для использования приложения необходимо подключение к Интернет. Пожалуйста убедитесь что сеть доступна",
                  textAlign: TextAlign.center,
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                simpleButton(context, "Назад", () {
                  Navigator.pop(context);
                  IsConnect.initConnectivity(context);
                })
              ],
            ),
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
            padding: EdgeInsets.symmetric(horizontal: 30),
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.7,
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
}
