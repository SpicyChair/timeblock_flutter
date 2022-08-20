// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_day.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedDayAdapter extends TypeAdapter<SavedDay> {
  @override
  final int typeId = 2;

  @override
  SavedDay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedDay(
      key: fields[1] as String,
    )..intervals = (fields[0] as Map).cast<int, String>();
  }

  @override
  void write(BinaryWriter writer, SavedDay obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.intervals)
      ..writeByte(1)
      ..write(obj.key);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedDayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
