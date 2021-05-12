import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

///класс для сохранения и конфигурирования данных esp в cloud
class CloudConfig {
  static const _USER_LENGTH = 24;
  static const _PASSWORD_LENGTH = 24;
  static const _ADDRESS_LENGTH = 48;

  String user;
  String password;
  String address;
  int port;
  bool useSsl;

  CloudConfig(this.user, this.password, this.address, this.port, this.useSsl);

  CloudConfig.fromBytes(List<int> bytes) {
    user = utf8.decode((bytes.takeAndRemove(_USER_LENGTH).deleteZeros()));
    password = utf8.decode(bytes.takeAndRemove(_PASSWORD_LENGTH).deleteZeros());
    address = utf8.decode(bytes.takeAndRemove(_ADDRESS_LENGTH).deleteZeros());
    port = bytes.sublist(0, 2).fromBytes();
    useSsl = bytes[2] == 1;
  }

  List<int> toBytes() {
    final result = List<int>();

    result.addAll(utf8.encode(user));
    result.addAll(result.addZero(_USER_LENGTH - utf8.encode(user).length));
    result.addAll(utf8.encode(password));
    result.addAll(
        result.addZero(_PASSWORD_LENGTH - utf8.encode(password).length));
    result.addAll(utf8.encode(address));
    result
        .addAll(result.addZero(_ADDRESS_LENGTH - utf8.encode(address).length));
    result.addAll(port.toBytes(2));

    if (useSsl)
      result.add(1);
    else
      result.add(0);

    result.add(0);

    return result;
  }
}

///класс для сохранения и конфигурирования данных esp в wifi sta (режим точки доступа)
class StaConfig {
  static const _SSID_LENGTH = 32;
  static const _PASSWORD_LENGTH = 64;

  String ssid;
  String password;
  int tcpPort;
  int udpPort;

  StaConfig(this.ssid, this.password, this.tcpPort, this.udpPort);

  StaConfig.fromBytes(List<int> bytes) {
    ssid = utf8.decode(bytes.takeAndRemove(_SSID_LENGTH).deleteZeros());
    password = utf8.decode(bytes.takeAndRemove(_PASSWORD_LENGTH).deleteZeros());
    tcpPort = bytes.sublist(0, 2).fromBytes();
    udpPort = bytes.sublist(2, 4).fromBytes();
  }

  List<int> toBytes() {
    final result = List<int>();

    result.addAll(utf8.encode(ssid));
    result.addAll(result.addZero(_SSID_LENGTH - utf8.encode(ssid).length));
    result.addAll(utf8.encode(password));
    result.addAll(
        result.addZero(_PASSWORD_LENGTH - utf8.encode(password).length));
    result.addAll(tcpPort.toBytes(2));
    result.addAll(udpPort.toBytes(2));

    return result;
  }
}

///класс для сохранения и конфигурирования данных esp в wifi ap (режим для подключения по WIFI)
class ApConfig {
  static const _SSID_LENGTH = 32;
  static const _PASSWORD_LENGTH = 64;

  String ssid;
  String password;

  ApConfig(this.ssid, this.password);

  ApConfig.fromBytes(List<int> bytes) {
    ssid = utf8.decode(bytes.takeAndRemove(_SSID_LENGTH).deleteZeros());
    password = utf8.decode(bytes.takeAndRemove(_PASSWORD_LENGTH).deleteZeros());
  }

  List<int> toBytes() {
    final result = List<int>();

    result.addAll(utf8.encode(ssid));
    result.addAll(result.addZero(_SSID_LENGTH - utf8.encode(ssid).length));
    result.addAll(utf8.encode(password));
    result.addAll(
        result.addZero(_PASSWORD_LENGTH - utf8.encode(password).length));

    return result;
  }
}

///класс для сохранения и конфигурирования данных esp в sntp структуре
///(протокол синхронизации времени), конфигурация SNMP клиента
class SntpConfig {
  static const _ADDRESS_LENGTH = 48;

  String address;
  int timezone;
  int res;
  int flags;
  bool isEnable;

  SntpConfig.fromBytes(List<int> bytes) {
    address = utf8.decode(bytes.takeAndRemove(_ADDRESS_LENGTH));
//    timezone = bytes[0];

    ByteData byteData = ByteData(1);
    byteData.setUint8(0, bytes[0]);

    timezone = byteData.getInt8(0) * -1;

    final firstByte = bytes[1].toRadixString(2).padLeft(8, "0");

    flags = int.parse(firstByte[7], radix: 2);
    isEnable = flags == 1;

//    flags = bytes[1];
    res = bytes.sublist(2, 4).fromBytes();
  }

