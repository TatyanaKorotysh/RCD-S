import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcd_s/components/input.dart';
import 'package:rcd_s/devices/command_manager.dart';
import 'package:rcd_s/devices/commands.dart';
import 'package:rcd_s/models/device.dart';
import 'package:rcd_s/services/isConnect.dart';
import 'package:rcd_s/services/translate.dart';
import 'package:rcd_s/services/globals.dart' as globals;
import 'package:rcd_s/storage/local_storage.dart';

class DeviceDetail extends StatefulWidget {
  static Device device;
  static CommandManager commandManager;

  DeviceDetail(Device currentDevice, CommandManager curManager) {
    device = currentDevice;
    commandManager = curManager;
  }

  @override
  _DeviceDetailState createState() =>
      _DeviceDetailState(device, commandManager);
}

class _DeviceDetailState extends State<DeviceDetail> {
  static Device device;
  static CommandManager commandManager;
  double pos = null;
  double startPos = 0;
  double lefTime = 0;
  //int step = 0;
  MoveType currentMove = MoveType.stop;
  TurnType currentTurn = TurnType.off;
  //Timer currUpdateTimer;
  StreamSubscription subscription;
  DateTime startUpdateTime;
  Color btn_on = Color.fromARGB(255, 56, 140, 203);
  Color btn_off = Color.fromARGB(100, 56, 140, 203);
  bool oneChanel = true;
  int direction = 0;

  DeviceLocalStorage _deviceLocalStorage;
  TextEditingController _nameController = TextEditingController();

  _DeviceDetailState(Device currentDevice, CommandManager curManager) {
    device = currentDevice;
    commandManager = curManager;
  }

