import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rcd_s/components/input.dart';
import 'package:rcd_s/models/userModel.dart';
import 'package:rcd_s/screens/users.dart';
import 'package:rcd_s/services/json.dart';
import 'package:rcd_s/services/translate.dart';
import 'package:toast/toast.dart';

class AddUser extends StatefulWidget {
  AddUser({Key key}) : super(key: key);

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _repeatPasswordController = TextEditingController();
  bool isSwitched = false;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            cancel();
          },
        ),
        title: Text(AppLocalizations.of(context).translate('newUser')),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: _form(),
        ),
      ),
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          input(AppLocalizations.of(context).translate('login'),
              TextInputType.name, _loginController, false),
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
                    onPressed: cancel,
                    child:
                        Text(AppLocalizations.of(context).translate('cancel')),
                    color: Theme.of(context).accentColor,
                  ),
                  MaterialButton(
                    minWidth: MediaQuery.of(context).size.width * 0.3,
                    onPressed: add,
                    child: Text(AppLocalizations.of(context).translate('add')),
                    color: Theme.of(context).accentColor,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  void cancel() {
    Navigator.pop(context);
  }

  void add() {
    if (_passwordController.text.trim() ==
        _repeatPasswordController.text.trim()) {
      JsonService.createUser(UserModel(_loginController.text.trim(),
                  _passwordController.text.trim(), isSwitched)
              .toJson())
          .then((bool res) => (res)
              ? {
                  Toast.show(
                      AppLocalizations.of(context).translate('userCreate'),
                      context,
                      duration: Toast.LENGTH_LONG),
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Users();
                  }))
                }
              : Toast.show(
                  AppLocalizations.of(context).translate('userAlreadyExist'),
                  context,
                  duration: Toast.LENGTH_LONG));
    } else {
      Toast.show(
          AppLocalizations.of(context).translate('repeatPassworError'), context,
          duration: Toast.LENGTH_LONG);
    }
  }
}