  static List<int> toBytesByValues({
    String sntpAddress,
    bool isEnable,
    int timezone,
  }) {
    final result = List<int>();

    result.addAll(utf8.encode(sntpAddress));
    result.addAll(
        result.addZero(_ADDRESS_LENGTH - utf8.encode(sntpAddress).length));
    result.add(timezone * -1);
    result.add(
        int.parse((isEnable == true ? 1 : 0).toRadixString(2).padLeft(8, "0")));
    result.addAll(0.toBytes(2));

    return result;
  }

  List<int> toBytes() {
    final result = List<int>();

    result.addAll(utf8.encode(address));
    result.addAll(res.toBytes(2));
    result.addAll(flags.toBytes(2));

    return result;
  }
}

///структура информации о добавленном устройстве
class DeviceInfo {
  int idCRC; // CRC16 реального ID добавленного устройства
  int idNet; // ID устройства внутри сети
  int type; // тип добавленного устройства

  DeviceInfo.fromBytes(List<int> bytes) {
    idCRC = bytes.sublist(0, 2).fromBytes();
    idNet = bytes[2];
    type = bytes[3];
  }

  List<int> toBytes() {
    final result = List<int>();

    result.addAll(idCRC.toBytes(2));
    result.add(idNet);
    result.add(type);

    return result;
  }
}

///структура информации о считаном пользователе
class UserInfo {
  int accessType;
  bool enabled;
  String login;

  UserInfo.fromBytes(List<int> bytes) {
    if (bytes.length != 32) return;

    switch (bytes[16]) {
      case 0:
        {
          enabled = false;
          accessType = 2;
          break;
        }
      case 1:
        {
          enabled = true;
          accessType = 2;
          break;
        }

      case 2:
        {
          enabled = false;
          accessType = 1;
          break;
        }

      case 3:
        {
          enabled = true;
          accessType = 1;
          break;
        }
    }

    List<int> loginBytes = bytes.sublist(0, 16);

    loginBytes.indexOf(0);

    login = utf8.decode(bytes.sublist(0, loginBytes.indexOf(0)));
  }
}

///структура информации о группе
class GroupInfo {
  int groupId; // id группы

  GroupInfo.fromBytes(List<int> bytes) {
    if (bytes.length == 0) {
      return;
    }

    groupId = bytes.sublist(0, 2).fromBytes();
  }

  GroupInfo(this.groupId);

  List<int> toBytes() {
    final result = List<int>();

    result.addAll(groupId.toBytes(2));

    return result;
  }
}

///конфигурирования данных о времени на устройстве
class DeviceTimeConfig {
  int move; // время подачи напряжения на мотора/нагрузку
  int autoClose; // время, через которое роллета начнет закрываться

  DeviceTimeConfig.fromBytes(List<int> bytes) {
    if (bytes.length == 0) {
      return;
    }
    move = bytes.sublist(0, 2).fromBytes();

    if (bytes.length == 2) {
      return;
    }

    autoClose = bytes.sublist(2, 4).fromBytes();
  }

  List<int> toBytes() {
    final result = List<int>();

    result.addAll(move.toBytes(2));
    result.addAll(autoClose.toBytes(2));

    return result;
  }
}

///конфигурирования данных о работе на устройстве
class DeviceWorkConfig {
  int move;

  DeviceWorkConfig.fromBytes(List<int> bytes) {
    if (bytes.length == 0) {
      return;
    }
    move = bytes.sublist(0, 1).fromBytes();
  }

  List<int> toBytes() {
    final result = List<int>();

    result.addAll(move.toBytes(2));

    return result;
  }
}

/// флаги, влияющие на режим работы прибора. Флаг два бита -> b1x - флаг не меняется
class DeviceFlagsConfig {
  int limSmlt; //вкл/выкл симуляция концевиков
  int limOff; //вкл/выкл концевиков
  int reverse; //реверс - направления движения
  int reserved;

  DeviceFlagsConfig.fromBytes(List<int> bytes) {
    final firstByte = bytes[0].toRadixString(2).padLeft(8, "0");
    final secondByte = bytes[1].toRadixString(2).padLeft(8, "0");

    limSmlt = int.parse(firstByte.substring(0, 2), radix: 2);
    limOff = int.parse(firstByte.substring(2, 4), radix: 2);
    reverse = int.parse(firstByte.substring(4, 6), radix: 2);
    reserved = int.parse(firstByte.substring(6, 8) + secondByte, radix: 2);
  }

  List<int> toBytes() {
    final result = List<int>();

    final limSmltBits = limSmlt.toRadixString(2).padLeft(8, "0").substring(6);
    final limOffBits = limOff.toRadixString(2).padLeft(8, "0").substring(6);
    final reverseBits = reverse.toRadixString(2).padLeft(8, "0").substring(6);
    final reservedBits =
        reserved.toRadixString(2).padLeft(16, "0").substring(6, 8);

    result.add(int.parse(limSmltBits + limOffBits + reverseBits + reservedBits,
        radix: 2));
    result.add(reserved & 0xff);

    return result;
  }
}

