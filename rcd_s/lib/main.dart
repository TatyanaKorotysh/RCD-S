import 'package:flutter/material.dart';
import 'devices.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'RCD-S',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          // используются все оттенки цвета (элементы гастраивать не надо)
          //primaryColor: Colors.indigo[900], //используется только дин цвет (каждый элемент настраивается отдельно)
          visualDensity: VisualDensity.adaptivePlatformDensity,
          // адаптивность
        ),
        home: Scaffold(body: Authorization()));
  }
}

class Authorization extends StatefulWidget {
  @override
  AuthorizationState createState() {
    return AuthorizationState();
  }
}

class AuthorizationState extends State<Authorization> {
  final _formKey = GlobalKey<FormState>();
  final _sizeTextBlack = const TextStyle(fontSize: 20.0, color: Colors.black);
  final _sizeTextWhite = const TextStyle(fontSize: 20.0, color: Colors.white);

  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          //размещать объекты максимально близко к центру
          children: <Widget>[
            Container(
              child: TextFormField(
                decoration: new InputDecoration(labelText: "Логин"),
                style: _sizeTextBlack,
                validator: (value) => (value.isEmpty) ? 'Поле пустое' : null,
              ),
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.only(bottom: 20.0),
            ),
            Container(
              child: TextFormField(
                decoration: new InputDecoration(labelText: "Пароль"),
                obscureText: true,
                style: _sizeTextBlack,
                validator: (value) => (value.isEmpty) ? 'Поле пустое' : null,
              ),
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.only(bottom: 20.0),
            ),
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
    if (_formKey.currentState.validate()) {
      /*Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Осуществляется вход...')));*/
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Devices();
      }));
    }
  }
}
