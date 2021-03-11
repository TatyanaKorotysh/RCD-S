import 'package:flutter/material.dart';
import 'package:rcd_s/domain/currentUser.dart';
import 'package:rcd_s/services/auth.dart';
import 'activateProfile.dart';
import 'package:rcd_s/components/input.dart';

class Authorization extends StatefulWidget {
  @override
  AuthorizationState createState() {
    return AuthorizationState();
  }
}

class AuthorizationState extends State<Authorization> {
  final _formKey = GlobalKey<FormState>();
  final _sizeTextWhite = const TextStyle(fontSize: 20.0, color: Colors.white);

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _email;
  String _password;

  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            input("E-mail", TextInputType.emailAddress, _emailController, 10.0,
                false),
            input(
                "Пароль", TextInputType.text, _passwordController, 10.0, true),
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

  void submit() async {
    if (_formKey.currentState.validate()) {
      _email = _emailController.text;
      _password = _passwordController.text;

      if (_email.isEmpty || _password.isEmpty) return null;

      CurrentUser user =
          await _authService.singIn(_email.trim(), _password.trim());
      if (user == null) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Неверный логин и пароль')));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          //проверка на активацию профиля
          return ActivateProfile();
        }));
      }

      _emailController.clear();
      _passwordController.clear();
    }
  }
}
