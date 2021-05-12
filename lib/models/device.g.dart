// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeviceAdapter extends TypeAdapter<Device> {
  @override
  final int typeId = 0;

  @override
  Device read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Device(
      fields[0] as String,
      (fields[3] as List)?.cast<int>(),
      fields[1] as int,
      fields[2] as int,
      fields[8] as String,
      fields[9] as String,
      workTime: fields[4] as double,
      workMode: fields[5] as int,
      translationMode: fields[6] as int,
      version: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Device obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.deviceName)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.payload)
      ..writeByte(4)
      ..write(obj.workTime)
      ..writeByte(5)
      ..write(obj.workMode)
      ..writeByte(6)
      ..write(obj.translationMode)
      ..writeByte(7)
      ..write(obj.version)
      ..writeByte(8)
      ..write(obj.name)
      ..writeByte(9)
      ..write(obj.mac);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