  @override
  void initState() {
    _nameController = TextEditingController(text: device.name);
    commandManager.loadCurrentState8113(device);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    IsConnect.initConnectivity(context);

    _deviceLocalStorage = Provider.of<DeviceLocalStorage>(context);

    subscription = commandManager.devConfig.listen((event) {
      setState(() {
        pos = event.curPosPercents.toDouble();
        startPos = event.curPosPercents.toDouble();
        lefTime = event.timeExe.toDouble();
        direction = event.direction;
        //step = (lefTime / pos).round() * 10;
      });
      if (currentMove == MoveType.stop) {
        stopMove();
      } else {
        move();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.create_rounded),
            tooltip: AppLocalizations.of(context).translate('rename'),
            onPressed: () {
              (globals.isAdmin) ? renameDevice(device) : null;
            },
            color: (globals.isAdmin) ? Colors.white : Colors.white30,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: AppLocalizations.of(context).translate('settings'),
            onPressed: () {
              (globals.isAdmin) ? null : null;
            },
            color: (globals.isAdmin) ? Colors.white : Colors.white30,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: (device.type == 1 || device.type == 4)
            ? _8113()
            : (device.type == 6)
                ? _8112()
                : (device.type == 2)
                    ? _8117(context)
                    : Center(
                        child: Text(AppLocalizations.of(context)
                            .translate('readDeviceError')),
                      ),
      ),
    );
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
                  //function();
                },
              ),
            ],
          );
        });
  }

  Widget _8113() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.width * 0.7,
            decoration: new BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius:
                  BorderRadius.circular(MediaQuery.of(context).size.width),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(50, 56, 140, 203),
                  spreadRadius: 5.0,
                  blurRadius: 7.0,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_up_rounded,
                    size: 50.0,
                    color: (currentMove != MoveType.stop)
                        ? Colors.black12
                        : Colors.black45,
                  ),
                  onPressed: () {
                    if (currentMove == MoveType.stop) {
                      startUpdateTime = DateTime.now();
                      currentMove = MoveType.up;
                      commandManager.sendMessageToDevice(
                          device, EspControlCmd.ESP_CMD_UP);
                    }
                  },
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 20.0)),
                IconButton(
                  icon: Icon(
                    Icons.radio_button_off,
                    size: 30.0,
                    color: Colors.black45,
                  ),
                  onPressed: () {
                    currentMove = MoveType.stop;
                    commandManager.sendMessageToDevice(
                        device, EspControlCmd.ESP_CMD_STOP);
                  },
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
                IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 50.0,
                    color: (currentMove != MoveType.stop)
                        ? Colors.black12
                        : Colors.black45,
                  ),
                  onPressed: () {
                    if (currentMove == MoveType.stop) {
                      startUpdateTime = DateTime.now();
                      currentMove = MoveType.down;
                      commandManager.sendMessageToDevice(
                          device, EspControlCmd.ESP_CMD_DOWN);
                    }
                  },
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 50)),
          device8113State(),
          Padding(padding: EdgeInsets.only(top: 40)),
        ],
      ),
    );
  }

  Widget _8112() {
    return Center(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.25),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.5,
                decoration: new BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius:
                      BorderRadius.circular(MediaQuery.of(context).size.width),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(50, 56, 140, 203),
                      spreadRadius: (direction == 0) ? 1.0 : 7.0,
                      blurRadius: (direction == 0) ? 1.0 : 15.0,
                      //spreadRadius: (currentTurn == TurnType.off) ? 1.0 : 7.0,
                      //blurRadius: (currentTurn == TurnType.off) ? 1.0 : 15.0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width * 0.15)),
                    IconButton(
                      alignment: Alignment.center,
                      icon: Icon(
                        Icons.power_settings_new_rounded,
                        size: 50.0,
                        color: Colors.black45,
                      ),
                      onPressed: () {
                        setState(() {
                          if (direction == 0) {
                            commandManager.sendMessageToDevice(
                                device, EspControlCmd.ESP_CMD_UP);
                            setState(() {
                              direction = 1;
                            });
                          } else {
                            commandManager.sendMessageToDevice(
                                device, EspControlCmd.ESP_CMD_DOWN);
                            setState(() {
                              direction = 0;
                            });
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 50)),
          Text(
            (direction == 0)
                ? "Состояние напряжения: отключено"
                : "Состояние напряжения: активно",
            style: TextStyle(
              fontSize: 18,
              color: Color.fromARGB(255, 128, 128, 128),
            ),
          ),
        ],
      ),
    );
  }

  Widget _8117(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
          ),
          InkWell(
            splashColor: Color.fromARGB(255, 56, 140, 203),
            onTap: () {
              print("object");
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.5,
              decoration: new BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius:
                    BorderRadius.circular(MediaQuery.of(context).size.width),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(50, 56, 140, 203),
                    spreadRadius: 5.0,
                    blurRadius: 7.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * 0.15)),
                  IconButton(
                    alignment: Alignment.center,
                    icon: Icon(
                      Icons.power_settings_new_rounded,
                      size: 50.0,
                      color: Colors.black45,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    oneChanel = true;
                  });
                },
                child: Text(
                  '1',
                  style: TextStyle(
                      fontSize: 16, color: (oneChanel) ? btn_on : btn_off),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    oneChanel = false;
                  });
                },
                child: Text(
                  '2',
                  style: TextStyle(
                      fontSize: 16, color: (oneChanel) ? btn_off : btn_on),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget device8113State() {
    if (pos == null || pos > 100)
      return Text(
        AppLocalizations.of(context).translate('positionError'),
        style: TextStyle(
          fontSize: 18,
          color: Color.fromARGB(255, 128, 128, 128),
        ),
        textAlign: TextAlign.center,
      );
    else
      return Column(
        children: [
          Text(
            "Ролета открыта на  ${pos.toInt().toString()} %",
            style: TextStyle(
              fontSize: 18,
              color: Color.fromARGB(255, 128, 128, 128),
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 50)),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: LinearProgressIndicator(
              value: pos / 100,
              backgroundColor: Colors.white,
            ),
            decoration: new BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius:
                  BorderRadius.circular(MediaQuery.of(context).size.width),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(50, 56, 140, 203),
                  spreadRadius: 5.0,
                  blurRadius: 7.0,
                ),
              ],
            ),
          ),
        ],
      );
  }

  move() {
    double moveTime = 0;
    moveTime = DateTime.now().difference(startUpdateTime).inMilliseconds / 100;

    if (currentMove == MoveType.up) if (pos != 100)
      setState(() {
        pos = ((startPos + (100 - startPos) * (moveTime / lefTime)) * 10)
                .round() /
            10;
      });
    if (currentMove == MoveType.down) if (pos != 0)
      setState(() {
        pos = ((startPos - startPos * (moveTime / lefTime)) * 10).round() / 10;
      });

    if (currentMove != MoveType.stop && pos < 100 && pos > 0) {
      Timer(Duration(milliseconds: 16), () {
        move();
      });
    }
  }

  stopMove() {
    pos = pos;
  }
}

enum MoveType { up, down, stop }
enum TurnType { on, off }
