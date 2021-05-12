import 'package:hive/hive.dart';

part 'settings_8767.g.dart';

@HiveType(typeId: 1)
class Settings8767 {
  @HiveField(0)
  String login;
  @HiveField(1)
  String espVersion;
  @HiveField(2)
  String password;
  @HiveField(3)
  String address;
  @HiveField(4)
  String wifiName;
  @HiveField(5)
  String wifiPassword;
  @HiveField(6)
  int port;
  @HiveField(7)
  bool useSsl;
  @HiveField(8)
  String wifiApName;
  @HiveField(9)
  String wifiApPassword;
  @HiveField(10)
  String modemVersion;
  @HiveField(11)
  String mac;
  @HiveField(12)
  String dateTime;
  @HiveField(13)
  String sntpAddress;
  @HiveField(14)
  int sntpGMT;
  @HiveField(15)
  bool sntpEnable;

  Settings8767(
    this.login,
    this.espVersion,
    this.password,
    this.address,
    this.wifiName,
    this.wifiPassword,
    this.port,
    this.useSsl,
    this.wifiApName,
    this.wifiApPassword,
    this.modemVersion,
    this.mac,
    this.dateTime,
    this.sntpAddress,
    this.sntpGMT,
    this.sntpEnable,
  );
}

//command for build adapters : flutter packages pub run build_runner build
