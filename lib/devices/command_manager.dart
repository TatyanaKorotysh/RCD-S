import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:rcd_s/connections/mqttConnect.dart';
import 'package:rcd_s/devices/commands.dart';
import 'package:rcd_s/devices/esp/esp_commands.dart';
import 'package:rcd_s/devices/esp/esp_package.dart';
import 'package:rcd_s/devices/modem_package.dart';
import 'package:rcd_s/devices/package_unwrapper.dart';
import 'package:rcd_s/devices/packages.dart';
import 'package:rcd_s/models/device.dart';
import 'package:rcd_s/models/group.dart';
import 'package:rcd_s/models/mqtt_response.dart';
import 'package:rcd_s/models/package_type.dart';
import 'package:rcd_s/models/payload.dart';
import 'package:rcd_s/storage/group_storage.dart';
import 'package:rcd_s/storage/local_storage.dart';
import 'package:rcd_s/storage/settings_storage.dart';

class CommandManager extends ChangeNotifier {
  var _currSeqId = 0;

  MqttManager _mqttConnection = MqttManager();
  var commandStorage = CommandStorage();
  Settings8767Storage _settings8767storage;

  StreamController<List> _deviceStreamController;
  StreamController<List> _errorStreamController;
  StreamController<List> _groupStreamController;
  StreamController<DeviceControlConfig> _devConfigStreamController;
  Stream<List> deviceListStream;
  Stream<List> groupListStream;
  Stream<DeviceControlConfig> devConfig;
  Stream<List> errorStream;

  Group groupForReadDevices;
  Group groupForAddDevices;
  Group groupForDelete;
  Device deviceForDelete;
  Group groupForDeleteDevice;
  Device deviceForDeleteFromGroup;
  DeviceLocalStorage _deviceStorage;
  GroupLocalStorage _groupStorage;

  CommandManager(
    DeviceLocalStorage deviceLocalStorage,
    //TimerLocalStorage timerStorage,
    GroupLocalStorage groupStorage,
    MqttManager connectionController,
    Settings8767Storage settings8767storage,
    //UserCredentialsStorage userCredentialsStorage,
    // UserLocalStorage userLocalStorage,
    // MqttStorage mqttStorage,
    // RcLocalStorage rcLocalStorage,
    // RcButtonLocalStorage rcButtonLocalStorage
  ) {
    _deviceStorage = deviceLocalStorage;
    //  _timerStorage = timerStorage;
    _groupStorage = groupStorage;
    _settings8767storage = settings8767storage;
    // _userCredentialsStorage = userCredentialsStorage;
    //  _userLocalStorage = userLocalStorage;
    // _mqttStorage = mqttStorage;
    _mqttConnection = connectionController;
    // _rcStorage = rcLocalStorage;
    // _rcButtonLocalStorage = rcButtonLocalStorage;
    // subscribeForSocketsEvents();
    _deviceStreamController = StreamController.broadcast();
    _groupStreamController = StreamController.broadcast();
    _devConfigStreamController = StreamController.broadcast();
    _errorStreamController = StreamController.broadcast();
    deviceListStream = _deviceStreamController.stream;
    groupListStream = _groupStreamController.stream;
    devConfig = _devConfigStreamController.stream;
    errorStream = _errorStreamController.stream;
    subscribeForMqttEvents();
  }

  Stream<MqttResponse> get mqttMessageStream =>
      _mqttConnection.mqttMessageStream;

  AnswerPackage answer;

  String getDevName(int value) {
    if (value == RadioDevices.RADIO3_DEVICE_8113_IP65.value) {
      return "Radio 8113 IP65";
    } else if (value == RadioDevices.RADIO3_DEVICE_8113_IP55.value) {
      return "electricDrive";
    } else if (value == RadioDevices.RADIO3_DEVICE_8113_IN.value) {
      return "electricDrive";
    } else if (value == RadioDevices.RADIO3_DEVICE_8113_NB.value) {
      return "Radio 8113 micro";
    } else if (value == RadioDevices.RADIO3_DEVICE_8117_NB.value) {
      return "Radio 8117 micro";
    } else if (value == RadioDevices.RADIO3_DEVICE_8122_MINI.value) {
      return "Radio 8122";
    } else if (value == RadioDevices.RADIO3_DEVICE_SERVER.value) {
      return "SERVER";
    } else if (value == RadioDevices.RADIO3_DEVICE_8101_5.value) {
      return "8101_5";
    } else if (value == RadioDevices.RADIO3_DEVICE_8101_6.value) {
      return "8101_6";
    } else if (value == RadioDevices.RADIO3_DEVICE_SERVER_REMOTE.value) {
      return "SERVER_REMOTE";
    }
    return "UNKNOWN";
  }

  List<int> getNextCommandSeqId() {
    _currSeqId++;

    var firstByte = _currSeqId & 0xFF;
    var secondByte = (_currSeqId >> 8) & 0xFF;

    return [firstByte, secondByte];
  }

