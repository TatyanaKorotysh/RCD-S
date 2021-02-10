import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'menu.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: _form(),
        ),
      ),
      drawer: Menu('Профиль', context),
    );
  }

  Widget _form() {
    final _sizeTextWhite = const TextStyle(fontSize: 20.0, color: Colors.white);

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: [
                TextFormField(
                  decoration: new InputDecoration(labelText: 'Логин'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                TextFormField(
                  decoration: new InputDecoration(labelText: 'Пароль'),
                  obscureText: true,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  minWidth: MediaQuery.of(context).size.width * 0.3,
                  onPressed: cancel,
                  child: Text('Отмена', style: _sizeTextWhite),
                  color: Theme.of(context).accentColor,
                ),
                MaterialButton(
                  minWidth: MediaQuery.of(context).size.width * 0.3,
                  onPressed: save,
                  child: Text('Сохранить', style: _sizeTextWhite),
                  color: Theme.of(context).accentColor,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void cancel() {}

  void save() {}
}
