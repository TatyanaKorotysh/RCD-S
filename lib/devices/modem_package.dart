import 'dart:typed_data';

import 'package:rcd_s/devices/commands.dart';
import 'package:rcd_s/devices/packages.dart';
import 'package:rcd_s/devices/staff_unstaff.dart';

class ModemPackageWithoutPayload extends HeaderTypePackage {
  int cmdByte = 0x00;

  ModemPackageWithoutPayload({List<int> data}) : super() {
    if (data != null) {
      cmdByte = data[3];
    }
  }

  EspTypeCommand get cmd =>
      EspTypeCommand.values.firstWhere((element) => element.value == cmdByte);

  set cmd(EspTypeCommand command) => (cmdByte = command.value);

  EspNetCmd get netCmd =>
      EspNetCmd.values.firstWhere((element) => element.value == cmdByte);

  set netCmd(EspNetCmd command) => cmdByte = command.value;

  set cmdControl(EspControlCmd command) => (cmdByte = command.value);

  factory ModemPackageWithoutPayload.createEventPackageAddDevice(
      EspCommand cmd, int commandType, commandSeqId) {
    var modemPackage = ModemPackageWithoutPayload();
    modemPackage.type = commandType;
    modemPackage.seqId = Uint8List.fromList(commandSeqId);
    modemPackage.netCmd = cmd;

    return modemPackage;
  }

  factory ModemPackageWithoutPayload.createEventPackageReadDevice(
      EspCommand cmd, int commandType, commandSeqId) {
    var modemPackage = ModemPackageWithoutPayload();
    modemPackage.type = commandType;
    modemPackage.seqId = Uint8List.fromList(commandSeqId);
    modemPackage.netCmd = cmd;

    return modemPackage;
  }

  factory ModemPackageWithoutPayload.createEventPackage(
      EspCommand cmd, int commandType, commandSeqId) {
    var modemPackage = ModemPackageWithoutPayload();
    modemPackage.type = commandType;
    modemPackage.seqId = Uint8List.fromList(commandSeqId);
    modemPackage.cmd = cmd;

    return modemPackage;
  }

  List<int> toByteArray() {
    List<int> packageDataWithoutCrc = <int>[
      type,
      seqId[0],
      seqId[1],
      cmdByte & 0xFF,
      cmdByte >> 8
    ];

    //0x00 0x01 0x00 0x02 0x03 0x04 0x63 0xbf 0x01 0x01 + crc = 75
    packageDataWithoutCrc.add(packageDataWithoutCrc.calcCrc());
    packageDataWithoutCrc = packageDataWithoutCrc.staffBytes();
    packageDataWithoutCrc.add(PKG_PREFIX);
    packageDataWithoutCrc.insert(0, PKG_PREFIX);

    return packageDataWithoutCrc;
  }
}

class PackageBuilder {
  ByteBuffer originalByteArray;
  int version;
  bool isEvent;
  HeaderTypePackage packageData;
}

class ModemPackage extends HeaderTypePackage {
  // 3 by // tes header
  int cmdByte = 0x00;
  List<int> payload = List<int>(2);

  ModemPackage({List<int> data}) : super() {
    if (data != null) {
      cmdByte = data[3];
      payload = data.sublist(4, data.length - 1);
    }
  }

  EspTypeCommand get cmd =>
      EspTypeCommand.values.firstWhere((element) => element.value == cmdByte);

  set cmd(EspTypeCommand command) => (cmdByte = command.value);

  EspNetCmd get netCmd =>
      EspNetCmd.values.firstWhere((element) => element.value == cmdByte);

  set netCmd(EspNetCmd command) => cmdByte = command.value;

  set cmdControl(EspControlCmd command) => (cmdByte = command.value);

  ActionGotoCommands get actionCmd => ActionGotoCommands.values
      .firstWhere((element) => element.value == cmdByte);

  set actionCmd(ActionGotoCommands command) => (cmdByte = command.value);