  Future<void> sendReadDeviceCommand() {
    var commandType = CommandType.CMD_READ.value;
    var commandSeqId = getNextCommandSeqId();

    var cmd = EspNetCmd.ESP_CMD_READ_DEV;
    var package = ModemPackageWithoutPayload.createEventPackageReadDevice(
        cmd, commandType, commandSeqId);

    commandStorage.storeCommand(commandSeqId, cmd, null);

    _mqttConnection.publish(package.toByteArray());
  }

  Future loadCurrentState8113(Device device) {
    return _loadParametersFromDevice(device, EspTypeCommand.ED_STATE);
  }

  Future _loadParametersFromDevice(Device device, EspTypeCommand cmd) {
    var commandType = CommandType.CMD_READ.value;
    var commandSeqId = getNextCommandSeqId();

    var package = ModemPackage.createEventPackageByTypeCommand(
        cmd, commandType, commandSeqId, (device == null) ? [] : device.payload);

    commandStorage.storeCommand(commandSeqId, cmd, null);
    _mqttConnection.publish(package.toByteArray());

    //return completer.completer.future;
  }

  Future<bool> sendMessageToDevice(Device device, EspCommand cmd, {int flags}) {
    if (device != null) {
      var commandType = CommandType.CMD_WRITE.value;
      var commandSeqId = getNextCommandSeqId();
      var payload = device.payload;

      var package;

      if (flags != null) {
        package = ModemPackage.createEventPackageWithFlags(
            cmd, flags, commandType, commandSeqId, payload);
      } else {
        package = ModemPackage.createEventPackage(
            cmd, commandType, commandSeqId, payload);
      }

      commandStorage.storeCommand(commandSeqId, cmd, null);

      _mqttConnection.publish(package.toByteArray());
      //_mqttConnection.sendCommand(package.toByteArray());

    }
  }

  Future<bool> sendDeleteCommand(Device device, bool isHardDelete) async {
    var commandType =
        isHardDelete ? CommandType.CMD_READ.value : CommandType.CMD_WRITE.value;
    var commandSeqId = getNextCommandSeqId();
    //var completer = getCompleter<bool>();

    var payload = device.payload;

    var cmd = EspNetCmd.ESP_CMD_DEL_DEV;

    var package = ModemPackage.createEventPackageDeleteDevice(
        payload, cmd, commandType, commandSeqId);

    commandStorage.storeCommand(
        commandSeqId, cmd, null /*, completer: completer*/);

    deviceForDelete = device;

    _mqttConnection.publish(package.toByteArray());
    //_connectionController.sendCommand(package.toByteArray(),
    //  completer: completer);

    //return completer.completer.future;
  }

  sendAddDeviceCommand() {
    var commandType = CommandType.CMD_WRITE.value;
    var commandSeqId = getNextCommandSeqId();

    var cmd = EspNetCmd.ESP_CMD_ADD_DEV;

    var package = ModemPackageWithoutPayload.createEventPackageAddDevice(
        cmd, commandType, commandSeqId);

    commandStorage.storeCommand(commandSeqId, cmd, null);
    //_connectionController.sendCommand(package.toByteArray());
    _mqttConnection.publish(package.toByteArray());
  }

  Future<bool> sendCreateGroupCommand(int groupId) async {
    var commandType = CommandType.CMD_WRITE.value;
    var commandSeqId = getNextCommandSeqId();
    //var completer = getCompleter<bool>();
    var cmd = EspTypeCommand.MODEM_GROUP_ADD;

    var package = ModemPackage.createEventPackage(
        cmd, commandType, commandSeqId, GroupInfo(groupId).toBytes());

    commandStorage.storeCommand(
        commandSeqId, cmd, null /*, completer: completer*/);
    // _connectionController.sendCommand(package.toByteArray(),
    //     completer: completer);

    _mqttConnection.publish(package.toByteArray());

    //return completer.completer.future;
  }

  Future<bool> sendDeleteGroupCommand(Group group) async {
    var commandType = CommandType.CMD_WRITE.value;
    var commandSeqId = getNextCommandSeqId();
    //var completer = getCompleter<bool>();
    var cmd = EspTypeCommand.MODEM_GROUP_RM;

    groupForDelete = group;
    var package = ModemPackage.createEventPackage(
        cmd, commandType, commandSeqId, GroupInfo(group.id).toBytes());

    commandStorage.storeCommand(
        commandSeqId, cmd, null /*, completer: completer*/);
    //_connectionController.sendCommand(package.toByteArray(),
    //    completer: completer);

    _mqttConnection.publish(package.toByteArray());

    //return completer.completer.future;
  }

