import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rcd_s/components/input.dart';
import 'package:rcd_s/components/simpleButton.dart';
import 'package:rcd_s/models/userModel.dart';
import 'package:rcd_s/screens/authorization.dart';
import 'package:rcd_s/services/json.dart';
import 'package:rcd_s/services/translate.dart';

class CreateAdmin extends StatefulWidget {
  const CreateAdmin({Key key}) : super(key: key);

  @override
  _CreateAdminState createState() => _CreateAdminState();
}

class _CreateAdminState extends State<CreateAdmin> {
  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.25)),
                  Text(
                    AppLocalizations.of(context).translate('createAdmin'),
                    style: TextStyle(fontSize: 28),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.1)),
                  input(AppLocalizations.of(context).translate('login'),
                      TextInputType.name, _loginController, false, context),
                  input(AppLocalizations.of(context).translate('password'),
                      TextInputType.name, _passwordController, true, context),
                  Padding(padding: EdgeInsets.all(20.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      simpleButton(
                          context,
                          AppLocalizations.of(context).translate('back'),
                          cancel),
                      Padding(padding: EdgeInsets.all(20.0)),
                      simpleButton(
                          context,
                          AppLocalizations.of(context).translate('create'),
                          create),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                ],
              ),
            ),
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
          ),
        ),
      ),
    );
  }

  void cancel() {
    Navigator.pop(context);
  }

  void create() {
    UserModel admin = UserModel(
        _loginController.text.trim(), _passwordController.text.trim(), true);
    Map<String, dynamic> adminJson = admin.toJson();

    JsonService.createUser(adminJson);
    /*JsonService.applyPreferences(
        PreferencesModel(globals.login, globals.lang, globals.theme).toJson());*/

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Authorization()),
    );
  }
}
