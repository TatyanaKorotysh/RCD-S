import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rcd_s/components/choiceAlert.dart';
import 'package:rcd_s/components/menu.dart';
import 'package:rcd_s/components/simpleAlert.dart';
import 'package:rcd_s/devices/command_manager.dart';
import 'package:rcd_s/models/device.dart';
import 'package:rcd_s/screens/deviceDetail.dart';
import 'package:rcd_s/services/globals.dart' as globals;
import 'package:rcd_s/services/isConnect.dart';
import 'package:rcd_s/services/translate.dart';
import 'package:rcd_s/storage/local_storage.dart';
import 'addDevice.dart';

class Devices extends StatefulWidget {
  Devices({Key key}) : super(key: key);

  @override
  _DevicesState createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  CommandManager commandManager;
  StreamSubscription subscription;
  DeviceLocalStorage _deviceLocalStorage;
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

  @override
  Widget build(BuildContext context) {
    IsConnect.initConnectivity(context);

    commandManager = Provider.of<CommandManager>(context);
    //commandManager.sendReadDeviceCommand();
    _deviceLocalStorage = Provider.of<DeviceLocalStorage>(context);
    _deviceLocalStorage.getAllDeviceList();

    subscription = commandManager.errorStream.listen((event) {
      //simpleAlert(event[0].toString(), event[1].toString(), context);
      simpleAlert(AppLocalizations.of(context).translate(event[0].toString()),
          AppLocalizations.of(context).translate(event[1].toString()), context);
      subscription.cancel();
    });

    return _body();
  }

  Widget _body() {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('devices')),
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
        //onPressed: (globals.isAdmin) ? _addDevice(commandManager) : null,
        onPressed: (globals.isAdmin) ? _addDevice : null,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _list() {
    return StreamBuilder(
      stream: _deviceLocalStorage.deviceListStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0)
            return Center(
                child: Text(
              "Список пуст",
              style: TextStyle(fontSize: 16),
            ));
          else
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
                                    SvgPicture.asset(
                                      (snapshot.data[index].type == 1 ||
                                              snapshot.data[index].type == 4)
                                          ? 'assets/SVG/8113.svg'
                                          : (snapshot.data[index].type == 6)
                                              ? 'assets/SVG/8112.svg'
                                              : 'assets/SVG/8117.svg',
                                      //'assets/SVG/devices.svg',
                                      color: Color.fromARGB(255, 56, 140, 203),
                                      height: 50,
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(right: 10)),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data[index].id.toString(),
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  128, 128, 128, 128),
                                              fontSize: 16),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(top: 5)),
                                        Text(
                                          (snapshot.data[index].type == 1 ||
                                                  snapshot.data[index].type ==
                                                      4)
                                              ? 'Ролета'
                                              : (snapshot.data[index].type == 6)
                                                  ? 'Напряжение'
                                                  : 'Шлагбаум',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  128, 128, 128, 128),
                                              fontSize: 16),
                                        ),
                                      ],
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
                                (globals.isAdmin)
                                    ? _deleteDevice(snapshot.data[index])
                                    : null;
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
                          Navigator.of(context).push(_createRoute(
                              snapshot.data[index], commandManager));
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                  ],
                );
              },
            );
        } else
          _deviceLocalStorage.getAllDeviceList();
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

  //_addDevice(CommandManager commandManager) {
  _addDevice() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddDevice(commandManager);
    }));
  }

  void _deleteDevice(Device currentDevice) {
    choiceAlert(
        AppLocalizations.of(context).translate('deviceDelete'),
        AppLocalizations.of(context).translate('deviceDeleteNote'),
        AppLocalizations.of(context).translate('delete'), () {
      commandManager.sendDeleteCommand(currentDevice, false);
    }, context);
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