  Future<bool> sendReadGroupsCommand() {
    var commandType = CommandType.CMD_READ.value;
    var commandSeqId = getNextCommandSeqId();

    var cmd = EspTypeCommand.MODEM_GROUP;

    var package = ModemPackageWithoutPayload.createEventPackage(
        cmd, commandType, commandSeqId);

    commandStorage.storeCommand(commandSeqId, cmd, null);

    //_connectionController.sendCommand(package.toByteArray());
    _mqttConnection.publish(package.toByteArray());
  }

  Future<bool> sendAddDeviceToGroupCommand(Group group, Device device,
      {int flag = 1}) async {
    var commandType = CommandType.CMD_WRITE.value;
    var commandSeqId = getNextCommandSeqId();
    //var completer = getCompleter<bool>();
    var cmd = EspTypeCommand.MODEM_GROUP_ED_ADD;

    groupForAddDevices = group;

    List<int> payload = GroupInfo(group.id).toBytes();
    payload.addAll(device.payload);

    var package = ModemPackage.createEventPackageWithFlags(
        cmd, flag, commandType, commandSeqId, payload);

    commandStorage.storeCommand(
        commandSeqId, cmd, null /*, completer: completer*/);
    //_connectionController.sendCommand(package.toByteArray(),
    //completer: completer);
    _mqttConnection.publish(package.toByteArray());

    //return completer.completer.future;
  }

  Future<bool> sendDeleteDeviceFromGroupCommand(
      Group group, Device device, bool isHardDelete) async {
    var commandType =
        isHardDelete ? CommandType.CMD_READ.value : CommandType.CMD_WRITE.value;
    print(commandType);
//    var commandType = CommandType.CMD_WRITE.value;
    var commandSeqId = getNextCommandSeqId();
    //var completer = getCompleter<bool>();
    var cmd = EspTypeCommand.MODEM_GROUP_ED_RM;

    List<int> payload = GroupInfo(group.id).toBytes();

    if (isHardDelete) {
      payload.addAll([0, 0, device.id, 0]);
    } else {
      payload.addAll(device.payload);
    }

    groupForDeleteDevice = group;
    deviceForDeleteFromGroup = device;
    var package = ModemPackage.createEventPackage(
        cmd, commandType, commandSeqId, payload);

    commandStorage.storeCommand(
      commandSeqId,
      cmd,
      null, /*completer: completer*/
    );
    // _connectionController.sendCommand(package.toByteArray(),
    //    completer: completer);
    _mqttConnection.publish(package.toByteArray());

    //return completer.completer.future;
  }

  Future<bool> sendReadDevicesFromGroupCommand(Group group) async {
    //groupForReadDevices = null;
    if (groupForReadDevices != null) {
      return false;
    }

    print("----------------" + group.id.toString());

    var commandType = CommandType.CMD_READ.value;
    var commandSeqId = getNextCommandSeqId();
    //var completer = getCompleter<bool>();
    var cmd = EspTypeCommand.MODEM_GROUP_ED;

    groupForReadDevices = group;
    var package = ModemPackage.createEventPackage(
        cmd, commandType, commandSeqId, GroupInfo(group.id).toBytes());

    commandStorage.storeCommand(
        commandSeqId, cmd, null /*, completer: completer*/);
    /*_connectionController.sendCommand(package.toByteArray(),
        completer: completer);*/
    _mqttConnection.publish(package.toByteArray());

    //return completer.completer.future;
  }

  Future<void> subscribeForMqttEvents() {
    mqttMessageStream.listen((MqttResponse mqttResponse) {
      List<int> dataPackage = mqttResponse.payload.codeUnits;
      return decodeDataPackage(dataPackage, topic: mqttResponse.topic);
    });
  }

  void decodeDataPackage(List<int> dataPackage, {String topic}) {
    var packageUnwrapper = PackageUnwrapper();
    var package = packageUnwrapper.parsePackage(dataPackage);

    if (package is EspPackage) {
      var prevCommand = commandStorage.getLastCommand();
      checkAndProcessTheEventControlCmd(package, prevCommand);
    }

    if (package is AnswerPackage) {
      var prevCommand = commandStorage.getCommand(package.seqId);
      //если !true не выполняем
      //если !fasle выполняем
      //если есть ошибка возвращаем true
      if (!checkIsErrorAndSendToStream(package, prevCommand)) {
        //return;

        if (prevCommand != null) {
          if (prevCommand.cmd != null) {
            //devices
            checkAndProcessTheReadDevices(package, prevCommand);
            checkAndProcessTheDeletedDevices(package, prevCommand);
            checkAndProcessTheAddedDevices(package, prevCommand);

            // 8113, 8113 and etc controls
            //checkAndProcessTheControlCmd(package, prevCommand);
            checkAndProcessTheState(package, prevCommand);
            //checkAndProcessTheControlCmdStopped(package, prevCommand);

            //groups
            checkAndProcessTheCreatedGroup(package, prevCommand);
            checkAndProcessTheReadGroups(package, prevCommand);
            checkAndProcessTheDeletedGroup(package, prevCommand);
            checkAndProcessTheReadDevicesFromGroup(package, prevCommand);
            checkAndProcessTheAddedDeviceToGroup(package, prevCommand);
            checkAndProcessTheDeletedDeviceFromGroup(package, prevCommand);
          }
        }
      }
    }
  }

