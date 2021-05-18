import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rcd_s/components/input.dart';
import 'package:rcd_s/components/simpleButton.dart';
import 'package:rcd_s/connections/mqttConnect.dart';
//import 'package:rcd_s/connections/mqttAppState.dart';
import 'package:rcd_s/screens/devices.dart';
import 'package:rcd_s/services/isConnect.dart';
import 'package:rcd_s/services/json.dart';
import 'package:rcd_s/services/theme.dart';
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
  ThemeChanger _themeChanger;
  var appLanguage;

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
    IsConnect.initConnectivity(context);

    _themeChanger = Provider.of<ThemeChanger>(context);
    appLanguage = Provider.of<AppLanguage>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.2)),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: (globals.theme == "light")
                        ? Image(image: AssetImage("assets/img/logo.png"))
                        : Image(image: AssetImage("assets/img/logo_light.png")),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.1)),
                  input(AppLocalizations.of(context).translate('login'),
                      TextInputType.name, _loginController, false, context),
                  input(AppLocalizations.of(context).translate('password'),
                      TextInputType.text, _passwordController, true, context),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: MaterialButton(
                      child: Text(
                        AppLocalizations.of(context).translate('logIn'),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      splashColor: Color.fromARGB(255, 45, 47, 122),
                      minWidth: MediaQuery.of(context).size.width * 0.3,
                      elevation: 0,
                      highlightElevation: 0,
                      color: Theme.of(context).accentColor,
                      onPressed: submit,
                    ),
                  ),
                ],
              ),
            ),
            width: MediaQuery.of(context).size.width,
            decoration: new BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0, 0),
                end: Alignment(0, -3),
                colors: [
                  Theme.of(context).scaffoldBackgroundColor,
                  Color.fromARGB(255, 200, 200, 200),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void submit() async {
    Future<String> result = JsonService.checkUser(
        _loginController.text.trim(), _passwordController.text.trim(), context);

    result.then((String r) => {
          if (r == "true")
            {
              JsonService.readQr()
                  .then((value) => {MqttManager.initMqttConnect(value)}),
              JsonService.getPreferences().then(
                (pref) => {
                  globals.theme = pref[globals.login][1],
                  if (globals.theme == "light")
                    {
                      _themeChanger.setTheme(
                        ThemeData(
                            brightness: Brightness.light,
                            primaryColor: Color.fromARGB(255, 56, 140, 203),
                            accentColor: Color.fromARGB(255, 56, 140, 203),
                            fontFamily: 'Raleway'),
                      )
                    }
                  else
                    {
                      _themeChanger.setTheme(
                        ThemeData(
                            brightness: Brightness.dark,
                            primaryColor: Color.fromARGB(255, 56, 140, 203),
                            accentColor: Color.fromARGB(255, 56, 140, 203),
                            fontFamily: 'Raleway'),
                      )
                    },
                  globals.lang = pref[globals.login][0],
                  if (globals.lang == "Русский")
                    {appLanguage.changeLanguage(Locale("ru"))}
                  else
                    {appLanguage.changeLanguage(Locale("en"))},
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Devices()),
                  ),
                },
              ),
              /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Devices()),
              ),*/
            }
          else
            {
              Toast.show(
                r,
                context,
                duration: Toast.LENGTH_LONG,
                gravity: Toast.TOP,
                backgroundColor: Color(0xFFBF360C),
              ),
            }
        });

    //_loginController.clear();
    //_passwordController.clear();
  }
}
