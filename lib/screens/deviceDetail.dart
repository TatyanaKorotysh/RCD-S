import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rcd_s/devices/command_manager.dart';
import 'package:rcd_s/devices/commands.dart';
import 'package:rcd_s/models/device.dart';
import 'package:rcd_s/services/translate.dart';
import 'package:rcd_s/services/globals.dart' as globals;

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
  double pos = 0;
  double startPos = 0;
  double lefTime = 0;
  int step = 0;
  MoveType currentMove = MoveType.stop;
  Timer currUpdateTimer;
  StreamSubscription subscription;
  DateTime startUpdateTime;

  _DeviceDetailState(Device currentDevice, CommandManager curManager) {
    device = currentDevice;
    commandManager = curManager;
  }

  @override
  void initState() {
    commandManager.loadCurrentState8113(device);
    super.initState();
  }

  @override
  void dispose() {
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
    subscription = commandManager.devConfig.listen((event) {
      setState(() {
        pos = event.curPosPercents.toDouble();
        startPos = event.curPosPercents.toDouble();
        lefTime = event.timeExe.toDouble();
        step = (lefTime / pos).round() * 10;
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
              (globals.isAdmin) ? null : null;
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
        child: _body(),
      ),
    );
  }

  Widget _body() {
    if (device.type == 1) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.15),
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
                        print("up pressed");
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
                      print("stop pressed");
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
                        print("down pressed");
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
            deviceState(),
            Padding(padding: EdgeInsets.only(top: 40)),
          ],
        ),
      );
    } else
      return Center(
        child: Text("Ошибка чтения устройства"),
      );
  }

  Widget deviceState() {
    if (pos == 255)
      return Text("Невозможно определить положение устройства");
    else
      return Column(
        children: [
          Text(
            "${pos.toInt().toString()} %",
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

    print(pos);

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