///выбор типа работы устройства
class DeviceModeConfig {
  int work; // режим работы прибора
  int sens; // режим обработки сигналов с сенсоров, подключенных к прибору
  int trnscd; // режим транскодирования
  int chanel; // номер частотного канала прибора
  DeviceFlagsConfig flags; // флаги, влияющие на режим работы прибора

  DeviceModeConfig.fromBytes(List<int> bytes) {
    final firstByte = bytes[0].toRadixString(2).padLeft(8, "0");
    final secondByte = bytes[1].toRadixString(2).padLeft(8, "0");

    work = int.parse(firstByte.substring(0, 4), radix: 2);
    sens = int.parse(firstByte.substring(4, 8), radix: 2);
    trnscd = int.parse(secondByte.substring(0, 3), radix: 2);
    chanel = int.parse(secondByte.substring(3, 8), radix: 2);

    flags = DeviceFlagsConfig.fromBytes(bytes.sublist(2, 4));
  }

  List<int> toBytes() {
    final result = List<int>();

    final workBits = work.toRadixString(2).padLeft(8, "0").substring(4);
    final sensBits = sens.toRadixString(2).padLeft(8, "0").substring(4);
    final trnscdBits = trnscd.toRadixString(2).padLeft(8, "0").substring(5);
    final chanelBits = chanel.toRadixString(2).padLeft(8, "0").substring(3);

    result.add(int.parse(workBits + sensBits, radix: 2));
    result.add(int.parse(trnscdBits + chanelBits, radix: 2));

    result.addAll(flags.toBytes());

    return result;
  }
}

/// данные для команды типа PRMTRS_SET MODES_1
class DeviceMode1Config {
  int work; // режим работы прибора
  int sens; // режим обработки сигналов с сенсоров, подключенных к прибору
  DeviceFlagsConfig flags; // флаги, влияющие на режим работы прибора

  DeviceMode1Config.fromBytes(List<int> bytes) {
    final firstByte = bytes[0].toRadixString(2).padLeft(8, "0");

    work = int.parse(firstByte.substring(0, 4), radix: 2);
    sens = int.parse(firstByte.substring(4, 8), radix: 2);

    flags = DeviceFlagsConfig.fromBytes(bytes.sublist(1, 3));
  }

  List<int> toBytes() {
    final result = List<int>();

    final workBits = work.toRadixString(2).padLeft(8, "0").substring(4);
    final sensBits = sens.toRadixString(2).padLeft(8, "0").substring(4);

    result.add(int.parse(workBits + sensBits, radix: 2));

    result.addAll(flags.toBytes());

    return result;
  }
}

/// данные для команды типа PRMTRS_SET MODES_2
class DeviceMode2Config {
  int trnscd; // режим транскодирования
  int chanel; // номер частотного канала прибора

  DeviceMode2Config.fromBytes(List<int> bytes) {
    final firstByte = bytes[0].toRadixString(2).padLeft(8, "0");

    trnscd = int.parse(firstByte.substring(0, 3), radix: 2);
    chanel = int.parse(firstByte.substring(3, 8), radix: 2);
  }

  List<int> toBytes() {
    final result = List<int>();

    final trnscdBits = trnscd.toRadixString(2).padLeft(8, "0").substring(5);
    final chanelBits = chanel.toRadixString(2).padLeft(8, "0").substring(3);

    result.add(int.parse(trnscdBits + chanelBits, radix: 2));

    return result;
  }
}

class BaseUserConfig {
  List<int> addZerosToStruct(int count) {
    List<int> additionalZeros = [];

    for (int position = 0; position < count; position++) {
      additionalZeros.add(0);
    }

    return additionalZeros;
  }
}

class AuthConfig extends BaseUserConfig {
  String login;
  List<int> passwordHash;

  AuthConfig(this.login, this.passwordHash);

  List<int> toBytes() {
    List<int> result = [];

    result.addAll(utf8.encode(login));

    if (16 - result.length > 0) {
      result.addAll(addZerosToStruct(16 - result.length));
    }

    result.addAll(passwordHash);

    return result;
  }
}

class CreateEditUserConfig extends BaseUserConfig {
  String login;
  String password;
  int accessType;
  bool enabled;
  String newLogin;

  CreateEditUserConfig(this.login, this.password, this.accessType, this.enabled,
      {this.newLogin = ""});

  List<int> toBytesForCreateUser() {
    List<int> result = [];

    List<int> loginInBites = utf8.encode(login);
    result.addAll(loginInBites);
    if (16 - loginInBites.length > 0) {
      result.addAll(addZerosToStruct(16 - loginInBites.length));
    }

    result.addAll(buildPartOfPayloadAccessType());
    if (password.isEmpty) {
      result.addAll(addZerosToStruct(16));
    } else {
      result.addAll(sha256
          .convert(utf8.encode(password))
          .bytes
          .sublist(0, 16)); //password in sha256, first 16 items
    }

    result.addAll(addZerosToStruct(16));

    return result;
  }

