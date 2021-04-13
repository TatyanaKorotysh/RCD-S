import 'package:equatable/equatable.dart';

abstract class EspCommand {}

class EspTypeCommand with EspCommand {
  static const EspTypeCommand ESP_CMD_TYPE_NONE = const EspTypeCommand._(0);
  static const EspTypeCommand ESP_CMD_TYPE_NET = const EspTypeCommand._(1);
  static const EspTypeCommand ESP_CMD_TYPE_CONTROL_DEV =
      const EspTypeCommand._(2); // управление устройством
  static const EspTypeCommand ESP_CMD_TYPE_BOOT =
      const EspTypeCommand._(3); // обновление прошивки модема
  static const EspTypeCommand ESP_CMD_TYPE_UPDATE_MODEM =
      const EspTypeCommand._(3);
  static const EspTypeCommand ESP_CMD_TYPE_UPDATE_DEV =
      const EspTypeCommand._(4); // обновление прошивки устройства
  static const EspTypeCommand ESP_CMD_TYPE_PRMTRS_MODEM_SET =
      const EspTypeCommand._(5); // изменить указанные параметр модема
  static const EspTypeCommand ESP_CMD_TYPE_PRMTRS_MODEM_GET =
      const EspTypeCommand._(6); // прочитать требуемый параметр модема
  static const EspTypeCommand ESP_CMD_TYPE_PRMTRS_DEV_SET =
      const EspTypeCommand._(7); // изменить указанный параметр устройства
  static const EspTypeCommand ESP_CMD_TYPE_PRMTRS_DEV_GET =
      const EspTypeCommand._(8); // прочитать требуемый параметр устройства
  static const EspTypeCommand ESP_CMD_TYPE_EVENT_MODEM =
      const EspTypeCommand._(9); // событие от модема
  static const EspTypeCommand ESP_CMD_TYPE_EVENT_DEV =
      const EspTypeCommand._(10); // событие от устройства
  static const EspTypeCommand ESP_CMD_TYPE_EVENT_RC =
      const EspTypeCommand._(11); // событие от пульта
  static const EspTypeCommand ED_PARAM_TIME_MOVE =
      const EspTypeCommand._(0x3201); // время движения, автозакрытия

  static const EspTypeCommand ED_PARAM_MODE_WORK =
      const EspTypeCommand._(0x3202);

  static const EspTypeCommand ED_PARAM_TRANSCODE =
      const EspTypeCommand._(0x3205);

  static const EspTypeCommand ED_STATE = const EspTypeCommand._(
      0x3207); // Получение информации о состоянии исполнительного устройства

  static const EspTypeCommand ED_VERSION =
      const EspTypeCommand._(0x3105); // получение версии девайса

  static const EspTypeCommand MODEM_VERSION =
      const EspTypeCommand._(0x2105); // получение версии модема

  static const EspTypeCommand ESP_VERSION =
      const EspTypeCommand._(0x1105); // получение версии ESP

  static const EspTypeCommand ESP_UPDATE =
      const EspTypeCommand._(0x1401); // обновление можема

  static const EspTypeCommand ESP_UPDATE_CHECK =
      const EspTypeCommand._(0x1402); // проверка обновлений на модеме

  static const EspTypeCommand ESP_LIST_TIMERS = const EspTypeCommand._(0x1502);

  static const EspTypeCommand MODEM_GROUP =
      const EspTypeCommand._(0x2603); //получение списка групп
  static const EspTypeCommand MODEM_GROUP_RM =
      const EspTypeCommand._(0x2602); //удаление группы
  static const EspTypeCommand MODEM_GROUP_ADD =
      const EspTypeCommand._(0x2601); //создание группы
  static const EspTypeCommand MODEM_GROUP_ED =
      const EspTypeCommand._(0x2606); //чтение списка устройств в группе

  static const EspTypeCommand MODEM_GROUP_ED_RM =
      const EspTypeCommand._(0x2605); //удаление устройства из группы

  static const EspTypeCommand MODEM_GROUP_ED_ADD =
      const EspTypeCommand._(0x2604); //добавление устройства в группу

  static const EspTypeCommand ESP_ACL =
      const EspTypeCommand._(0x1603); //прочитать количество пользователей

  static const EspTypeCommand ESP_AUTH =
      const EspTypeCommand._(0x1604); //запрос на авторизацию

  static const EspTypeCommand EVENT_ESP_CLOUD_READY =
      const EspTypeCommand._(0x9083); //соединение по mqtt восстановлено

