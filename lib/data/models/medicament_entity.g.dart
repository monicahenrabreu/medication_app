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
      id: fields[0] as String,
      title: fields[1] as String,
      hour: fields[2] as DateTime,
      tookMedicament: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MedicamentEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.hour)
      ..writeByte(3)
      ..write(obj.tookMedicament);
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