  List<int> toBytesForEditUser() {
    List<int> result = [];

    result.addAll(toBytesForCreateUser());

    List<int> newLoginInBites = utf8.encode(newLogin);
    result.addAll(newLoginInBites);
    if (16 - newLoginInBites.length > 0) {
      result.addAll(addZerosToStruct(16 - newLoginInBites.length));
    }

    return result;
  }

  List<int> buildPartOfPayloadAccessType() {
    List<int> result = [];
    if (accessType == 2 && !enabled) {
      result.add(0);
    }

    if (accessType == 2 && enabled) {
      result.add(1);
    }

    if (accessType == 1 && !enabled) {
      result.add(2);
    }

    if (accessType == 1 && enabled) {
      result.add(3);
    }

    result.addAll(addZerosToStruct(15));

    return result;
  }
}

class UserConfig extends BaseUserConfig {
  String login;

  UserConfig(this.login);

  List<int> toBytes() {
    List<int> result = [];

    result.addAll(utf8.encode(login));

    if (16 - result.length > 0) {
      result.addAll(addZerosToStruct(16 - result.length));
    }

    return result;
  }
}

///данные о текущем состоянии девайса (после выполнения какой-либо команды)
class DeviceControlConfig {
  int curPosPercents; // 0..200, что соответствует 0..100%, с шагом 0.5%, 0xFF - положение не известно
  int unitTime; // 0 - 100мс, 1 - секунда, 2 - минута, 3 - часы
  int direction; // 1 - UP/ON, 0 - DOWN/OFF
  int res;
  int timeExe; // время выполнения команды, зависит от unitTime

  DeviceControlConfig.fromBytes(List<int> bytes) {
    final secondByte = bytes[1].toRadixString(2).padLeft(8, "0");

    curPosPercents = bytes[0];
//    print("second byte = $secondByte");
    unitTime = int.parse(
        secondByte.substring(secondByte.length - 2, secondByte.length),
        radix: 2);
    direction = int.parse(
        secondByte.substring(secondByte.length - 3, secondByte.length - 2),
        radix: 2);
    res = int.parse(secondByte.substring(0, 5), radix: 2);
    timeExe = bytes.sublist(2, 4).fromBytes();
  }

  List<int> toBytes() {
    final result = List<int>();

    result.add(curPosPercents);

    final unitTimeBits = unitTime.toRadixString(2).padLeft(8, "0").substring(6);
    final directionBits =
        direction.toRadixString(2).padLeft(8, "0").substring(7);
    final resBits = res.toRadixString(2).padLeft(8, "0").substring(3);

    result.add(int.parse(unitTimeBits + directionBits + resBits, radix: 2));

    result.addAll(timeExe.toBytes(2));

    return result;
  }

  @override
  String toString() {
    return 'DeviceControlConfig{curPos: $curPosPercents, unitTime: $unitTime, direction: $direction, res: $res, timeExe: $timeExe}';
  }
}

///данные для команды типа PRMTRS_SET ACTION
class DeviceActionConfig {
  int type; // тип действия ( gotoMode, setChanel, test и т.д. )
  int code; // код действия ( modeWork, modePrg, ..., chanel_0, chanel_1, ..., testOnRedLed, ...)

  DeviceActionConfig.fromBytes(List<int> bytes) {
    final firstByte = bytes[0].toRadixString(2).padLeft(8, "0");

    type = int.parse(firstByte.substring(0, 3), radix: 2);
    code = int.parse(firstByte.substring(3, 8), radix: 2);
  }

  List<int> toBytes() {
    final result = List<int>();

    final typeBits = type.toRadixString(2).padLeft(8, "0").substring(5);
    final codeBits = code.toRadixString(2).padLeft(8, "0").substring(3);

    result.add(int.parse(typeBits + codeBits, radix: 2));

    return result;
  }
}

///версия прошивки (ESP, modem, device)
class UpdateProd {
  int id;
  int swVer;
  int rev;
  int hwVer;

  UpdateProd.fromBytes(List<int> bytes) {
    id = bytes[0];
    swVer = bytes[1];
    rev = bytes[2];
    hwVer = bytes[3];
  }

  List<int> toBytes() {
    final result = List<int>();

    result.add(id);
    result.add(swVer);
    result.add(rev);
    result.add(hwVer);

    return result;
  }
}

///информация для передачи при обновлении девайса
class UpdateInfo {
  int crc32;
  int size;
  UpdateProd prod;
  List<int> res;
  int blockSize;