  static const EspTypeCommand ESP_ACL_RM =
      const EspTypeCommand._(0x1602); //Удалить пользователя

  static const EspTypeCommand ESP_ACL_ADD =
      const EspTypeCommand._(0x1601); //создать пользователя

  static const EspTypeCommand MODEM_RC_LIST_ADD =
      const EspTypeCommand._(0x2801); //Перейти в режим добавления пульта
  static const EspTypeCommand MODEM_RC_LIST_RM =
      const EspTypeCommand._(0x2802); //Удалить пульт
  static const EspTypeCommand MODEM_RC_LIST =
      const EspTypeCommand._(0x2803); //Получить список пультов
  static const EspTypeCommand ED_RC_ADD =
      const EspTypeCommand._(0x3501); //Добавить пульт в устройство
  static const EspTypeCommand ED_RC_RM =
      const EspTypeCommand._(0x3502); //Удалить пульт из устройства
  static const EspTypeCommand ED_RC =
      const EspTypeCommand._(0x3503); //Прочитать список пультов устройства
  static const EspTypeCommand MODEM_RC_TYPE =
      const EspTypeCommand._(0x2804); //Установить новый тип пульта
  static const EspTypeCommand ESP_RC_DB = const EspTypeCommand._(
      0x1504); //Чтение базы кнопок, привязанных к устройству
  static const EspTypeCommand RC_EVENT_PRESS =
      const EspTypeCommand._(0xc004); //Событие нажатия пульта

  static const EspTypeCommand ESP_RC_GROUP_ADD =
      const EspTypeCommand._(0x1505); //Добавить пульт в устройство
  static const EspTypeCommand ESP_RC_GROUP_RM =
      const EspTypeCommand._(0x1506); //Удалить пульт из устройства

  final int value;

  static const values = [
    ESP_CMD_TYPE_NONE,
    ESP_CMD_TYPE_NET,
    ESP_CMD_TYPE_CONTROL_DEV,
    ESP_CMD_TYPE_BOOT,
    ESP_CMD_TYPE_UPDATE_MODEM,
    ESP_CMD_TYPE_UPDATE_DEV,
    ESP_CMD_TYPE_PRMTRS_MODEM_SET,
    ESP_CMD_TYPE_PRMTRS_MODEM_GET,
    ESP_CMD_TYPE_PRMTRS_DEV_SET,
    ESP_CMD_TYPE_PRMTRS_DEV_GET,
    ESP_CMD_TYPE_EVENT_MODEM,
    ESP_CMD_TYPE_EVENT_DEV,
    ESP_CMD_TYPE_EVENT_RC,
    ESP_LIST_TIMERS,
    MODEM_GROUP,
    MODEM_GROUP_RM,
    MODEM_GROUP_ADD,
    MODEM_GROUP_ED,
    MODEM_GROUP_ED_RM,
    MODEM_GROUP_ED_ADD,
    ESP_ACL,
    ESP_AUTH,
    EVENT_ESP_CLOUD_READY,
    ESP_ACL_RM,
    ESP_ACL_ADD
  ];

  const EspTypeCommand._(this.value);

  @override
  String toString() {
    if (value == ESP_CMD_TYPE_CONTROL_DEV.value) {
      return "ESP_CMD_TYPE_CONTROL_DEV";
    } else if (value == ESP_CMD_TYPE_PRMTRS_DEV_SET.value) {
      return "ESP_CMD_TYPE_PRMTRS_DEV_SET";
    } else if (value == ED_PARAM_TIME_MOVE.value) {
      return "ED_PARAM_TIME_MOVE";
    } else if (value == ED_VERSION.value) {
      return "ED_VERSION";
    } else if (value == MODEM_VERSION.value) {
      return "MODEM_VERSION";
    } else if (value == ED_PARAM_MODE_WORK.value) {
      return "ED_PARAM_MODE_WORK";
    } else if (value == ED_PARAM_TRANSCODE.value) {
      return "ED_PARAM_TRANSCODE";
    } else if (value == ESP_UPDATE_CHECK.value) {
      return "ESP_UPDATE_CHECK";
    } else if (value == ESP_UPDATE.value) {
      return "ESP_UPDATE";
    } else if (value == ESP_LIST_TIMERS.value) {
      return "ESP_LIST_TIMERS";
    } else if (value == MODEM_GROUP.value) {
      return "MODEM_GROUP";
    } else if (value == MODEM_GROUP_RM.value) {
      return "MODEM_GROUP_RM";
    } else if (value == MODEM_GROUP_ADD.value) {
      return "MODEM_GROUP_ADD";
    } else if (value == MODEM_GROUP_ED.value) {
      return "MODEM_GROUP_ED";
    } else if (value == MODEM_GROUP_ED_RM.value) {
      return "MODEM_GROUP_ED_RM";
    } else if (value == MODEM_GROUP_ED_ADD.value) {
      return "MODEM_GROUP_ED_ADD";
    } else if (value == ESP_ACL.value) {
      return "ESP_ACL";
    } else if (value == ESP_AUTH.value) {
      return "ESP_AUTH";
    } else if (value == EVENT_ESP_CLOUD_READY.value) {
      return "EVENT_ESP_CLOUD_READY";
    } else if (value == ESP_ACL_RM.value) {
      return "ESP_ACL_RM";
    } else if (value == ESP_ACL_ADD.value) {
      return "ESP_ACL_ADD";
    }

    return "$runtimeType ${value.toString()}";
  }
}

