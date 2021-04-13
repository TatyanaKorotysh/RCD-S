import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcd_s/components/simpleButton.dart';
import 'package:rcd_s/screens/createAdmin.dart';
import 'package:rcd_s/screens/loading.dart';
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              AppLocalizations.of(context).translate('appLang'),
              style: TextStyle(fontSize: 32),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  onPressed: () {
                    appLanguage.changeLanguage(Locale("en"));
                  },
                  child: Text('English'),
                ),
                MaterialButton(
                  onPressed: () {
                    appLanguage.changeLanguage(Locale("ru"));
                  },
                  child: Text('Русский'),
                )
              ],
            ),
            simpleButton(
                context, AppLocalizations.of(context).translate('next'), () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CreateAdmin();
              }));
            })
          ],
        ),
      ),
    );
  }
}