  bool checkIsErrorAndSendToStream(AnswerPackage package, Command prevCommand) {
    if (package.payload.length == 0) {
      //groupForReadDevices = null;
      //groupForDelete = null;
      //deviceForDelete = null;
      //groupForDeleteDevice = null;
      //deviceForDeleteFromGroup = null;
      return false;
    }

    var packageType = PackageStructureType.parse(package.type);

    //проверка на ошибки payload

    if (package.payload[0] == 0xc &&
        package.payload[1] == Errors.ERROR_GROUP_DEV_EXIST.value) {
      List error = ["error_group_exist", "error_group_exist_note"];
      _errorStreamController.add(error);
      /*_errorStream
          .add(FoundErrorEvent(Errors.ERROR_GROUP_DEV_EXIST, prevCommand));
      prevCommand.completer.completer?.completeError(
          FoundErrorEvent(Errors.ERROR_GROUP_DEV_EXIST, prevCommand));
      print("ERROR_GROUP_DEV_EXIST");
      */
      return true;
    }

    /*if (package.payload[0] == 0xc &&
        package.payload[1] == Errors.ERROR_GROUP_NOT_EMPTY.value) {
      List error = ["error_group_exist", "error_group_exist_note"];
      _errorStreamController.add(error);
      /*_errorStream
          .add(FoundErrorEvent(Errors.ERROR_GROUP_DEV_EXIST, prevCommand));
      prevCommand.completer.completer?.completeError(
          FoundErrorEvent(Errors.ERROR_GROUP_DEV_EXIST, prevCommand));
      print("ERROR_GROUP_DEV_EXIST");
      */
      return true;
    }*/

    if (package.payload[0] == 0xc &&
        package.payload[1] == Errors.ERROR_DEV_TIMEOUT.value) {
      if (prevCommand != null) {
        //if (prevCommand.completer != null) {
        //  if (!prevCommand.completer.completer.isCompleted) {
        //_errorStream
        //    .add(FoundErrorEvent(Errors.ERROR_DEV_TIMEOUT, prevCommand));
        //prevCommand.completer?.completer?.completeError(
        //    FoundErrorEvent(Errors.ERROR_DEV_TIMEOUT, prevCommand));
        print("DEVICE TIMEOUT ON COMMAND ${prevCommand.cmd.toString()}");
        groupForReadDevices = null;
        //}
        //}
      }

      /*if (prevCommand != null) {
        if (prevCommand.cmd.toString() ==
            EspTypeCommand.MODEM_RC_LIST_ADD.toString()) {
         _deviceStream.add(RcNotFound());
        }
      }*/

      return true;
    }