class EspEvent {
  static const EspEvent ESP_EVENT_MODEM_NOP =
      const EspEvent._(0); // может исопльзоваться для проверки зависания ESP
  static const EspEvent ESP_EVENT_MODEM_BUTTON_STATE =
      const EspEvent._(1); // изменилось состояние кнопки, подключенной к модему
  static const EspEvent ESP_EVENT_DEV_NEW_STATE = const EspEvent._(
      2); // событие от устройства об изменении состояния  // управление устройством
  static const EspEvent ESP_EVENT_RESET_SETTINGS = const EspEvent._(
      3); // событие для сброса настроек ESP на заводские  // обновление прошивки модема
  static const EspEvent ESP_EVENT_RC_PRESS =
      const EspEvent._(4); // событие от пульта о нажатии кнопки

  final _value;

  const EspEvent._(this._value);
}

class EspControlCmd extends Equatable with EspCommand {
  static const EspControlCmd ESP_CMD_STOP = const EspControlCmd._(
      0); // может исопльзоваться для проверки зависания ESP
  static const EspControlCmd ESP_CMD_UP = const EspControlCmd._(
      1); // изменилось состояние кнопки, подключенной к модему
  static const EspControlCmd ESP_CMD_DOWN = const EspControlCmd._(
      2); // событие от устройства об изменении состояния  // управление устройством
  static const EspControlCmd ESP_CMD_LOOP = const EspControlCmd._(
      3); // событие для сброса настроек ESP на заводские  // обновление прошивки модема
  static const EspControlCmd ESP_CMD_COMFORT =
      const EspControlCmd._(4); // событие от пульта о нажатии кнопки
  static const EspControlCmd ESP_CMD_SCRIPT =
      const EspControlCmd._(5); // событие от пульта о нажатии кнопки
  static const EspControlCmd ESP_CMD_POSITION =
      const EspControlCmd._(6); // событие от пульта о нажатии кнопки
  static const EspControlCmd ESP_CMD_EXT_TYPE =
      const EspControlCmd._(7); // событие от пульта о нажатии кнопки

  final subCmdValue;
  final cmd = 0x3301;

  static const values = [
    ESP_CMD_STOP,
    ESP_CMD_UP,
    ESP_CMD_DOWN,
    ESP_CMD_LOOP,
    ESP_CMD_COMFORT,
    ESP_CMD_SCRIPT,
    ESP_CMD_POSITION,
    ESP_CMD_EXT_TYPE,
  ];

  const EspControlCmd._(this.subCmdValue);

  @override
  List<Object> get props => [subCmdValue];

  int get value => subCmdValue + cmd;

  @override
  String toString() {
    if (subCmdValue == ESP_CMD_STOP.subCmdValue) {
      return "ESP_CMD_STOP";
    } else if (subCmdValue == ESP_CMD_UP.subCmdValue) {
      return "ESP_CMD_UP";
    } else if (subCmdValue == ESP_CMD_DOWN.subCmdValue) {
      return "ESP_CMD_DOWN";
    } else if (subCmdValue == ESP_CMD_LOOP.subCmdValue) {
      return "ESP_CMD_LOOP";
    }

    return "$runtimeType ${subCmdValue.toString()}";
  }
}

