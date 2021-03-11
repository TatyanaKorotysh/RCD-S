import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcd_s/components/menu.dart';
import 'package:rcd_s/domain/currentUser.dart';
import 'activateProfile.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: _info(),
        ),
      ),
      drawer: Menu('Профиль', context),
    );
  }

  Widget _info() {
    final _sizeTextWhite = const TextStyle(fontSize: 20.0, color: Colors.white);

    final CurrentUser user = Provider.of<CurrentUser>(context);
    String _email = user.email;

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
                child: Text('Логин: $_email'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Пароль: $_email'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Номер телефона: $_email'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('E-mail: $_email'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Тип планеровки: $_email'),
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
      return ActivateProfile();
    }));
  }
}
