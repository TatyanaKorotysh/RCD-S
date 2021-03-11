import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcd_s/domain/currentUser.dart';
import 'devices.dart';
import 'package:rcd_s/components/input.dart';

class ActivateProfile extends StatefulWidget {
  ActivateProfile({Key key}) : super(key: key);

  @override
  _ActivateProfileState createState() => _ActivateProfileState();
}

class _ActivateProfileState extends State<ActivateProfile> {
  final _formKey = GlobalKey<FormState>();

  var homeType = <String>["Однокомнатная", "Двухкомнатная", "Трехкомнатная"]
      // ignore: top_level_function_literal_block
      .map((String value) {
    return new DropdownMenuItem<String>(
      value: value,
      child: new Text(value),
    );
  }).toList();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _repeatPasswordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  String _name;
  String _password;
  String _repeatePassword;
  String _email;

  @override
  Widget build(BuildContext context) {
    final CurrentUser user = Provider.of<CurrentUser>(context);

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
    String _dataValue = 'Однокомнатная';

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: [
                input("Имя", TextInputType.name, _nameController, 10.0, false),
                input("Пароль", TextInputType.text, _passwordController, 10.0,
                    true),
                input("Подтверждение пароля", TextInputType.text,
                    _repeatPasswordController, 10.0, true),
                input("Номер телефона", TextInputType.phone, _emailController,
                    10.0, false),
                input("E-mail", TextInputType.emailAddress, _emailController,
                    10.0, false),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: DropdownButtonFormField<String>(
                        decoration:
                            const InputDecoration(labelText: "Тип планеровки"),
                        items: homeType,
                        value: _dataValue,
                        onChanged: (String val) =>
                            setState(() => _dataValue = val),
                      ),
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

  void save() async {
    if (_formKey.currentState.validate()) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Devices();
      }));
    }

    //await DatabaseService().addOrUpateUser(user);
  }
}
