import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rcd_s/components/choiceAlert.dart';
import 'package:rcd_s/components/input.dart';
import 'package:rcd_s/models/userModel.dart';
import 'package:rcd_s/screens/users.dart';
import 'package:rcd_s/services/json.dart';
import 'package:rcd_s/services/translate.dart';
import 'package:toast/toast.dart';
import 'package:rcd_s/services/globals.dart' as globals;

class DeviceDetail extends StatefulWidget {
  @override
  _DeviceDetailState createState() => _DeviceDetailState();
}

class _DeviceDetailState extends State<DeviceDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Device"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.create_rounded),
            tooltip: AppLocalizations.of(context).translate('rename'),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: AppLocalizations.of(context).translate('settings'),
            onPressed: () {},
          ),
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Center();
  }
}
