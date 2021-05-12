import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcd_s/components/menu.dart';
import 'package:rcd_s/components/simpleButton.dart';
import 'package:rcd_s/models/preferencesModel.dart';
import 'package:rcd_s/services/json.dart';
import 'package:rcd_s/services/globals.dart' as globals;
import 'package:rcd_s/services/theme.dart';
import 'package:rcd_s/services/translate.dart';
import 'package:toast/toast.dart';

class Preferences extends StatefulWidget {
  Preferences({Key key}) : super(key: key);

  @override
  _PreferencesState createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  String _langValue;
  String _themeValue;
  ThemeChanger _themeChanger;
  var appLanguage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _themeChanger = Provider.of<ThemeChanger>(context);
    appLanguage = Provider.of<AppLanguage>(context);

    //_langValue = globals.lang;
    var langList = <String>["Русский", "English"].map((String value) {
      return new DropdownMenuItem<String>(
        value: value,
        child: new Text(value),
      );
    }).toList();

    //_themeValue = AppLocalizations.of(context).translate(globals.theme);
    // _themeValue = AppLocalizations.of(context).translate("light");
    var themeList = <String>[
      AppLocalizations.of(context).translate('light'),
      AppLocalizations.of(context).translate('dark')
    ].map((String value) {
      return new DropdownMenuItem<String>(
        value: value,
        child: new Text(value),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('settings')),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 20)),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate('lang'),
                        style: TextStyle(fontSize: 16),
                      ),
                      DropdownButtonFormField<String>(
                        items: langList,
                        value: globals.lang,
                        onChanged: (String val) {
                          setState(() => _langValue = val);
                          if (_langValue == "Русский")
                            appLanguage.changeLanguage(Locale("ru"));
                          else
                            appLanguage.changeLanguage(Locale("en"));
                        },
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        style: const TextStyle(
                          color: Color.fromARGB(255, 56, 140, 203),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 40)),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate('theme'),
                        style: TextStyle(fontSize: 16),
                      ),
                      DropdownButtonFormField<String>(
                        items: themeList,
                        value: (globals.theme == "light")
                            ? AppLocalizations.of(context).translate("light")
                            : AppLocalizations.of(context).translate("dark"),
                        onChanged: (String val) {
                          if (val ==
                              AppLocalizations.of(context).translate('dark')) {
                            _themeChanger.setTheme(ThemeData(
                                brightness: Brightness.dark,
                                primaryColor: Color.fromARGB(255, 56, 140, 203),
                                accentColor: Color.fromARGB(255, 56, 140, 203),
                                fontFamily: 'Raleway'));
                            setState(() => _themeValue = "dark");
                          } else {
                            _themeChanger.setTheme(ThemeData(
                                brightness: Brightness.light,
                                primaryColor: Color.fromARGB(255, 56, 140, 203),
                                accentColor: Color.fromARGB(255, 56, 140, 203),
                                fontFamily: 'Raleway'));
                            setState(() => _themeValue = "light");
                          }
                          print("onCchange:");
                          print(_themeValue);
                        },
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        style: const TextStyle(
                          color: Color.fromARGB(255, 56, 140, 203),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      simpleButton(context,
                          AppLocalizations.of(context).translate('cancel'), () {
                        cancel();
                      }),
                      simpleButton(context,
                          AppLocalizations.of(context).translate('save'), () {
                        apply();
                      }),
                      /*MaterialButton(
                        minWidth: MediaQuery.of(context).size.width * 0.3,
                        onPressed: cancel,
                        child: Text(
                            AppLocalizations.of(context).translate('cancel')),
                        color: Theme.of(context).accentColor,
                        //disabledColor: Colors.black12,
                      ),
                      MaterialButton(
                        minWidth: MediaQuery.of(context).size.width * 0.3,
                        onPressed: apply,
                        child: Text(
                            AppLocalizations.of(context).translate('save')),
                        color: Theme.of(context).accentColor,
                      ),*/
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: Menu(AppLocalizations.of(context).translate('settings'), context),
    );
  }

  void cancel() {
    Navigator.pop(context);
  }

  void apply() {
    if (_langValue != null) globals.lang = _langValue;
    if (_themeValue != null) globals.theme = _themeValue;

    JsonService.applyPreferences(
            PreferencesModel(globals.login, globals.lang, globals.theme)
                .toJson())
        .then((value) {
      if (value) {
        Toast.show(
          "Настроки успешно сохранены",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          backgroundColor: Color(0xFF2E7D32),
        );
      }
    });
  }
}
