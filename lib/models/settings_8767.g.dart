// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_8767.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class Settings8767Adapter extends TypeAdapter<Settings8767> {
  @override
  final int typeId = 1;

  @override
  Settings8767 read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Settings8767(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[6] as int,
      fields[7] as bool,
      fields[8] as String,
      fields[9] as String,
      fields[10] as String,
      fields[11] as String,
      fields[12] as String,
      fields[13] as String,
      fields[14] as int,
      fields[15] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Settings8767 obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.login)
      ..writeByte(1)
      ..write(obj.espVersion)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.wifiName)
      ..writeByte(5)
      ..write(obj.wifiPassword)
      ..writeByte(6)
      ..write(obj.port)
      ..writeByte(7)
      ..write(obj.useSsl)
      ..writeByte(8)
      ..write(obj.wifiApName)
      ..writeByte(9)
      ..write(obj.wifiApPassword)
      ..writeByte(10)
      ..write(obj.modemVersion)
      ..writeByte(11)
      ..write(obj.mac)
      ..writeByte(12)
      ..write(obj.dateTime)
      ..writeByte(13)
      ..write(obj.sntpAddress)
      ..writeByte(14)
      ..write(obj.sntpGMT)
      ..writeByte(15)
      ..write(obj.sntpEnable);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Settings8767Adapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
