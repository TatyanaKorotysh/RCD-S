import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcd_s/components/menu.dart';
import 'package:rcd_s/models/preferencesModel.dart';
import 'package:rcd_s/screens/addUser.dart';
import 'package:rcd_s/screens/userDetail.dart';
import 'package:rcd_s/services/json.dart';
import 'package:rcd_s/services/globals.dart' as globals;
import 'package:rcd_s/services/theme.dart';
import 'package:rcd_s/services/translate.dart';

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
      body: Center(
        child: Form(
          child: Column(
            children: <Widget>[
              Text(AppLocalizations.of(context).translate('lang')),
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
              ),
              Text(AppLocalizations.of(context).translate('theme')),
              DropdownButtonFormField<String>(
                items: themeList,
                value: AppLocalizations.of(context).translate("light"),
                onChanged: (String val) {
                  if (val == AppLocalizations.of(context).translate('dark')) {
                    _themeChanger.setTheme(ThemeData.dark());
                    setState(() => _themeValue = "dark");
                  } else {
                    _themeChanger.setTheme(ThemeData.light());
                    setState(() => _themeValue = "light");
                  }
                  print("onCchange:");
                  print(_themeValue);
                },
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
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
                      ),
                    ],
                  )),
            ],
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
    print("apply:");
    print(_langValue);
    print(_themeValue);
    if (_langValue != null) globals.lang = _langValue;
    if (_themeValue != null) globals.theme = _themeValue;

    JsonService.applyPreferences(
        PreferencesModel(globals.login, globals.lang, globals.theme).toJson());
  }
}
