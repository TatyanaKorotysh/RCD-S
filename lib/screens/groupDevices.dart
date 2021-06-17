import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rcd_s/components/choiceAlert.dart';
import 'package:rcd_s/components/input.dart';
import 'package:rcd_s/components/simpleAlert.dart';
import 'package:rcd_s/devices/command_manager.dart';
import 'package:rcd_s/models/device.dart';
import 'package:rcd_s/models/group.dart';
import 'package:rcd_s/screens/deviceDetail.dart';
import 'package:rcd_s/services/globals.dart' as globals;
import 'package:rcd_s/services/isConnect.dart';
import 'package:rcd_s/services/translate.dart';
import 'package:rcd_s/storage/group_storage.dart';
import 'package:rcd_s/storage/local_storage.dart';
import 'addDevice.dart';

class GroupDevices extends StatefulWidget {
  static Group group;
  static CommandManager commandManager;

  GroupDevices(Group currentGroup, CommandManager curManager) {
    group = currentGroup;
    commandManager = curManager;
  }

  @override
  _GroupDevicesState createState() => _GroupDevicesState(group, commandManager);
}

class _GroupDevicesState extends State<GroupDevices> {
  static Group group;
  static CommandManager commandManager;
  StreamSubscription subscription;
  DeviceLocalStorage _deviceLocalStorage;
  GroupLocalStorage groupLocalStorage;
  Device deviceForAdd;
  List groupList;

  _GroupDevicesState(Group currentGroup, CommandManager curManager) {
    group = currentGroup;
    commandManager = curManager;
  }

  TextEditingController _nameController = TextEditingController();
  List addDevicesList;

  @override
  void initState() {
    _nameController = TextEditingController(text: group.name);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    //subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    IsConnect.initConnectivity(context);

    commandManager.sendReadDevicesFromGroupCommand(group);
    groupLocalStorage = Provider.of<GroupLocalStorage>(context);
    groupList = groupLocalStorage.getDevicesIds(group);

    subscription = commandManager.errorStream.listen((event) {
      //simpleAlert(event[0].toString(), event[1].toString(), context);
      simpleAlert(AppLocalizations.of(context).translate(event[0].toString()),
          AppLocalizations.of(context).translate(event[1].toString()), context);
      subscription.cancel();
    });

    //commandManager = Provider.of<CommandManager>(context);
    // commandManager.sendReadDeviceCommand();
    return _body();
  }

  Widget _body() {
    return Scaffold(
      appBar: AppBar(
        title: Text('${group.name}'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.create_rounded),
            tooltip: AppLocalizations.of(context).translate('rename'),
            onPressed: () {
              (globals.isAdmin) ? renameGroup(group) : null;
            },
            color: (globals.isAdmin) ? Colors.white : Colors.white30,
          ),
        ],
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: (globals.isAdmin)
            ? Theme.of(context).accentColor
            : Color.fromARGB(255, 170, 170, 170),
        onPressed: (globals.isAdmin) ? _addDevice : null,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _list() {
    return StreamBuilder(
      stream: groupLocalStorage.groupDeviceListStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          _deviceLocalStorage = Provider.of<DeviceLocalStorage>(context);
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
                Device device =
                    _deviceLocalStorage.getDeviceById(snapshot.data[index]);

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
                                      //(allDevice[snapshot.data[index] - 1].type ==
                                      (device.type == 1 || device.type == 4)
                                          ? 'assets/SVG/8113.svg'
                                          : (device.type == 6)
                                              ? 'assets/SVG/8112.svg'
                                              : 'assets/SVG/8117.svg',
                                      //'assets/SVG/devices.svg',
                                      color: Color.fromARGB(255, 56, 140, 203),
                                      width: 50,
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(right: 10)),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          device.id.toString(),
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  128, 128, 128, 128),
                                              fontSize: 16),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(top: 5)),
                                        Text(
                                          (device.type == 1 || device.type == 4)
                                              ? 'Ролета'
                                              : (device.type == 6)
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
                                  device.name,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                (globals.isAdmin) ? deleteDevice(device) : null;
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
                          Navigator.of(context)
                              .push(_createRoute(device, commandManager));
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                  ],
                );
              },
            );
        } else
          groupLocalStorage.getDevicesIds(group);
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

  _addDevice() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          groupList = groupLocalStorage.getDevicesIds(group);
          List devices = _deviceLocalStorage.getAllDeviceList();
          groupList.forEach((dev) {
            devices.removeWhere((element) => element.id == dev);
          });
          var list = devices.map((dynamic value) {
            return new DropdownMenuItem<dynamic>(
              value: value.id,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value.name),
                  //Text(value.id.toString()),
                  //Padding(padding: EdgeInsets.only(top: 10)),
                ],
              ),
            );
          }).toList();
          return AlertDialog(
            content: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                children: [
                  Text("Выберите устройство для добавления в группу"),
                  Padding(padding: EdgeInsets.only(top: 30)),
                  DropdownButtonFormField<dynamic>(
                    items: list,
                    onChanged: (dynamic value) {
                      if (value != String)
                        setState(() {
                          deviceForAdd =
                              _deviceLocalStorage.getDeviceById(value);
                          print(deviceForAdd);
                        });
                    },
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    style: const TextStyle(
                      color: Color.fromARGB(255, 56, 140, 203),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Выберите устройство',
                      hintMaxLines: 5,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Отмена'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Добавить'),
                onPressed: () async {
                  //await _deviceLocalStorage.updateDevice(device);
                  await commandManager.sendAddDeviceToGroupCommand(
                      group, deviceForAdd);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void deleteDevice(Device currentDevice) {
    choiceAlert(
        AppLocalizations.of(context).translate('deviceDelete'),
        AppLocalizations.of(context).translate('deviceFromGroupDeleteNote'),
        AppLocalizations.of(context).translate('delete'), () {
      commandManager.sendDeleteDeviceFromGroupCommand(
          group, currentDevice, false);
      //commandManager.sendDeleteCommand(currentDevice, true);
    }, context);
  }

  renameGroup(Group group) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: input("Название", TextInputType.name, _nameController,
                false, context),
            actions: <Widget>[
              TextButton(
                child: Text('Отмена'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Переименовать'),
                onPressed: () async {
                  group.name = _nameController.value.text;
                  //await _deviceLocalStorage.updateDevice(device);
                  await groupLocalStorage.updateGroup(group);
                  Navigator.of(context).pop();
                  //function();
                },
              ),
            ],
          );
        });
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
