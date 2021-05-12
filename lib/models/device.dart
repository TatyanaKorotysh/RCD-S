import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'device.g.dart';

@HiveType(typeId: 0)
class Device extends Equatable {
  @HiveField(0)
  final String deviceName;
  @HiveField(1)
  final int id;
  @HiveField(2)
  final int type;
  @HiveField(3)
  final List<int> payload;
  @HiveField(4)
  double workTime;
  @HiveField(5)
  int workMode;
  @HiveField(6)
  int translationMode;
  @HiveField(7)
  String version;
  @HiveField(8)
  String name;
  @HiveField(9)
  final String mac;

  Device(this.deviceName, this.payload, this.id, this.type, this.name, this.mac,
      {this.workTime, this.workMode, this.translationMode, this.version});

  @override
  List<Object> get props => [deviceName, payload, id, type, mac];

  @override
  String toString() {
    return 'Device{name: $deviceName, id: $id, payload: $payload, hostMac = $mac}';
  }
}

/*extension DeviceExtension on Device {
  String getImagePath() {
    if (this.type == RadioDevices.RADIO3_DEVICE_8113_NB.value)
      return Images.device8113Img;

    if (this.type == RadioDevices.RADIO3_DEVICE_8113_IP65.value)
      return Images.device8113Img;

    if (this.type == RadioDevices.RADIO3_DEVICE_8113_IN.value)
      return Images.device8113Img;

    if (this.type == RadioDevices.RADIO3_DEVICE_8113_IP55.value)
      return Images.device8113Img;

    if (this.type == RadioDevices.RADIO3_DEVICE_8117_NB.value)
      return Images.device8117Img;

    if (this.type == RadioDevices.RADIO3_DEVICE_8122_MINI.value)
      return Images.ic_select_lighting;

    return Images.device8767Img;
  }
}*/