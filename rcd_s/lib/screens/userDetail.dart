import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rcd_s/components/choiceAlert.dart';
import 'package:rcd_s/components/input.dart';
import 'package:rcd_s/models/userModel.dart';
import 'package:rcd_s/screens/users.dart';
import 'package:rcd_s/services/json.dart';
import 'package:rcd_s/services/translate.dart';
import 'package:toast/toast.dart';
import 'package:rcd_s/services/globals.dart' as globals;

class UserDetail extends StatefulWidget {
  //UserDetail({Key key}) : super(key: key);
  static dynamic user;
  static String keys;

  UserDetail(dynamic currentUser, String currentKey) {
    user = currentUser;
    keys = currentKey;
  }

  @override
  _UserDetailState createState() => _UserDetailState(user, keys);
}

class _UserDetailState extends State<UserDetail> {
  final _formKey = GlobalKey<FormState>();
  static dynamic user;
  static String key;

  _UserDetailState(dynamic currentUser, String currentKey) {
    user = currentUser;
    key = currentKey;
  }

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _repeatPasswordController = TextEditingController();
  bool isSwitched;

  @override
  void initState() {
    super.initState();
    _passwordController.text = user[0];
    isSwitched = user[1];
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$key"),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            input(AppLocalizations.of(context).translate('password'),
                TextInputType.text, _passwordController, true),
            input(AppLocalizations.of(context).translate('repiatePassword'),
                TextInputType.text, _repeatPasswordController, true),
            Text(AppLocalizations.of(context).translate('userAccess')),
            Switch(
              value: isSwitched,
              onChanged: (value) {
                setState(() {
                  isSwitched = value;
                  value = !value;
                });
              },
              activeTrackColor: Theme.of(context).accentColor,
              activeColor: Theme.of(context).accentColor,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    minWidth: MediaQuery.of(context).size.width * 0.3,
                    onPressed: () {
                      (globals.isAdmin) ? delete() : null;
                    },
                    child:
                        Text(AppLocalizations.of(context).translate('delete')),
                    color: Theme.of(context).accentColor,
                    //disabledColor: Colors.black12,
                  ),
                  MaterialButton(
                    minWidth: MediaQuery.of(context).size.width * 0.3,
                    onPressed: change,
                    child:
                        Text(AppLocalizations.of(context).translate('change')),
                    color: Theme.of(context).accentColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void delete() {
    choiceAlert(
        AppLocalizations.of(context).translate('userDeleting'),
        AppLocalizations.of(context).translate('userDeletingNote'),
        AppLocalizations.of(context).translate('delete'), () {
      JsonService.deleteUser(key);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Users();
      }));
    }, context);
  }

  void change() {
    if (_passwordController.text.trim() ==
        _repeatPasswordController.text.trim()) {
      choiceAlert(
          AppLocalizations.of(context).translate('userChanign'),
          AppLocalizations.of(context).translate('userChanignNote'),
          AppLocalizations.of(context).translate('change'), () {
        JsonService.chacgeUser(key,
                UserModel(key, _passwordController.text, isSwitched).toJson())
            .then((bool res) => () {
                  res
                      ? Toast.show(
                          AppLocalizations.of(context).translate('userChange'),
                          context,
                          duration: Toast.LENGTH_LONG)
                      : Toast.show(
                          AppLocalizations.of(context)
                              .translate('userChangeError'),
                          context,
                          duration: Toast.LENGTH_LONG);
                });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Users()));
      }, context);
    } else {
      Toast.show(
          AppLocalizations.of(context).translate('repeatPassworError'), context,
          duration: Toast.LENGTH_LONG);
    }
  }
}
