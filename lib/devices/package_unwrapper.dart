import 'dart:typed_data';

import 'package:rcd_s/devices/packages.dart';
import 'package:rcd_s/devices/modem_package.dart';
import 'package:rcd_s/devices/staff_unstaff.dart';
import 'package:rcd_s/utils/errors.dart';

import 'esp/esp_package.dart';

class PackageUnwrapper {
  int version;
  bool isEvent;
  HeaderTypePackage headerPackage;

  PackageDefault packageDefault = PackageDefault();

  PackageDefault parsePackage(List<int> package) {
    if (package.first != PKG_PREFIX || package.last != PKG_PREFIX)
      throw Exception("asds");

    var realBodyData = package.sublist(1, package.length - 1);
    //print(realBodyData);

    realBodyData = realBodyData.unstaffBytes();
    checkIsCrcValid(realBodyData);
    initVersionAndEvent(realBodyData);

    return packageDefault = _getPackage(realBodyData);
  }

  PackageDefault _getPackage(List<int> packageData) {
    assert(isEvent != null && version != null);

    if (isEvent == true) {
      if (version == 0) {
        return ModemPackage(data: packageData);
      } else if (version == 1) {
        return EspPackage(values: packageData);
      }
    }

    if (isEvent == false) {
      return AnswerPackage(values: packageData);
    }

    return null;
  }

  initVersionAndEvent(List<int> packageData) {
    int ver = packageData.first;

    isEvent = (ver & PKG_ACK_FLAG) == 0;
    version = ver & (~PKG_ACK_FLAG);
  }

  checkIsCrcValid(List<int> realBodyData) {
    var originalCrc = realBodyData.last;
    var calculatedCrc = realBodyData.dropLast(1).calcCrc();

    if (originalCrc != calculatedCrc) {
      throw CrcSumNotValid(realBodyData);
    }
  }
}

class PackageDefault {}