  UpdateInfo.fromBytes(List<int> bytes) {
    crc32 = bytes.takeAndRemove(4).fromBytes();
    size = bytes.takeAndRemove(4).fromBytes();
    prod = UpdateProd.fromBytes(bytes.takeAndRemove(4));
    res = bytes.sublist(0, bytes.length - 2);
    blockSize = bytes.sublist(bytes.length - 2).fromBytes();
  }

  List<int> toBytes() {
    final result = List<int>();

    result.add(crc32);
    result.add(size);
    result.addAll(prod.toBytes());
    result.addAll(res);
    result.addAll(blockSize.toBytes(2));

    return result;
  }
}

///заголовок для обновления файла
class UpdateFileHeader {
  int id;
  UpdateInfo info;

  UpdateFileHeader.fromBytes(List<int> bytes) {
    id = bytes[0];
    info = UpdateInfo.fromBytes(bytes.sublist(1));
  }

  List<int> toBytes() {
    final result = List<int>();

    result.add(id);
    result.addAll(info.toBytes());

    return result;
  }
}

class UpdateBlockHeader {
  int addr;
  int size;

  UpdateBlockHeader.fromBytes(List<int> bytes) {
    addr = bytes.sublist(0, 4).fromBytes();
    addr = bytes.sublist(4, 8).fromBytes();
  }

  List<int> toBytes() {
    final result = List<int>();

    result.addAll(addr.toBytes(4));
    result.addAll(size.toBytes(4));

    return result;
  }
}

///ответ от модема о его версии
class ModemVersionAnswer {
  UpdateProd prod;
  int startAddr;

  ModemVersionAnswer.fromBytes(List<int> bytes) {
    if (bytes.length < 8) {
      prod = UpdateProd.fromBytes([0, 0, 0, 0]);
      startAddr = [0, 0, 0, 0].fromBytes();
      return;
    }
    prod = UpdateProd.fromBytes(bytes.sublist(0, 4));
    startAddr = bytes.sublist(4, 8).fromBytes();
  }

  List<int> toBytes() {
    final result = List<int>();

    result.addAll(prod.toBytes());
    result.addAll(startAddr.toBytes(4));

    return result;
  }
}

class ModemUpdateStatus {
  ModemUpdateStageStatus state;
  int progress = -1;
  int timeLeft = -1;

  ModemUpdateStatus.fromBytes(List<int> bytes) {
    if (bytes.length == 1) {
      state = getModemStageStatusByByte(bytes[0]);
//      state = bytes[1];
    }
    if (bytes.length == 2) {
      state = getModemStageStatusByByte(bytes[0]);
//      state = bytes[1];
      progress = bytes[1];
    }
    if (bytes.length == 4) {
      state = getModemStageStatusByByte(bytes[0]);
//      state = bytes[1];
      progress = bytes[1];
      timeLeft = bytes.sublist(2, 4).fromBytes();
    }
  }

  ModemUpdateStageStatus getModemStageStatusByByte(int byte) {
    ModemUpdateStageStatus status;
    ModemUpdateStageStatus.values.forEach((st) {
      if (st.value == byte) {
        status = st;
        return true;
      } else {
        return false;
      }
    });
    return status;
  }
}

class ModemUpdateStageStatus {
  static const ModemUpdateStageStatus UPDATER_IDLE =
      const ModemUpdateStageStatus._(0);
  static const ModemUpdateStageStatus UPDATER_TRIGGER =
      const ModemUpdateStageStatus._(1);
  static const ModemUpdateStageStatus UPDATER_WAIT_VERSION =
      const ModemUpdateStageStatus._(2);
  static const ModemUpdateStageStatus UPDATER_FEATCH_DB =
      const ModemUpdateStageStatus._(3);
  static const ModemUpdateStageStatus UPDATER_DOWNLOAD_DB =
      const ModemUpdateStageStatus._(4);
  static const ModemUpdateStageStatus UPDATER_CHECK =
      const ModemUpdateStageStatus._(5);
  static const ModemUpdateStageStatus UPDATER_FEATCH_FIRMWARE =
      const ModemUpdateStageStatus._(6);
  static const ModemUpdateStageStatus UPDATER_DOWNLOAD_FIRMWARE =
      const ModemUpdateStageStatus._(7);
  static const ModemUpdateStageStatus UPDATER_INIT =
      const ModemUpdateStageStatus._(8);
  static const ModemUpdateStageStatus UPDATER_DATA =
      const ModemUpdateStageStatus._(9);
  static const ModemUpdateStageStatus UPDATER_APPLY =
      const ModemUpdateStageStatus._(10);
  static const ModemUpdateStageStatus UPDATER_WAIT_REBOOT =
      const ModemUpdateStageStatus._(11);
  static const ModemUpdateStageStatus UPDATER_DONE =
      const ModemUpdateStageStatus._(12);
  static const ModemUpdateStageStatus UPDATER_ERR =
      const ModemUpdateStageStatus._(13);
  static const ModemUpdateStageStatus UPDATER_CANCELLED =
      const ModemUpdateStageStatus._(14);