class EspGetPrmtrsDevCmd extends Equatable with SubCmd {
  // перечисление команд типа PRMTRS
  static const EspGetPrmtrsDevCmd ESP_CMD_GET_PRMTRS_DEV_NOP =
      const EspGetPrmtrsDevCmd._(0);
  static const EspGetPrmtrsDevCmd ESP_CMD_GET_PRMTRS_DEV_VER =
      const EspGetPrmtrsDevCmd._(1); // версия ПО, можно только запросить

  static const EspGetPrmtrsDevCmd ESP_CMD_GET_PRMTRS_DEV_MODES =
      const EspGetPrmtrsDevCmd._(
          3); // выбранные режимы работы, номер частотного канала, флаги

  final value;

  const EspGetPrmtrsDevCmd._(this.value);

  @override
  List<Object> get props => [value];

  @override
  String toString() {
    if (value == ESP_CMD_GET_PRMTRS_DEV_NOP.value) {
      return "ESP_CMD_GET_PRMTRS_DEV_NOP";
    } else if (value == ESP_CMD_GET_PRMTRS_DEV_VER.value) {
      return "ESP_CMD_GET_PRMTRS_DEV_VER";
    } else if (value == ESP_CMD_GET_PRMTRS_DEV_MODES.value) {
      return "ESP_CMD_GET_PRMTRS_DEV_MODES";
    }

    return "$runtimeType ${value.toString()}";
  }
}

class EspSetPrmtrsDevCmd extends Equatable with SubCmd {
  // перечисление команд типа PRMTRS
  static const EspSetPrmtrsDevCmd ESP_CMD_SET_PRMTRS_DEV_NOP =
      const EspSetPrmtrsDevCmd._(0);
  static const EspSetPrmtrsDevCmd ESP_CMD_SET_PRMTRS_DEV_TIME_MOVE =
      const EspSetPrmtrsDevCmd._(1); // время движения
  static const EspSetPrmtrsDevCmd ESP_CMD_SET_PRMTRS_DEV_TIME_AUTOCLOSE =
      const EspSetPrmtrsDevCmd._(2); // время авто закрытия
  static const EspGetPrmtrsDevCmd ESP_CMD_SET_PRMTRS_DEV_MODES_1 =
      const EspGetPrmtrsDevCmd._(3); // режимы работы, флаги
  static const EspGetPrmtrsDevCmd ESP_CMD_SET_PRMTRS_DEV_MODES_2 =
      const EspGetPrmtrsDevCmd._(
          4); // режимы транс кодирования, частотный канал
  static const EspGetPrmtrsDevCmd ESP_CMD_SET_PRMTRS_DEV_ACTION =
      const EspGetPrmtrsDevCmd._(5); // действие (тип действия + код действия)

  final value;

  @override
  List<Object> get props => [value];

  const EspSetPrmtrsDevCmd._(this.value);
}

abstract class SubCmd {}

class EspNetCmd extends Equatable with EspCommand {
  static const EspNetCmd ESP_CMD_NOP = const EspNetCmd._(0);
  static const EspNetCmd ESP_CMD_ADD_DEV = const EspNetCmd._(
      0x2401); // обнаружить и добавить обнаруженные устройства в сеть
  static const EspNetCmd ESP_CMD_DEL_DEV = const EspNetCmd._(
      0x2402); // обнаружить и удалить обнаруженные устройства из сети
  static const EspNetCmd ESP_CMD_READ_DEV =
      const EspNetCmd._(0x2403); // прочитать устройства, добавленные в сеть

  final value;

  static const values = [
    ESP_CMD_NOP,
    ESP_CMD_ADD_DEV,
    ESP_CMD_DEL_DEV,
    ESP_CMD_READ_DEV
  ];

  const EspNetCmd._(this.value);

  List<Object> get props => [value];

  @override
  String toString() {
    if (value == ESP_CMD_ADD_DEV.value) {
      return "ESP_CMD_ADD_DEV";
    } else if (value == ESP_CMD_DEL_DEV.value) {
      return "ESP_CMD_DEL_DEV";
    } else if (value == ESP_CMD_READ_DEV.value) {
      return "ESP_CMD_READ_DEV";
    }

    return "$runtimeType ${value.toString()}";
  }
}

class ActionGotoCommands extends Equatable with EspCommand {
  static const ActionGotoCommands GOTO_WORK =
      const ActionGotoCommands._(0x3401);
  static const ActionGotoCommands GOTO_PROG =
      const ActionGotoCommands._(0x3402);

  final value;

  static const values = [
    GOTO_WORK,
    GOTO_PROG,
  ];

