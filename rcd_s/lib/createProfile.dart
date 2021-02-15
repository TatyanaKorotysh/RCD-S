import 'package:flutter/material.dart';
import 'package:rcd_s/devices.dart';

class CreateProfile extends StatefulWidget {
  CreateProfile({Key key}) : super(key: key);

  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Активация аккаунта'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: _form(context),
        ),
      ),
    );
  }

  Widget _form(BuildContext context) {
    final _sizeTextWhite = const TextStyle(fontSize: 20.0, color: Colors.white);
    String _dataValue = '1';

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: [
                TextFormField(
                  decoration: new InputDecoration(labelText: 'Логин'),
                  keyboardType: TextInputType.name,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                TextFormField(
                  decoration: new InputDecoration(labelText: 'Пароль'),
                  keyboardType: TextInputType.visiblePassword,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                TextFormField(
                  decoration:
                      new InputDecoration(labelText: 'Подтверждение пароля'),
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                TextFormField(
                  decoration: new InputDecoration(labelText: 'Номер телефона'),
                  keyboardType: TextInputType.phone,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                TextFormField(
                  decoration: new InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                Row(
                  children: <Widget>[
                    Text('Тип планировки'),
                    DropdownButton<String>(
                      value: _dataValue,
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.indigo),
                      underline: Container(
                        height: 2.0,
                        color: Colors.indigo,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          _dataValue = newValue;
                        });
                      },
                      items: <String>['1', '2', '3']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                )
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

  void save() {
    //добавить условие проверки:
    //если в первый раз, то открываем устройсва
    //если нет, то профиль
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Devices();
    }));
  }
}