  final value;

  static const values = [
    UPDATER_IDLE,
    UPDATER_TRIGGER,
    UPDATER_WAIT_VERSION,
    UPDATER_FEATCH_DB,
    UPDATER_DOWNLOAD_DB,
    UPDATER_CHECK,
    UPDATER_FEATCH_FIRMWARE,
    UPDATER_DOWNLOAD_FIRMWARE,
    UPDATER_INIT,
    UPDATER_DATA,
    UPDATER_APPLY,
    UPDATER_WAIT_REBOOT,
    UPDATER_DONE,
    UPDATER_ERR,
    UPDATER_CANCELLED
  ];

  const ModemUpdateStageStatus._(this.value);

  @override
  List<Object> get props => [value];

  @override
  String toString() {
    if (value == UPDATER_IDLE.value) {
      return "UPDATER_IDLE";
    } else if (value == UPDATER_TRIGGER.value) {
      return "UPDATER_TRIGGER";
    } else if (value == UPDATER_WAIT_VERSION.value) {
      return "UPDATER_WAIT_VERSION";
    } else if (value == UPDATER_FEATCH_DB.value) {
      return "UPDATER_FEATCH_DB";
    } else if (value == UPDATER_DOWNLOAD_DB.value) {
      return "UPDATER_DOWNLOAD_DB";
    } else if (value == UPDATER_CHECK.value) {
      return "UPDATER_CHECK";
    } else if (value == UPDATER_FEATCH_FIRMWARE.value) {
      return "UPDATER_FEATCH_FIRMWARE";
    } else if (value == UPDATER_FEATCH_FIRMWARE.value) {
      return "UPDATER_FEATCH_FIRMWARE";
    } else if (value == UPDATER_DOWNLOAD_FIRMWARE.value) {
      return "UPDATER_DOWNLOAD_FIRMWARE";
    } else if (value == UPDATER_INIT.value) {
      return "UPDATER_INIT";
    } else if (value == UPDATER_DATA.value) {
      return "UPDATER_DATA";
    } else if (value == UPDATER_WAIT_REBOOT.value) {
      return "UPDATER_WAIT_REBOOT";
    } else if (value == UPDATER_DONE.value) {
      return "UPDATER_DONE";
    } else if (value == UPDATER_ERR.value) {
      return "UPDATER_ERR";
    } else if (value == UPDATER_CANCELLED.value) {
      return "UPDATER_CANCELLED";
    }

    return "$runtimeType ${value.toString()}";
  }
}

class TimerInfo {
  DeviceInfo deviceInfo;
  GroupInfo groupInfo;
  TimeInfo timeInfo;
  int command;
  int channel;
  int pos;
  TimeFlags timeFlags;
  int res;
  int tId;

  TimerInfo.fromBytes(List<int> bytes) {
    var deviceBytes = bytes.takeAndRemove(4);

    if (deviceBytes[2] == 0 && deviceBytes[3] == 0) {
      deviceInfo = null;
      List<int> list = List();
      list.add(deviceBytes[0]);
      list.add(deviceBytes[1]);
      groupInfo = GroupInfo.fromBytes(list);
    } else {
      deviceInfo = DeviceInfo.fromBytes(deviceBytes);
      groupInfo = null;
    }

    timeInfo = TimeInfo.fromBytes(bytes.takeAndRemove(4));
    command = bytes[0];
    channel = bytes[1];
    pos = bytes[2];
//    timeFlags = TimeFlags.fromBytes(bytes.sublist(3, 6));
    timeFlags = TimeFlags.fromBytes(bytes[3]);
    tId = bytes.sublist(4, 6).fromBytes();
    res = bytes.sublist(6, 8).fromBytes();
  }

  List<int> toBytes() {
    final result = List<int>();

    result.addAll(deviceInfo.toBytes());
    result.addAll(timeInfo.toBytes());
    result.add(command);
    result.add(channel);
    result.add(pos);
    result.addAll(timeFlags.toBytes());
    result.addAll(tId.toBytes(2));
    result.addAll(res.toBytes(2));

    return result;
  }
}

class TimeInfo {
  int hour;
  int minute;
  int second;
  int days;

  TimeInfo.fromBytes(List<int> bytes) {
    hour = bytes[0];
    minute = bytes[1];
    second = bytes[2];
    days = bytes[3];
  }

  List<int> toBytes() {
    final result = List<int>();

    result.add(hour);
    result.add(minute);
    result.add(second);
    result.add(days);

    return result;
  }
}

class TimeFlags {
  bool isActive;
  bool isGroup;
  int res;

