import 'package:flutter/material.dart';
import 'package:rcd_s/components/input.dart';
import 'package:rcd_s/screens/devices.dart';
import 'package:rcd_s/services/json.dart';
import 'package:toast/toast.dart';

class Authorization extends StatefulWidget {
  @override
  AuthorizationState createState() {
    return AuthorizationState();
  }
}

class AuthorizationState extends State<Authorization> {
  final _formKey = GlobalKey<FormState>();
  final _sizeTextWhite = const TextStyle(fontSize: 20.0, color: Colors.white);

  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            input("Логин", TextInputType.name, _loginController, false),
            input("Пароль", TextInputType.text, _passwordController, true),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: MaterialButton(
                onPressed: submit,
                child: Text('ВОЙТИ', style: _sizeTextWhite),
                color: Theme.of(context).accentColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  void submit() {
    Future<String> result =
        JsonService.checkUser(_loginController.text, _passwordController.text);

    print(result);
    result.then((String r) => {
          if (r == "true")
            {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Devices()),
              )
            }
          else
            {Toast.show(r, context, duration: Toast.LENGTH_LONG)}
        });

    _loginController.clear();
    _passwordController.clear();
  }
}