    return false;
  }

  void checkAndProcessTheDeletedGroup(
      AnswerPackage package, Command prevCommand) {
    if (prevCommand.cmd.toString() ==
        EspTypeCommand.MODEM_GROUP_RM.toString()) {
      if (package.payload.length == 0) {
        print("remove group success package");
        removeGroupWithSuccess(prevCommand);
        //prevCommand.completer.completer?.complete(true);
      }
    }
  }

  void removeGroupWithSuccess(Command prevCommand) {
    _groupStorage.removeGroupWithStream(groupForDelete);
    groupForDelete = null;
    sendReadGroupsCommand();
  }

  void checkAndProcessTheCreatedGroup(
      AnswerPackage package, Command prevCommand) {
    if (prevCommand.cmd.toString() ==
        EspTypeCommand.MODEM_GROUP_ADD.toString()) {
      if (package.payload.length == 0) {
        print("create group success package");
        //removeGroupWithSuccess(prevCommand);
        //prevCommand.completer.completer?.complete(true);
      }
      sendReadGroupsCommand();
    }
  }

  void checkAndProcessTheAddedDevices(AnswerPackage package, prevCommand) {
    if (prevCommand.cmd.toString() == EspNetCmd.ESP_CMD_ADD_DEV.toString()) {
      if (package.payload.isNotEmpty) {
        print("added devices with list package");

        var list = getDeviceListByPayload(package.payload);
        list.forEach((device) {
          _deviceStorage.storeDevice(device);
        });

        _deviceStreamController.add(list);

        //_deviceStream.add(DeviceListChangedSocketEvent(
        //    _deviceStorage.getDeviceListForCurrent8767()));
        //_deviceStream.add(NewDevicesAddedEvent(list));
      } else {
        print("add devices started package");

        //_deviceStream.add(DeviceListChangedSocketEvent(List()));
        //_deviceStream.add(NewDevicesAddedEvent(List()));
      }
//      print("Add command finished");
    }
  }

  void checkAndProcessTheDeletedDevices(
      AnswerPackage package, Command prevCommand) {
    if (prevCommand.cmd.toString() == EspNetCmd.ESP_CMD_DEL_DEV.toString()) {
      print("remove device success package");
      // todo check whether we should check for empty payload or not. 15.06.2020
      removeDeviceWithSuccess(prevCommand);
    }
  }

  void removeDeviceWithSuccess(Command prevCommand) {
    //_deviceStorage.removeDeviceWithStream(deviceForDelete);
    // _devConfigStreamController.add(deviceControlConfig);
    if (_errorStreamController == null) {
      _deviceStreamController
          .add(_deviceStorage.removeDeviceWithStream(deviceForDelete));
    }
    _errorStreamController = null;
    deviceForDelete = null;

    _deviceStorage.getAllDeviceList();

    //prevCommand.completer.completer.complete(true);
    //_deviceStream.add(DeviceDeletedEvent());
    //_deviceStream.add(DeviceListChangedSocketEvent(
    //    _deviceStorage.getDeviceListForCurrent8767()));
  }

  void checkAndProcessTheEventControlCmd(
      EspPackage package, Command prevCommand) {
    print("FIRST = ${EspCmd.EVENT_DEV_STATE.value & 0xFF}");
    print("SECOND = ${EspCmd.EVENT_DEV_STATE.value >> 8}");
    if (package.payload.length % 5 == 0 &&
        (package.cmdList[0] == EspCmd.EVENT_DEV_STATE.value & 0xFF &&
            package.cmdList[1] == EspCmd.EVENT_DEV_STATE.value >> 8)) {
      int countOfDevicesInPackage = (package.payload.length / 5).round();
      for (int packagePosition = 0;
          packagePosition < countOfDevicesInPackage;
          packagePosition++) {
        progressTheEventControlCmd(package.payload
            .sublist(0 + 5 * packagePosition, 5 + 5 * packagePosition));
      }
    }
  }

  void progressTheEventControlCmd(List<int> payload) {
    DeviceControlConfig deviceControlConfig =
        DeviceControlConfig.fromBytes(payload.sublist(1, 5));

    print("команда управления девайсом: " +
        deviceControlConfig.toString() +
        " package");

    double timeExe = deviceControlConfig.timeExe.toDouble();

    if (deviceControlConfig.unitTime == 0)
      timeExe = deviceControlConfig.timeExe * 0.1;
    else if (deviceControlConfig.unitTime == 2) {
      timeExe = (deviceControlConfig.timeExe * 60).toDouble();
    } else if (deviceControlConfig.unitTime == 3) {
      timeExe = (deviceControlConfig.timeExe * 60 * 60).toDouble();
    }

    /*Direction direction;

    if (deviceControlConfig.direction == 1) {
      direction = Direction.UP_OR_ON;
    } else {
      direction = Direction.DOWN_OR_OFF;
    }*/

    var currPos = deviceControlConfig.curPosPercents.toDouble();

    if (currPos == 255) {
      currPos = null;
    } else {
      currPos = currPos / 2;
    }

    print(
        "received: percents = ${deviceControlConfig.curPosPercents.toDouble()}" +
            "\n" +
            // "direction = $direction" +
            "\n" +
            "time = ${double.parse(timeExe.toStringAsFixed(1))}");

    _devConfigStreamController.add(deviceControlConfig);
  }

  void checkAndProcessTheReadDevices(
      AnswerPackage package, Command prevCommand) {
    if (prevCommand.cmd.toString() == EspNetCmd.ESP_CMD_READ_DEV.toString() &&
        (package.cmd[0] == EspNetCmd.ESP_CMD_READ_DEV.value & 0xFF &&
            package.cmd[1] == EspNetCmd.ESP_CMD_READ_DEV.value >> 8)) {
      print("read devices list package");

      var list = getDeviceListByPayload(package.payload);
      print("DEVICES = $list");

      var packageType = PackageStructureType.parse(package.type);
      if (packageType.isPartOfPackage()) {
        _deviceStorage.storeToTemp(list);
        //prevCommand.completer.updateFutureWithTime();
      } else {
        _deviceStorage.storeToTemp(list);
        _deviceStorage.storeAllDevices();
        //_deviceStreamController.add(list);
        //_deviceStream.add(DeviceListChangedSocketEvent(
        //_deviceStorage.getDeviceListForCurrent8767()));

        //prevCommand.completer.completer?.complete(true);
      }
    }
  }

  void checkAndProcessTheReadGroups(
      AnswerPackage package, Command prevCommand) {
    if (prevCommand.cmd.toString() == EspTypeCommand.MODEM_GROUP.toString() &&
        (package.cmd[0] == EspTypeCommand.MODEM_GROUP.value & 0xFF &&
            package.cmd[1] == EspTypeCommand.MODEM_GROUP.value >> 8)) {
      var list = getGroupListByPayload(package.payload);
      print("GROUPS = $list");

      var packageType = PackageStructureType.parse(package.type);
      if (packageType.isPartOfPackage()) {
        _groupStorage.storeToTemp(list);
        //prevCommand.completer.updateFutureWithTime();
      } else {
        _groupStorage.storeToTemp(list);
        _groupStorage.storeAllGroups();
        _groupStreamController.add(list);
      }
    }
  }

  /*void checkAndProcessTheControlCmd(
      AnswerPackage package, Command prevCommand) {
    // print("_____________________________________________");
    // print(package.payload);
    // print(package.payload.length);
    if (package.payload.length == 4 &&
        (prevCommand.cmd.toString() == EspControlCmd.ESP_CMD_UP.toString() ||
            prevCommand.cmd.toString() ==
                EspControlCmd.ESP_CMD_DOWN.toString() ||
            prevCommand.cmd.toString() ==
                EspControlCmd.ESP_CMD_LOOP.toString())) {
      DeviceControlConfig deviceControlConfig =
          DeviceControlConfig.fromBytes(package.payload);

      print("команда управления девайсом: " +
          deviceControlConfig.toString() +
          " package");

      double timeExe = deviceControlConfig.timeExe.toDouble();

      if (deviceControlConfig.unitTime == 0)
        timeExe = deviceControlConfig.timeExe * 0.1;
      else if (deviceControlConfig.unitTime == 2) {
        timeExe = (deviceControlConfig.timeExe * 60).toDouble();
      } else if (deviceControlConfig.unitTime == 3) {
        timeExe = (deviceControlConfig.timeExe * 60 * 60).toDouble();
      }

      /*Direction direction;

      if (deviceControlConfig.direction == 1) {
        direction = Direction.UP_OR_ON;
      } else {
        direction = Direction.DOWN_OR_OFF;
      }*/

      var currPos = deviceControlConfig.curPosPercents.toDouble();

      if (currPos == 255) {
        currPos = null;
      } else {
        currPos = currPos / 2;
      }

      print(
          "received: percents = ${deviceControlConfig.curPosPercents.toDouble()}" +
              "\n" // +
                  //"direction = $direction" +
                  "\n" +
              "time = ${double.parse(timeExe.toStringAsFixed(1))}");
      _devConfigStreamController.add(deviceControlConfig);
      //(deviceControlConfig.timeExe / 10).round() - convert time to seconds

      //if (prevCommand.completer != null) {
      // if (!prevCommand.completer.completer.isCompleted)
      //   prevCommand.completer.completer.complete(true);
      // }
      // } else
      if (package.payload.isNotEmpty &&
          package.payload.length % 3 == 0 &&
          (prevCommand.cmd.toString() == EspControlCmd.ESP_CMD_UP.toString() ||
              prevCommand.cmd.toString() ==
                  EspControlCmd.ESP_CMD_DOWN.toString() ||
              prevCommand.cmd.toString() ==
                  EspControlCmd.ESP_CMD_LOOP.toString())) {
        double maxTimeExe = 0;
        int position = 1;

        package.payload.forEach((element) {
          if (position % 3 == 2 && (element * 0.1) > maxTimeExe) {
            maxTimeExe = element * 0.1;
          }
          position++;
        });

        //_deviceStream.add(WorkTimeChangedEvent(maxTimeExe));
      }

      /*if (package.payload.length == 0 &&
        (prevCommand.cmd.toString() == EspControlCmd.ESP_CMD_UP.toString() ||
            prevCommand.cmd.toString() ==
                EspControlCmd.ESP_CMD_DOWN.toString() ||
            prevCommand.cmd.toString() ==
                EspControlCmd.ESP_CMD_LOOP.toString())) {
      if (prevCommand.completer != null) {
        if (!prevCommand.completer.completer.isCompleted)
          prevCommand.completer.completer.complete(true);
      }*/
    }
  }*/

  void checkAndProcessTheState(AnswerPackage package, Command prevCommand) {
    if (package.payload.isNotEmpty &&
        prevCommand.cmd.toString() == EspTypeCommand.ED_STATE.toString()) {
      print("checkAndProcessTheControlCmd payload = " +
          package.payload.toString());

      DeviceControlConfig deviceControlConfig =
          DeviceControlConfig.fromBytes(package.payload);
      print("команда управления девайсом: " +
          deviceControlConfig.toString() +
          " package");
      double timeExe = deviceControlConfig.timeExe.toDouble();

      if (deviceControlConfig.unitTime == 0)
        timeExe = deviceControlConfig.timeExe * 0.1;
      else if (deviceControlConfig.unitTime == 2) {
        timeExe = (deviceControlConfig.timeExe * 60).toDouble();
      } else if (deviceControlConfig.unitTime == 3) {
        timeExe = (deviceControlConfig.timeExe * 60 * 60).toDouble();
      }

      Direction direction;

      if (deviceControlConfig.direction == 1) {
        direction = Direction.UP_OR_ON;
      } else {
        direction = Direction.DOWN_OR_OFF;
      }

      /*var currPos = deviceControlConfig.curPosPercents.toDouble();

      if (currPos == 255) {
        currPos = null;
      } else {
        currPos = currPos / 2;
      }*/

      print(
          "received: percents = ${deviceControlConfig.curPosPercents.toDouble()}" +
              "\n" +
              //"direction = $direction" +
              "\n" +
              "time = ${double.parse(timeExe.toStringAsFixed(1))}");

      //deviceControlConfig.curPosPercents = currPos.toInt();
      deviceControlConfig.timeExe = timeExe.toInt();

      _devConfigStreamController.add(deviceControlConfig);
    }
  }

  void checkAndProcessTheControlCmdStopped(
      AnswerPackage package, Command prevCommand) {
    if (
//    package.payload.isNotEmpty &&
        prevCommand.cmd.toString() == EspControlCmd.ESP_CMD_STOP.toString()) {
      print("команда управления девайсом: stop package");
      // _listStreamController.add(ControlCmdStoppedEvent());
    }
  }

  List<Device> getDeviceListByPayload(List<int> payload) {
    var deviceList = List<Device>();
    var deviceCount = payload.length / 4;
    for (var i = 0; i < deviceCount; i++) {
      var devicePayload = payload.takeAndRemove(4);
      DeviceInfo deviceInfo = DeviceInfo.fromBytes(devicePayload);
      var deviceName = "${getDevName(deviceInfo.type)}";
      Device device = Device(deviceName, devicePayload, deviceInfo.idNet,
          deviceInfo.type, deviceName, _settings8767storage.getSettings().mac);
      deviceList.add(device);
    }
    /*Device device = Device("8112_MINI", payload, deviceList.length + 1, 2,
        "8112_MINI", _settings8767storage.getSettings().mac);
    deviceList.add(device);
    device = Device("Radio 8117 micro", payload, deviceList.length + 1, 3,
        "Radio 8117 micro", _settings8767storage.getSettings().mac);
    deviceList.add(device);*/

    //_listStreamController.add(deviceList);

    return deviceList;
  }

  List<Group> getGroupListByPayload(List<int> payload) {
    var groupList = List<Group>();
    var groupCount = payload.length / 2;
    for (var i = 0; i < groupCount; i++) {
      var groupIdBytes = payload.takeAndRemove(2);
      GroupInfo groupInfo = GroupInfo.fromBytes(groupIdBytes);
      var groupName = "Группа ${groupInfo.groupId}";

      Group group = Group(
          id: groupInfo.groupId,
          name: groupName,
          deviceIds: [],
          mac: _settings8767storage.getSettings().mac);

      groupList.add(group);
    }

    return groupList;
  }

  void checkAndProcessTheReadDevicesFromGroup(
      AnswerPackage package, Command prevCommand) {
    if (prevCommand.cmd.toString() ==
            EspTypeCommand.MODEM_GROUP_ED.toString() &&
        groupForReadDevices != null) {
      var groupDeviceList = List<int>();
      var groupCount = package.payload.length;
      for (var i = 0; i < groupCount; i++) {
        var deviceIdBytes = package.payload.takeAndRemove(1);

        groupDeviceList.add(deviceIdBytes.fromBytes());
      }

      _deviceStreamController.add(groupDeviceList);
      groupForReadDevices.deviceIds = groupDeviceList;
      _groupStorage.updateGroup(groupForReadDevices);
      /* _groupStorage.updateGroup(Group(
          //imagePath: groupForReadDevices.imagePath,
          name: groupForReadDevices.name,
          id: groupForReadDevices.id,
          deviceIds: package.payload,
          mac: _settings8767storage.getSettings().mac));*/

      groupForReadDevices = null;
      //prevCommand.completer.completer?.complete(true);
    }
  }

  void checkAndProcessTheAddedDeviceToGroup(
      AnswerPackage package, Command prevCommand) {
    if (prevCommand.cmd.toString() ==
        EspTypeCommand.MODEM_GROUP_ED_ADD.toString()) {
      if (package.payload.length == 0) {
        print("device added to group success package");

        sendReadDevicesFromGroupCommand(groupForAddDevices);
        groupForAddDevices = null;

        /*var groupDeviceList = List<int>();
        var groupCount = package.payload.length;
        for (var i = 0; i < groupCount; i++) {
          var deviceIdBytes = package.payload.takeAndRemove(1);

          groupDeviceList.add(deviceIdBytes.fromBytes());
        }

        _deviceStreamController.add(groupDeviceList);
        groupForReadDevices.deviceIds = groupDeviceList;
        _groupStorage.updateGroup(groupForReadDevices);

        groupForReadDevices = null;*/
        //prevCommand.completer.completer?.complete(true);
      }
    }
  }

  void checkAndProcessTheDeletedDeviceFromGroup(
      AnswerPackage package, Command prevCommand) {
    if (prevCommand.cmd.toString() ==
        EspTypeCommand.MODEM_GROUP_ED_RM.toString()) {
      if (package.payload.length == 0) {
        print("device deleted from group success package");

        List<int> newDeviceIdsFromGroup = [];

        groupForDeleteDevice.deviceIds.forEach((element) {
          if (element != deviceForDeleteFromGroup.id) {
            newDeviceIdsFromGroup.add(element);
          }
        });

        _deviceStreamController.add(newDeviceIdsFromGroup);

        _groupStorage.updateGroup(Group(
            id: groupForDeleteDevice.id,
            name: groupForDeleteDevice.name,
            //imagePath: groupForDeleteDevice.imagePath,
            deviceIds: newDeviceIdsFromGroup,
            mac: _settings8767storage.getSettings().mac));

        //prevCommand.completer.completer?.complete(true);
      }
    }
  }
}