  TimeFlags.fromBytes(int bytes) {
//    if(bytes == 0) {
//      isActive = false;
//    } else {
//      isActive = true;
//    }

    final byte = bytes.toRadixString(2).padLeft(8, "0");

    res = int.parse(byte.substring(0, 6), radix: 2);
    isGroup = int.parse(byte.substring(6, 7), radix: 2) == 1;
    isActive = int.parse(byte.substring(7, 8), radix: 2) == 1;
  }

  static int toByteByValues(bool isActive, bool isGroup) {
//    if (isActive) {
//      result.add(1);
//    } else {
//      result.add(0);
//    }

    var isActiveValue = (isActive) ? 1 : 0;
    var isGroupValue = (isGroup) ? 1 : 0;

    final resBits = 0.toRadixString(2).padLeft(8, "0").substring(2);
    final isGroupBits =
        isGroupValue.toRadixString(2).padLeft(8, "0").substring(7);
    final isActiveBits =
        isActiveValue.toRadixString(2).padLeft(8, "0").substring(7);

    return int.parse(resBits + isGroupBits + isActiveBits, radix: 2);
  }

  List<int> toBytes() {
    final result = List<int>();

//    if (isActive) {
//      result.add(1);
//    } else {
//      result.add(0);
//    }

    var isActiveValue = (isActive) ? 1 : 0;
    var isGroupValue = (isGroup) ? 1 : 0;

    final resBits = res.toRadixString(2).padLeft(8, "0").substring(2);
    final isGroupBits =
        isGroupValue.toRadixString(2).padLeft(8, "0").substring(7);
    final isActiveBits =
        isActiveValue.toRadixString(2).padLeft(8, "0").substring(7);

    result.add(int.parse(resBits + isGroupBits + isActiveBits, radix: 2));

    return result;
  }
}

class RtcTime {
  int hour;
  int min;
  int sec;
  int ms;

  RtcTime.fromBytes(List<int> bytes) {
    hour = bytes[0];
    min = bytes[1];
    sec = bytes[2];
    ms = bytes[3];
  }

  List<int> toBytes() {
    final result = List<int>();

    result.add(hour);
    result.add(min);
    result.add(sec);
    result.add(ms);

    return result;
  }
}

class RtcDate {
  int day;
  int month;
  int year;
  int weekDay;

  RtcDate.fromBytes(List<int> bytes) {
    day = bytes[0];
    month = bytes[1];
    year = bytes[2];
    weekDay = bytes[3];
  }

  List<int> toBytes() {
    final result = List<int>();

    result.add(day);
    result.add(month);
    result.add(year);
    result.add(weekDay);

    return result;
  }
}

class RtcInfo {
  RtcTime rtcTime;
  RtcDate rtcDate;

  RtcInfo.fromBytes(List<int> bytes) {
    rtcTime = RtcTime.fromBytes(bytes.takeAndRemove(4));
    rtcDate = RtcDate.fromBytes(bytes.takeAndRemove(4));
  }

  List<int> toBytes() {
    final result = List<int>();

    result.addAll(rtcTime.toBytes());
    result.addAll(rtcDate.toBytes());

    return result;
  }

  static List<int> toBytesByDateTime(DateTime dateTime) {
    final result = List<int>();
    result.add(dateTime.hour);
    result.add(dateTime.minute);
    result.add(dateTime.second);
    result.add(0);
    result.add(dateTime.day);
    result.add(dateTime.month);
    result.add(dateTime.year - 2000);
    result.add(dateTime.weekday);

    return result;
  }
}

class RcInfo {
  int idCrc;
  int idRc;
  int type;
  int fb;

  RcInfo.fromBytes(List<int> bytes) {
    idCrc = bytes.sublist(0, 2).fromBytes();
    var first = bytes[2].toRadixString(2).padLeft(8, "0");
    var second = bytes[3].toRadixString(2).padLeft(8, "0");
    var allBytes = "$second$first";
    fb = int.parse(allBytes.substring(0, 1), radix: 2);
    type = int.parse(allBytes.substring(1, 5), radix: 2);
    idRc = int.parse(allBytes.substring(5, 16), radix: 2);
  }

  List<int> toBytes() {
    final result = List<int>();

    final fbBits = fb.toRadixString(2).padLeft(8, "0").substring(7);
    final typeBits = type.toRadixString(2).padLeft(8, "0").substring(4);
    final idRcBits = idRc.toRadixString(2).padLeft(8, "0");

    result.addAll(idCrc.toBytes(2));
    result.add(int.parse(idRcBits, radix: 2));
    result.add(int.parse(fbBits + typeBits + "000", radix: 2));

    return result;
  }
}

class RcButtonInfo {
  int slotGr; // :4 слот, назначенные для ответа на групповую команду (для пультов с ОС)
  int slotRc; // :7 слот, назначенный для ответа на команду с общей группой (для пультов с ОС)
  int noFb; // :1 в режиме с ОС (1 - ОС отключена)
  int maskChannelLoad; // :4 маска канала нагрузки, для многоканальных устройств (8117_NB)