  factory ModemPackage.createEventPackage(
      EspCommand cmd, int commandType, commandSeqId, payload) {
    var modemPackage = ModemPackage();

    modemPackage.type = commandType;
    modemPackage.seqId = Uint8List.fromList(commandSeqId);

    if (cmd is EspTypeCommand) {
      modemPackage.cmd = cmd;
    }

    if (cmd is EspControlCmd) {
      modemPackage.cmdControl = cmd;
    }

    if (cmd is ActionGotoCommands) {
      modemPackage.actionCmd = cmd;
    }

    modemPackage.payload = Uint8List.fromList(payload);

    return modemPackage;
  }

  factory ModemPackage.createEventPackageWithFlags(
      EspCommand cmd, int flags, int commandType, commandSeqId, payload) {
    var modemPackage = ModemPackage();

    modemPackage.type = commandType;
    modemPackage.seqId = Uint8List.fromList(commandSeqId);

    if (cmd is EspTypeCommand) {
      modemPackage.cmd = cmd;
    }

    if (cmd is EspControlCmd) {
      modemPackage.cmdControl = cmd;
    }

    var payloadWithFlags = List<int>();
    payloadWithFlags.addAll(payload);
    payloadWithFlags.add(flags);

    modemPackage.payload = Uint8List.fromList(payloadWithFlags);

    return modemPackage;
  }

  factory ModemPackage.createEventPackageByTypeCommand(
      EspTypeCommand cmd, int commandType, commandSeqId, List<int> payload) {
    var modemPackage = ModemPackage();

    modemPackage.type = commandType;
    modemPackage.seqId = Uint8List.fromList(commandSeqId);
    modemPackage.cmd = cmd;
    modemPackage.payload = Uint8List.fromList(payload);

    return modemPackage;
  }

  factory ModemPackage.createEventPackageAddDevice(
      EspCommand cmd, int commandType, commandSeqId) {
    var modemPackage = ModemPackage();
    modemPackage.type = commandType;
    modemPackage.seqId = Uint8List.fromList(commandSeqId);
    modemPackage.netCmd = cmd;

    return modemPackage;
  }

  factory ModemPackage.createEventPackageDeleteDevice(
      List<int> devicePayload, EspCommand cmd, int commandType, commandSeqId) {
    var modemPackage = ModemPackage();
    modemPackage.type = commandType;
    modemPackage.seqId = Uint8List.fromList(commandSeqId);
    modemPackage.netCmd = cmd;
    modemPackage.payload = Uint8List.fromList(devicePayload);

    return modemPackage;
  }

  factory ModemPackage.createEventPackageReadDevice(
      EspCommand cmd, int commandType, commandSeqId) {
    var modemPackage = ModemPackage();
    modemPackage.type = commandType;
    modemPackage.seqId = Uint8List.fromList(commandSeqId);
    modemPackage.netCmd = cmd;

    return modemPackage;
  }

  factory ModemPackage.createEventPackageTime(
    EspTypeCommand cmd,
    List<int> payloadTime,
    int timeValue, {
    int commandType,
    commandSeqId,
  }) {
    var modemPackage = ModemPackage();

    var firstByte = timeValue & 0xFF;
    var secondByte = (timeValue >> 8) & 0xFF;

    payloadTime.add(firstByte);
    payloadTime.add(secondByte);

    modemPackage.type = commandType;
    modemPackage.seqId = Uint8List.fromList(commandSeqId);
    modemPackage.cmd = cmd;
    modemPackage.payload = Uint8List.fromList(payloadTime);

    return modemPackage;
  }

  List<int> toByteArray() {
    List<int> packageDataWithoutCrc = <int>[
      type,
      seqId[0],
      seqId[1],
      cmdByte & 0xFF,
      cmdByte >> 8
    ];

    packageDataWithoutCrc.addAll(payload);

    //0x00 0x01 0x00 0x02 0x03 0x04 0x63 0xbf 0x01 0x01 + crc = 75
    packageDataWithoutCrc.add(packageDataWithoutCrc.calcCrc());
    packageDataWithoutCrc = packageDataWithoutCrc.staffBytes();
    packageDataWithoutCrc.add(PKG_PREFIX);
    packageDataWithoutCrc.insert(0, PKG_PREFIX);

    return packageDataWithoutCrc;
  }
}
