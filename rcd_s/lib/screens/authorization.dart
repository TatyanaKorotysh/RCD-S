import 'package:flutter/material.dart';
import 'package:rcd_s/domain/currentUser.dart';
import 'package:rcd_s/services/auth.dart';
import 'activateProfile.dart';

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

  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _input("E-mail", _emailController, false),
            _input("Пароль", _passwordController, true),
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

  Widget _input(String lable, TextEditingController controller, bool hide) {
    return Container(
      child: TextFormField(
        decoration: new InputDecoration(labelText: lable),
        controller: controller,
        obscureText: hide,
        validator: (value) => (value.isEmpty) ? 'Поле пустое' : null,
      ),
      width: MediaQuery.of(context).size.width * 0.8,
      padding: EdgeInsets.only(bottom: 20.0),
    );
  }

  void submit() async {
    if (_formKey.currentState.validate()) {
      _email = _emailController.text;
      _password = _passwordController.text;

      print(_email);
      print(_password);

      if (_email.isEmpty || _password.isEmpty) return null;

      CurrentUser user =
          await _authService.singIn(_email.trim(), _password.trim());
      if (user == null) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Неверный логин и пароль')));
        print('данные неверны');
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ActivateProfile();
        }));
      }

      _emailController.clear();
      _passwordController.clear();
    }
  }
}
