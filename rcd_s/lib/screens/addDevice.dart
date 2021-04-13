import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rcd_s/components/input.dart';
import 'package:rcd_s/services/translate.dart';

class AddDevice extends StatefulWidget {
  AddDevice({Key key}) : super(key: key);

  @override
  _AddDeviceState createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        //возможен scroll
        child: Center(
          child: Text(AppLocalizations.of(context).translate('devicesSearch')),
        ),
      ),
    );
  }

  Widget _form() {
    final _sizeTextWhite = const TextStyle(fontSize: 20.0, color: Colors.white);
    IconData _iconValue;
    final Map<String, IconData> _data = Map.fromIterables(
        ['First', 'Second', 'Third'],
        [Icons.filter_1, Icons.filter_2, Icons.filter_3]);

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                input("id устройтва", TextInputType.number, _emailController,
                    false),
                input("Имя устройства", TextInputType.name, _emailController,
                    false),
                input("Комната", TextInputType.name, _emailController, false),
                TextFormField(
                  decoration: new InputDecoration(labelText: "Комментарий"),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: _emailController,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                Row(
                  children: <Widget>[
                    Text('Иконка'),
                    DropdownButton<String>(
                      iconSize: 28,
                      elevation: 16,
                      style: TextStyle(color: Colors.indigo),
                      underline: Container(
                        height: 2,
                        color: Colors.indigo,
                      ),
                      hint: Container(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Icon(
                          _iconValue ?? _data.values.toList()[0],
                        ),
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          _iconValue = _data[newValue];
                        });
                      },
                      items: _data.keys.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Container(
                            child: Icon(
                              _data[value],
                              size: 36.0,
                            ),
                          ),
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
                    onPressed: add,
                    child: Text('Добавить', style: _sizeTextWhite),
                    color: Theme.of(context).accentColor,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  void cancel() {}

  void add() {}
}
