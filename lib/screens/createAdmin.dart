import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rcd_s/components/input.dart';
import 'package:rcd_s/components/simpleButton.dart';
import 'package:rcd_s/models/userModel.dart';
import 'package:rcd_s/screens/wifiConnect.dart';
import 'package:rcd_s/services/json.dart';

class CreateAdmin extends StatefulWidget {
  const CreateAdmin({Key key}) : super(key: key);

  @override
  _CreateAdminState createState() => _CreateAdminState();
}

class _CreateAdminState extends State<CreateAdmin> {
  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              input("Логин", TextInputType.name, _loginController, false),
              input("Пароль", TextInputType.name, _passwordController, true),
              Padding(padding: EdgeInsets.all(20.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  simpleButton(context, "Назад", cancel),
                  Padding(padding: EdgeInsets.all(20.0)),
                  simpleButton(context, "Создать", create),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void cancel() {
    Navigator.pop(context);
  }

  void create() {
    UserModel admin =
        UserModel(_loginController.text, _passwordController.text, true);
    Map<String, dynamic> adminJson = admin.toJson();

    JsonService.createUser(adminJson);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WifiConnect()),
    );
  }
}
