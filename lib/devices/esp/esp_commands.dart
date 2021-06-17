import 'package:equatable/equatable.dart';
import 'package:rcd_s/devices/commands.dart';

class PackageType {
  static const PackageType PKG_TYPE_MODEM = const PackageType._(0);
  static const PackageType PKG_TYPE_ESP = const PackageType._(1);

  final _value;

  const PackageType._(this._value);
}

class EspCmd extends Equatable with EspCommand {
  static const EspCmd ESP_ECHO = const EspCmd._(0);
  static const EspCmd ESP_BOOT_INIT = const EspCmd._(0x1101);
  static const EspCmd ESP_BOOT_DATA = const EspCmd._(0x1102);
  static const EspCmd ESP_BOOT_APPLY = const EspCmd._(0x1103);
  static const EspCmd ESP_REBOOT = const EspCmd._(0x1104);
  static const EspCmd ESP_VERSION_INFO = const EspCmd._(0x1105);

  static const EspCmd ESP_CONFIG_CLOUD = const EspCmd._(0x1201);
  static const EspCmd ESP_CONFIG_STA = const EspCmd._(0x1202);
  static const EspCmd ESP_CONFIG_AP = const EspCmd._(0x1203);
  static const EspCmd ESP_CONFIG_SNTP = const EspCmd._(0x1204);
  static const EspCmd ESP_CONFIG_UPDATE = const EspCmd._(0x1205);

  static const EspCmd ESP_RESET_CONFIG = const EspCmd._(0x1301);
  static const EspCmd ESP_MQTT_P2P = const EspCmd._(0x1302);
  static const EspCmd ESP_ED_CMD = const EspCmd._(0x1303);
  static const EspCmd ESP_GET_RSSI = const EspCmd._(0x1304);
  static const EspCmd ESP_UPDATE_STATUS = const EspCmd._(0x1305);
  static const EspCmd ESP_CLOCK = const EspCmd._(0x130a);

  static const EspCmd ESP_UPDATE = const EspCmd._(0x1401);
  static const EspCmd ESP_UPDATE_CHECK = const EspCmd._(0x1402);
  static const EspCmd ESP_UPDATE_STOP = const EspCmd._(0x1403);
  static const EspCmd EVENT_DEV_STATE = const EspCmd._(0xb002);
  static const EspCmd ESP_ACL =
      const EspCmd._(0x1603); //прочитать количество пользователей
  static const EspCmd ESP_MAC =
      const EspCmd._(0x1308); //прочитать MAC устройства

  final value;

  static const values = [
    ESP_ECHO,
    ESP_BOOT_INIT,
    ESP_BOOT_DATA,
    ESP_BOOT_APPLY,
    ESP_REBOOT,
    ESP_VERSION_INFO,
    ESP_CONFIG_CLOUD,
    ESP_CONFIG_STA,
    ESP_CONFIG_AP,
    ESP_CONFIG_SNTP,
    ESP_CONFIG_UPDATE,
    ESP_RESET_CONFIG,
    ESP_MQTT_P2P,
    ESP_ED_CMD,
    ESP_GET_RSSI,
    ESP_UPDATE_STATUS,
    ESP_UPDATE,
    ESP_UPDATE_CHECK,
    ESP_UPDATE_STOP,
    ESP_ACL,
    ESP_MAC
  ];

  const EspCmd._(this.value);

  @override
  List<Object> get props => [value];

  @override
  String toString() {
    if (value == ESP_ECHO.value) {
      return "ESP_ECHO";
    } else if (value == ESP_BOOT_INIT.value) {
      return "ESP_BOOT_INIT";
    } else if (value == ESP_BOOT_DATA.value) {
      return "ESP_BOOT_DATA";
    } else if (value == ESP_BOOT_APPLY.value) {
      return "ESP_BOOT_APPLY";
    } else if (value == ESP_REBOOT.value) {
      return "ESP_REBOOT";
    } else if (value == ESP_VERSION_INFO.value) {
      return "ESP_VERSION_INFO";
    } else if (value == ESP_CONFIG_CLOUD.value) {
      return "ESP_CONFIG_CLOUD";
    } else if (value == ESP_CONFIG_STA.value) {
      return "ESP_CONFIG_STA";
    } else if (value == ESP_CONFIG_AP.value) {
      return "ESP_CONFIG_AP";
    } else if (value == ESP_CONFIG_SNTP.value) {
      return "ESP_CONFIG_SNTP";
    } else if (value == ESP_CONFIG_UPDATE.value) {
      return "ESP_CONFIG_UPDATE";
    } else if (value == ESP_RESET_CONFIG.value) {
      return "ESP_RESET_CONFIG";
    } else if (value == ESP_MQTT_P2P.value) {
      return "ESP_MQTT_P2P";
    } else if (value == ESP_ED_CMD.value) {
      return "ESP_ED_CMD";
    } else if (value == ESP_GET_RSSI.value) {
      return "ESP_GET_RSSI";
    } else if (value == ESP_UPDATE_STATUS.value) {
      return "ESP_UPDATE_STATUS";
    } else if (value == ESP_UPDATE.value) {
      return "ESP_UPDATE";
    } else if (value == ESP_UPDATE_CHECK.value) {
      return "ESP_UPDATE_CHECK";
    } else if (value == ESP_UPDATE_STOP.value) {
      return "ESP_UPDATE_STOP";
    } else if (value == ESP_ACL.value) {
      return "ESP_ACL";
    } else if (value == ESP_MAC.value) {
      return "ESP_MAC";
    }

    return "$runtimeType ${value.toString()}";
  }
}

