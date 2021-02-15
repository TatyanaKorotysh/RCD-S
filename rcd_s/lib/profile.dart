import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rcd_s/createProfile.dart';
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

    return Column(
      children: <Widget>[
        Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Логин: '),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Пароль: '),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Номер телефона: '),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('E-mail: '),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Тип планеровки: '),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      minWidth: MediaQuery.of(context).size.width * 0.3,
                      onPressed: change,
                      child: Text('Изменить', style: _sizeTextWhite),
                      color: Theme.of(context).accentColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void change() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CreateProfile();
    }));
  }
}