  @override
  String toString() {
    if (value == GOTO_WORK.value) {
      return "GOTO_WORK";
    } else if (value == GOTO_PROG.value) {
      return "GOTO_PROG";
    }

    return "$runtimeType ${value.toString()}";
  }

  const ActionGotoCommands._(this.value);

  List<Object> get props => [value];
}

class CommandType extends Equatable with EspCommand {
  static const CommandType CMD_READ = const CommandType._(0x01);
  static const CommandType CMD_WRITE = const CommandType._(0x41);

  final value;

  static const values = [
    CMD_READ,
    CMD_WRITE,
  ];

  const CommandType._(this.value);

  List<Object> get props => [value];
}

class RemoteControllers {
  static const RemoteControllers RADIO3_RC_SMLT = const RemoteControllers._(0);
  static const RemoteControllers RADIO3_RC_8101_1 =
      const RemoteControllers._(1);
  static const RemoteControllers RADIO3_RC_8101_2 =
      const RemoteControllers._(2);
  static const RemoteControllers RADIO3_RC_8101_4 =
      const RemoteControllers._(3);
  static const RemoteControllers RADIO3_RC_8101_5 =
      const RemoteControllers._(4);
  static const RemoteControllers RADIO3_RC_8103 = const RemoteControllers._(5);
  static const RemoteControllers RADIO3_RC_8101_15 =
      const RemoteControllers._(6);
  static const RemoteControllers RADIO3_RC_UNDEFINED =
      const RemoteControllers._(15);

  final value;

  static const values = [
    RADIO3_RC_SMLT,
    RADIO3_RC_8101_1,
    RADIO3_RC_8101_2,
    RADIO3_RC_8101_4,
    RADIO3_RC_8101_5,
    RADIO3_RC_8103,
    RADIO3_RC_8101_15,
    RADIO3_RC_UNDEFINED,
  ];

  const RemoteControllers._(this.value);

  List<Object> get props => [value];

  @override
  String toString() {
    if (value == RADIO3_RC_8101_1.value) {
      return "8101-1M";
    } else if (value == RADIO3_RC_8101_2.value) {
      return "8101-2M";
    } else if (value == RADIO3_RC_8101_4.value) {
      return "8101-4M";
    } else if (value == RADIO3_RC_8101_5.value) {
      return "8101-5";
    } else if (value == RADIO3_RC_8103.value) {
      return "8103";
    } else if (value == RADIO3_RC_8101_15.value) {
      return "8101-15";
    } else if (value == RADIO3_RC_UNDEFINED.value) {
      //return Strings.unknown;
    }

    return "$runtimeType ${value.toString()}";
  }

  static RemoteControllers getRemoteControllersByValue(int value) {
    return values.firstWhere((element) {
      return element.value == value;
    }, orElse: () => null);
  }

  static int getChannelQuantityByRemote(RemoteControllers controllers) {
    if (controllers == RADIO3_RC_8101_1) {
      return 1;
    } else if (controllers == RADIO3_RC_8101_2) {
      return 2;
    } else if (controllers == RADIO3_RC_8101_4) {
      return 4;
    } else if (controllers == RADIO3_RC_8101_5) {
      return 5;
    } else if (controllers == RADIO3_RC_8103) {
      return 3;
    } else if (controllers == RADIO3_RC_8101_15) {
      return 15;
    } else if (controllers == RADIO3_RC_UNDEFINED) {
      return 0;
    }
    return -1;
  }
}

extension RemoteExtenstion on RemoteControllers {
  String getImagePath() {
    if (this == RemoteControllers.RADIO3_RC_8101_1) {
      //return Images.ic_8101_1M;
    } else if (this == RemoteControllers.RADIO3_RC_8101_2) {
      //return Images.ic_8101_2M;
    } else if (this == RemoteControllers.RADIO3_RC_8101_4) {
      //return Images.ic_8101_4M;
    } else if (this == RemoteControllers.RADIO3_RC_8101_5) {
      //return Images.ic_8101_5;
    } else if (this == RemoteControllers.RADIO3_RC_8103) {
      //return Images.ic_rc_unknown;
    } else if (this == RemoteControllers.RADIO3_RC_8101_15) {
      //return Images.ic_8101_15;
    } else if (this == RemoteControllers.RADIO3_RC_UNDEFINED) {
      //return Images.ic_rc_unknown;
    }
    // return Images.ic_rc_unknown;
  }
}