class CommandStorage {
  HashMap<int, Command> commandHashMap = HashMap();

  storeCommand(List<int> commandSeqId, EspCommand cmd, SubCmd subCmd) {
    int commandSeqInt = commandSeqId[0] + commandSeqId[1];

    var command = Command();
    command.cmd = cmd;
    command.subCmd = subCmd;

    commandHashMap.remove(commandSeqInt);
    commandHashMap.putIfAbsent(commandSeqInt, () => command);
  }

  Command getCommand(List<int> commandSeqId) {
    return commandHashMap[commandSeqId[0] + commandSeqId[1]];
  }

  Command getLastCommand() {
    if (commandHashMap.isEmpty) {
      return null;
    }
    return commandHashMap.entries.last.value;
  }
}

class Command {
  EspCommand cmd;
  SubCmd subCmd;
}

class RadioDevices {
  static const RadioDevices RADIO3_DEVICE_8113_IP65 = const RadioDevices._(1);
  static const RadioDevices RADIO3_DEVICE_8113_IP55 = const RadioDevices._(2);
  static const RadioDevices RADIO3_DEVICE_8113_IN = const RadioDevices._(3);
  static const RadioDevices RADIO3_DEVICE_8113_NB = const RadioDevices._(4);
  static const RadioDevices RADIO3_DEVICE_8117_NB = const RadioDevices._(5);
  static const RadioDevices RADIO3_DEVICE_8122_MINI = const RadioDevices._(6);
  static const RadioDevices RADIO3_DEVICE_SERVER = const RadioDevices._(63);
  static const RadioDevices RADIO3_DEVICE_8101_5 = const RadioDevices._(64);
  static const RadioDevices RADIO3_DEVICE_8101_6 = const RadioDevices._(65);
  static const RadioDevices RADIO3_DEVICE_SERVER_REMOTE =
      const RadioDevices._(0x7e);