  int typeGroupFB; // :3 тип группы, по виду обратной связи (не сообщать, сообщение о локальном управлении, сообщение в слоте ID_NET, сообщение в назначенном слоте, ...)
  int cmdAssign; // :4 код, назначенной команды (0xF - команда из пакета)
  int typeRc; // :4 тип пульта rc_type_e
  int reserved; // :2
  int verRecord; // : 3 0xF - запись в старом формате, сделанная самим ИУ, 1 - запись, сделанная модемом

  RcButtonInfo.fromBytes(List<int> bytes) {
    StringBuffer bytesStr = StringBuffer();
    bytes.reversed.forEach((element) {
      bytesStr.write(element.toRadixString(2).padLeft(8, "0"));
    });
    var allBytes = bytesStr.toString();
    print(allBytes);
    verRecord = int.parse(allBytes.substring(0, 3), radix: 2);
    reserved = int.parse(allBytes.substring(3, 5), radix: 2);
    typeRc = int.parse(allBytes.substring(5, 9), radix: 2);
    cmdAssign = int.parse(allBytes.substring(9, 13), radix: 2);
    typeGroupFB = int.parse(allBytes.substring(13, 16), radix: 2);
    maskChannelLoad = int.parse(allBytes.substring(16, 20), radix: 2);
    noFb = int.parse(allBytes.substring(20, 21), radix: 2);
    slotRc = int.parse(allBytes.substring(21, 28), radix: 2);
    slotGr = int.parse(allBytes.substring(28, 32), radix: 2);
  }

  List<int> toBytes() {
    final result = List<int>();

    return result;
  }
}

class RcPressEventInfo {
  RcInfo rcInfo;
  int group;
  int cmd;

  RcPressEventInfo.fromBytes(List<int> bytes) {
    rcInfo = RcInfo.fromBytes(bytes.takeAndRemove(4));
    group = bytes[0];
    cmd = bytes[1];
  }

  @override
  String toString() {
    return "RcPressEventInfo (rcId: ${rcInfo.idRc}, group: $group, cmd: $cmd)";
  }
}

class RcBtnDevDbInfo {
  int rcId; // :11 11-битный ID пульта
  int group; // :4 группа кнопки пульта
  int groupType; // :3 тип группы по виду ОС
  int cmd; // :4 команда назначенная на кнопку
  int channel; // :4 маска канала (для 8117)
  int res; // :6 зарезервировано

  RcBtnDevDbInfo.fromBytes(List<int> bytes) {
    StringBuffer bytesStr = StringBuffer();
    bytes.reversed.forEach((element) {
      bytesStr.write(element.toRadixString(2).padLeft(8, "0"));
    });
    var allBytes = bytesStr.toString();
    print(allBytes);
    res = int.parse(allBytes.substring(0, 6), radix: 2);
    channel = int.parse(allBytes.substring(6, 10), radix: 2);
    cmd = int.parse(allBytes.substring(10, 14), radix: 2);
    groupType = int.parse(allBytes.substring(14, 17), radix: 2);
    group = int.parse(allBytes.substring(17, 21), radix: 2);
    rcId = int.parse(allBytes.substring(21, 32), radix: 2);
  }

  List<int> toBytes() {
    final result = List<int>();

    return result;
  }

  @override
  String toString() {
    return "RcBtnDevDb (rcId: $rcId, group: $group, cmd: $cmd, groupType: $groupType, channel: $channel)";
  }
}

class RcFromDeviceInfo {
  int group;
  RcInfo rcModel;
  RcButtonInfo rcButtonInfo;

  RcFromDeviceInfo.fromBytes(List<int> bytes) {
    group = bytes[0];
    rcModel = RcInfo.fromBytes(bytes.sublist(1, 5));
    rcButtonInfo = RcButtonInfo.fromBytes(bytes.sublist(5, 9));
  }

  List<int> toBytes() {
    final result = List<int>();

    return result;
  }
}

extension HelpfullListExtensions on List<int> {
  List<int> takeAndRemove(int count) {
    final result = this.take(count).toList();

    this.removeRange(0, count);

    return result;
  }

  int fromBytes() {
    var result = 0;

    for (int i = this.length - 1; i >= 0; i--) result += this[i] << (8 * i);

    return result;
  }
}

extension ToBytes on int {
  List<int> toBytes(int bytesCount) {
    final result = List<int>();

    for (int i = 0; i < bytesCount; i++) result.add((this >> (8 * i)) & 0xff);

    return result;
  }
}

extension AddZero on List<int> {
  List<int> addZero(int count) {
    final result = List<int>();

    for (int i = 0; i < count; i++) result.add(0);

    return result;
  }
}

extension DeleteZeros on List<int> {
  List<int> deleteZeros() {
    this.removeWhere((elem) => elem == 0);
    return this;
  }
}
