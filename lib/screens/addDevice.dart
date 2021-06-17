import 'dart:async';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rcd_s/components/input.dart';
import 'package:rcd_s/components/simpleAlert.dart';
import 'package:rcd_s/devices/command_manager.dart';
import 'package:rcd_s/models/device.dart';
import 'package:rcd_s/services/isConnect.dart';
import 'package:rcd_s/services/translate.dart';
import 'package:rcd_s/storage/local_storage.dart';

class AddDevice extends StatefulWidget {
  //AddDevice({Key key}) : super(key: key);

  static CommandManager commandManager;

  AddDevice(CommandManager cur) {
    commandManager = cur;
  }

  @override
  _AddDeviceState createState() => _AddDeviceState(commandManager);
}

class _AddDeviceState extends State<AddDevice> {
  static CommandManager commandManager;
  _AddDeviceState(CommandManager cur) {
    commandManager = cur;
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  StreamSubscription subscription;
  Widget search;
  bool isExist = false;

  DeviceLocalStorage _deviceLocalStorage;
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    _nameController = TextEditingController(text: "");
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    IsConnect.initConnectivity(context);
    commandManager.sendAddDeviceCommand();

    _deviceLocalStorage = Provider.of<DeviceLocalStorage>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(top: 10)),
            Container(
              child: Text(
                "Обраруженые устройства:",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            Expanded(
              child: _list(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _list() {
    timer();
    return StreamBuilder(
        stream: commandManager.deviceListStream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            isExist = true;
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                _nameController =
                    TextEditingController(text: snapshot.data[index].name);
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
                                  //snapshot.data[index].name,
                                  _nameController.text,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                renameDevice(snapshot.data[index]);
                              },
                              padding: EdgeInsets.only(bottom: 60),
                              color: Color.fromARGB(150, 56, 140, 203),
                            ),
                          ],
                        ),
                        splashColor: Color.fromARGB(255, 56, 140, 203),
                        onTap: () {
                          //Navigator.of(context).push(
                          //    _createRoute(snapshot.data[index], commandManager));
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
                Text(AppLocalizations.of(context).translate('devicesSearch')),
              ],
            );
        });
  }

  void timer() {
    Timer(Duration(seconds: 30), () {
      if (!isExist) {
        Navigator.of(context).pop();
        simpleAlert("Не удалось обнаружить устройтва",
            "Убедитесь что устройства находяться в режиме поиска", context);
      }
    });
  }

  renameDevice(Device device) {
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
                  device.name = _nameController.value.text;
                  await _deviceLocalStorage.updateDevice(device);
                  Navigator.of(context).pop();
                  setState(() {
                    _nameController = TextEditingController(text: device.name);
                  });
                  //function();
                },
              ),
            ],
          );
        });
  }
}
