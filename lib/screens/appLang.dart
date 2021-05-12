import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcd_s/components/simpleButton.dart';
import 'package:rcd_s/screens/createAdmin.dart';
import 'package:rcd_s/services/translate.dart';

class AppLang extends StatefulWidget {
  @override
  _AppLangState createState() => _AppLangState();
}

class _AppLangState extends State<AppLang> {
  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.2),
        child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate('appLang'),
                  style: TextStyle(fontSize: 28),
                ),
                Padding(padding: EdgeInsets.only(top: 40)),
                MaterialButton(
                  minWidth: MediaQuery.of(context).size.width * 0.8,
                  splashColor: Color.fromARGB(255, 56, 140, 203),
                  onPressed: () {
                    appLanguage.changeLanguage(Locale("en"));
                  },
                  child: Text('English'),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                MaterialButton(
                  minWidth: MediaQuery.of(context).size.width * 0.8,
                  splashColor: Color.fromARGB(200, 56, 140, 203),
                  onPressed: () {
                    appLanguage.changeLanguage(Locale("ru"));
                  },
                  child: Text('Русский'),
                ),
                Padding(padding: EdgeInsets.only(top: 50)),
                simpleButton(
                    context, AppLocalizations.of(context).translate('next'),
                    () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CreateAdmin();
                  }));
                })
              ],
            ),
            padding: EdgeInsets.symmetric(vertical: 50),
            width: MediaQuery.of(context).size.width * 0.9,
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
/*
decoration: new BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color.fromARGB(0, 255, 255, 255),
                    Color.fromARGB(255, 230, 230, 230),
                  ],
                ),
              ),
 */