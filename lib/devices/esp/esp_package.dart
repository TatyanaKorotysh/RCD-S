import 'dart:typed_data';

import 'package:rcd_s/devices/commands.dart';
import 'package:rcd_s/devices/esp/esp_commands.dart';
import 'package:rcd_s/devices/packages.dart';
import 'package:rcd_s/devices/staff_unstaff.dart';

class EspPackage extends HeaderTypePackage {
  List<int> cmdList = List<int>();
  int cmdByte = 0x00;
  List<int> payload = List<int>();

  EspPackage({List<int> values}) : super() {
    if (values != null) {
//      print("LOAD ESP PACKAGE");
      cmdList = values.sublist(3, 5);
      payload = values.sublist(5, values.length - 1);
//      cmdByte = values[3];
//      payload = values.sublist(4, values.length - 1);
    }
  }

  EspCommand get cmd =>
      EspCmd.values.firstWhere((element) => element.value == cmdByte);

  set cmd(EspCmd command) => (cmdByte = command.value);

  factory EspPackage.createEspPackage(EspCmd cmd,
      {int commandType = 0x01,
      commandSeqId = const [0x01, 0x00],
      payload = const [0x00]}) {
    var espPackage = EspPackage();

    espPackage.type = commandType;
    espPackage.seqId = Uint8List.fromList(commandSeqId);
    espPackage.cmd = cmd;
    espPackage.payload = Uint8List.fromList(payload);

    return espPackage;
  }

  factory EspPackage.createEspPackageWithoutPayload(EspCmd cmd,
      {int commandType = 0x01, commandSeqId = const [0x01, 0x00]}) {
    var espPackage = EspPackage();

    espPackage.type = commandType;
    espPackage.seqId = Uint8List.fromList(commandSeqId);
    espPackage.cmd = cmd;

    return espPackage;
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

    print(packageDataWithoutCrc);

    return packageDataWithoutCrc;
  }

  int calcSrc(List<int> data) {
    int crc = 0xff;

    for (var element in data) {
      crc = crc ^ element;

      for (var j = 0; j < 8; j++) {
        var t = crc;
        t = t << 1;
        t = t & 0xff;

        if (crc & 0x80 != 0) {
          crc = t ^ 0x31;
        } else {
          crc = t;
        }
      }
    }

    return crc;
  }
}
