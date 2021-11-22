// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicament_list_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicamentListEntityAdapter extends TypeAdapter<MedicamentListEntity> {
  @override
  final int typeId = 1;

  @override
  MedicamentListEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicamentListEntity(
      medicamentEntities: (fields[0] as List).cast<MedicamentEntity>(),
    );
  }

  @override
  void write(BinaryWriter writer, MedicamentListEntity obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.medicamentEntities);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicamentListEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
