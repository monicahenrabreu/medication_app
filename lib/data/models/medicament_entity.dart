import 'package:hive/hive.dart';
import 'package:medicaments_app/data/models/medicament.dart';

part 'medicament_entity.g.dart';

@HiveType(typeId: 0)
class MedicamentEntity extends HiveObject {
  MedicamentEntity(
      {required this.title, required this.hour, required this.tookPill});

  @HiveField(0)
  String title;

  @HiveField(1)
  DateTime hour;

  @HiveField(2)
  TookPill? tookPill;

  factory MedicamentEntity.fromJson(Map<String, dynamic> json) =>
      MedicamentEntity(
        title: json["title"],
        hour: json["hour"],
        tookPill: json["tookPill"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "hour": hour,
        "tookPill": tookPill,
      };
}
