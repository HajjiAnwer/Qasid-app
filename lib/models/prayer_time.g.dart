// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_time.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrayerTimeAdapter extends TypeAdapter<PrayerTime> {
  @override
  final int typeId = 2;

  @override
  PrayerTime read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrayerTime(
      id: fields[0] as String,
      prayer: fields[1] as String,
      dateTimeUtc: fields[2] as DateTime,
      isExtra: fields[3] as bool,
      isNotified: fields[4] as bool,
      mosque: fields[5] as String,
      muezzin: fields[6] as Person?,
      imam: fields[7] as Person?,
    );
  }

  @override
  void write(BinaryWriter writer, PrayerTime obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.prayer)
      ..writeByte(2)
      ..write(obj.dateTimeUtc)
      ..writeByte(3)
      ..write(obj.isExtra)
      ..writeByte(4)
      ..write(obj.isNotified)
      ..writeByte(5)
      ..write(obj.mosque)
      ..writeByte(6)
      ..write(obj.muezzin)
      ..writeByte(7)
      ..write(obj.imam);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerTimeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
