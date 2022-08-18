// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_activity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedActivityAdapter extends TypeAdapter<SavedActivity> {
  @override
  final int typeId = 1;

  @override
  SavedActivity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedActivity(
      name: fields[0] as String,
      key: fields[1] as String,
      color: fields[2] as Color,
    );
  }

  @override
  void write(BinaryWriter writer, SavedActivity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.key)
      ..writeByte(2)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedActivityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