  final value;

  static const values = [
    RADIO3_DEVICE_8113_IP65,
    RADIO3_DEVICE_8113_IP55,
    RADIO3_DEVICE_8113_IN,
    RADIO3_DEVICE_8113_NB,
    RADIO3_DEVICE_8117_NB,
    RADIO3_DEVICE_8122_MINI,
    RADIO3_DEVICE_SERVER,
    RADIO3_DEVICE_8101_5,
    RADIO3_DEVICE_8101_6,
    RADIO3_DEVICE_SERVER_REMOTE,
  ];

  const RadioDevices._(this.value);

  List<Object> get props => [value];

  @override
  String toString() {
    if (value == RADIO3_DEVICE_8113_IP65.value) {
      return "Radio 8113 IP65";
    } else if (value == RADIO3_DEVICE_8113_IP55.value) {
      return "electricDrive";
    } else if (value == RADIO3_DEVICE_8113_IN.value) {
      return "electricDrive";
    } else if (value == RADIO3_DEVICE_8113_NB.value) {
      return "Radio 8113 micro";
    } else if (value == RADIO3_DEVICE_8117_NB.value) {
      return "Radio 8117 micro";
    } else if (value == RADIO3_DEVICE_8122_MINI.value) {
      return "8122_MINI";
    } else if (value == RADIO3_DEVICE_SERVER.value) {
      return "SERVER";
    } else if (value == RADIO3_DEVICE_8101_5.value) {
      return "8101_5";
    } else if (value == RADIO3_DEVICE_8101_6.value) {
      return "8101_6";
    } else if (value == RADIO3_DEVICE_SERVER_REMOTE.value) {
      return "SERVER_REMOTE";
    }

    return "$runtimeType ${value.toString()}";
  }
}

enum Direction { UP_OR_ON, DOWN_OR_OFF }