class EspErrors extends Equatable {
  static const EspErrors ST_OK = const EspErrors._(0);
  static const EspErrors ST_BAD_CMD = const EspErrors._(1);
  static const EspErrors ST_BAD_CRC = const EspErrors._(2);
  static const EspErrors ST_BAD_ACCESS_TYPE = const EspErrors._(3);
  static const EspErrors ST_BAD_PAYLOAD_SIZE = const EspErrors._(4);
  static const EspErrors ST_BAD_PARAM = const EspErrors._(5);
  static const EspErrors ST_QUEUE_TIMEOUT = const EspErrors._(6);
  static const EspErrors ST_QUEUE_OVF = const EspErrors._(7);
  static const EspErrors ST_PROC_ERR = const EspErrors._(8);
  static const EspErrors ST_BAD_PROTO_VER = const EspErrors._(9);
  static const EspErrors ST_ALREADY_IN_QUEUE = const EspErrors._(10);
  static const EspErrors ST_DEPRECATED = const EspErrors._(11);
  static const EspErrors ST_MODEM_ERR = const EspErrors._(12);
  static const EspErrors ST_MAX = const EspErrors._(13);

  final value;

  static const values = [
    ST_OK,
    ST_BAD_CMD,
    ST_BAD_CRC,
    ST_BAD_ACCESS_TYPE,
    ST_BAD_PAYLOAD_SIZE,
    ST_BAD_PARAM,
    ST_QUEUE_TIMEOUT,
    ST_QUEUE_OVF,
    ST_PROC_ERR,
    ST_BAD_PROTO_VER,
    ST_ALREADY_IN_QUEUE,
    ST_DEPRECATED,
    ST_MODEM_ERR,
    ST_MAX
  ];

  const EspErrors._(this.value);

  @override
  List<Object> get props => [value];
}

class Errors extends Equatable {
  static const Errors ERROR_EXIST = const Errors._(-109);
  static const Errors ERROR_QUEUE_TIMEOUT = const Errors._(-122);
  static const Errors ERROR__BAD_ACCESS_TYPE = const Errors._(-125);
  static const Errors ERROR_ST_BAD_CMD = const Errors._(-127);
  static const Errors ERROR_ASK_TIMEOUT = const Errors._(0);
  static const Errors ERROR_DEV_CMD_NOT_SUPPORTED = const Errors._(3);
  static const Errors ERROR_DEV_TIMEOUT = const Errors._(31);
  static const Errors ERROR_MODEM_CMD_BUSY = const Errors._(38);
  static const Errors ERROR_UNKNOWN = const Errors._(41);
  static const Errors ERROR_GROUP_DEV_EXIST = const Errors._(43);
  static const Errors ERROR_ST_PROC = const Errors._(-120);
  static const Errors ERROR_DEV_RCRD_NOT_FOUND = const Errors._(6);
  static const Errors ERROR_GROUP_NOT_EMPTY = const Errors._(47);

  final _subCmdValue;
  final _cmd = 128;

  static const values = [
    ERROR_DEV_TIMEOUT,
    ERROR_MODEM_CMD_BUSY,
    ERROR_UNKNOWN,
    ERROR_ASK_TIMEOUT,
    ERROR_EXIST,
    ERROR__BAD_ACCESS_TYPE,
    ERROR_GROUP_DEV_EXIST,
    ERROR_GROUP_NOT_EMPTY
  ];

  const Errors._(this._subCmdValue);

  @override
  List<Object> get props => [value];

  int get value => _subCmdValue + _cmd;

  @override
  String toString() {
    if (value == Errors.ERROR_DEV_TIMEOUT.value) {
      return "ERROR_DEV_TIMEOUT";
    } else if (value == Errors.ERROR_MODEM_CMD_BUSY.value) {
      return "ERROR_MODEM_CMD_BUSY";
    } else if (value == Errors.ERROR_DEV_CMD_NOT_SUPPORTED.value) {
      return "ERROR_DEV_CMD_NOT_SUPPORTED";
    } else if (value == Errors.ERROR_UNKNOWN.value) {
      return "ERROR_UNKNOWN";
    } else if (value == Errors.ERROR_ASK_TIMEOUT.value) {
      return "ERROR_ASK_TIMEOUT";
    } else if (value == Errors.ERROR_EXIST.value) {
      return "ERROR_EXIST";
    } else if (value == Errors.ERROR__BAD_ACCESS_TYPE.value) {
      return "ERROR__BAD_ACCESS_TYPE";
    } else if (value == Errors.ERROR_GROUP_DEV_EXIST.value) {
      return "ERROR_GROUP_DEV_EXIST";
    } else if (value == Errors.ERROR_GROUP_NOT_EMPTY.value) {
      return "ERROR_GROUP_NOT_EMPTY";
    }

    return "$runtimeType ${_subCmdValue.toString()}";
  }
}

const ESP_WR_FLAG = 128;

class EspEventsState extends Equatable {
  static const EspEventsState EVENT_ESP_UPDATER_VERSION =
      const EspEventsState._(0x9082);
  static const EspEventsState EVENT_ESP_UPDATER =
      const EspEventsState._(0x9081);
  static const EspEventsState EVENT_SNIFFER = const EspEventsState._(0xa005);

  final value;

  static const values = [
    EVENT_ESP_UPDATER_VERSION,
    EVENT_ESP_UPDATER,
    EVENT_SNIFFER
  ];

  const EspEventsState._(this.value);

  @override
  List<Object> get props => [value];
}
