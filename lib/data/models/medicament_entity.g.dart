// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicament_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicamentEntityAdapter extends TypeAdapter<MedicamentEntity> {
  @override
  final int typeId = 0;

  @override
  MedicamentEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicamentEntity(
      title: fields[0] as String,
      hour: fields[1] as DateTime,
      tookPill: fields[2] as TookPill?,
    );
  }

  @override
  void write(BinaryWriter writer, MedicamentEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.hour)
      ..writeByte(2)
      ..write(obj.tookPill);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicamentEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
