import 'package:hive/hive.dart';

part 'medicament_entity.g.dart';

@HiveType(typeId: 0)
class MedicamentEntity extends HiveObject {
  MedicamentEntity(
      {required this.id,
      required this.title,
      required this.hour,
      this.tookMedicament = false});

  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  DateTime hour;

  @HiveField(3)
  bool tookMedicament;

  factory MedicamentEntity.fromJson(Map<String, dynamic> json) =>
      MedicamentEntity(
        id: json["id"],
        title: json["title"],
        hour: json["hour"],
        tookMedicament: json["tookMedicament"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "hour": hour,
        "tookMedicament": tookMedicament,
      };
}
