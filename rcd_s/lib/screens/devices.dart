import 'package:flutter/material.dart';
import 'package:rcd_s/components/menu.dart';
import 'package:rcd_s/screens/deviceDetail.dart';
import 'package:rcd_s/services/translate.dart';
import 'addDevice.dart';

class Devices extends StatefulWidget {
  Devices({Key key}) : super(key: key);

  @override
  _DevicesState createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  // ignore: top_level_function_literal_block
  var sortList = <String>["one", "two", "three"].map((String value) {
    return new DropdownMenuItem<String>(
      value: value,
      child: new Text(value),
    );
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Устройства'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 60.0,
              width: MediaQuery.of(context).size.width,
              //child: _filter(),
            ),
            Expanded(
              child: _list(),
            ),
          ],
        ),
      ),
      drawer: Menu(AppLocalizations.of(context).translate('devices'), context),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDevice,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _filter() {
    String _sortValue = 'one';
    String _groupValue = 'one';

    return Row(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Сортировать по "),
            items: sortList,
            value: _sortValue,
            onChanged: (String val) => setState(() => _sortValue = val),
          ),
        ),
        Expanded(
          flex: 5,
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Группировать по "),
            items: sortList,
            value: _groupValue,
            onChanged: (String val) => setState(() => _groupValue = val),
          ),
        )
      ],
    );
  }

  Widget _list() {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.devices_rounded),
          title: Text('Device'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return DeviceDetail();
            }));
          },
        ),
      ],
    );
  }

  void _addDevice() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddDevice();
    }));
  }
}
