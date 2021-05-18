import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rcd_s/components/menu.dart';
import 'package:rcd_s/devices/command_manager.dart';
import 'package:rcd_s/models/device.dart';
import 'package:rcd_s/screens/deviceDetail.dart';
import 'package:rcd_s/services/globals.dart' as globals;
import 'package:rcd_s/services/isConnect.dart';
import 'package:rcd_s/services/translate.dart';
import 'addDevice.dart';

class Devices extends StatefulWidget {
  Devices({Key key}) : super(key: key);

  @override
  _DevicesState createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  CommandManager commandManager;
  //CommandManagerChanger commandManagerChanger;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //subscription.cancel();
    super.dispose();
  }

  // ignore: top_level_function_literal_block
  var sortList = <String>["one", "two", "three"].map((String value) {
    return new DropdownMenuItem<String>(
      value: value,
      child: new Text(value),
    );
  }).toList();

  @override
  Widget build(BuildContext context) {
    IsConnect.initConnectivity(context);

    commandManager = Provider.of<CommandManager>(context);
    commandManager.sendReadDeviceCommand();
    return _body();
  }

  Widget _body() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Устройства'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              //height: 60.0,
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
        backgroundColor: (globals.isAdmin)
            ? Theme.of(context).accentColor
            : Color.fromARGB(255, 170, 170, 170),
        onPressed: (globals.isAdmin) ? _addDevice : null,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _filter() {
    String _sortValue = 'one';
    String _groupValue = 'one';

    return Row(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 10)),
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
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
      ],
    );
  }

  Widget _list() {
    return StreamBuilder(
      stream: commandManager.deviceListStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: new BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromARGB(40, 56, 140, 203),
                            spreadRadius: 0.5,
                            blurRadius: 0.5,
                            offset: Offset(1, 1)),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment(0, 0),
                        end: Alignment(-5, -10),
                        colors: [
                          Theme.of(context).scaffoldBackgroundColor,
                          Color.fromARGB(255, 200, 200, 200),
                        ],
                      ),
                    ),
                    child: InkWell(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  /*Icon(
                                    Icons.device_unknown_rounded,
                                    color: Color.fromARGB(255, 56, 140, 203),
                                    size: 40,
                                  ),*/
                                  SvgPicture.asset(
                                    (snapshot.data[index].type == 1)
                                        ? 'assets/SVG/8113.svg'
                                        : (snapshot.data[index].type == 2)
                                            ? 'assets/SVG/8112.svg'
                                            : 'assets/SVG/8117.svg',
                                    //'assets/SVG/devices.svg',
                                    color: Color.fromARGB(255, 56, 140, 203),
                                    width: 50,
                                  ),
                                  Padding(padding: EdgeInsets.only(right: 10)),
                                  Text(
                                    snapshot.data[index].id.toString(),
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(128, 128, 128, 128),
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(top: 20)),
                              Text(
                                snapshot.data[index].name,
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              (globals.isAdmin) ? null : null;
                            },
                            padding: EdgeInsets.only(bottom: 60),
                            color: (globals.isAdmin)
                                ? Color.fromARGB(150, 56, 140, 203)
                                : Color.fromARGB(50, 128, 128, 128),
                          ),
                        ],
                      ),
                      splashColor: Color.fromARGB(255, 56, 140, 203),
                      onTap: () {
                        Navigator.of(context).push(
                            _createRoute(snapshot.data[index], commandManager));
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                ],
              );
            },
          );
        } else
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("assets/img/preloader.gif"),
                width: MediaQuery.of(context).size.width * 0.3,
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 20)),
              Text(AppLocalizations.of(context).translate('loadingData')),
            ],
          );
      },
    );
  }

  void _addDevice() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddDevice();
    }));
  }
}

Route _createRoute(Device currentDevice, CommandManager curManager) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        DeviceDetail(currentDevice, curManager),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
