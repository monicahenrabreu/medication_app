import 'package:hive/hive.dart';

part 'medicament_entity.g.dart';

@HiveType(typeId: 0)
class MedicamentEntity extends HiveObject {
  MedicamentEntity(
      {required this.id,
      required this.title,
      required this.hour,
      this.dateOnlyOneTime,
      this.fromDate,
      this.toDate,
      this.tookMedicament = false});

  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  DateTime hour;

  @HiveField(3)
  DateTime? dateOnlyOneTime;

  @HiveField(4)
  DateTime? fromDate;

  @HiveField(5)
  DateTime? toDate;

  @HiveField(6)
  bool tookMedicament;

  factory MedicamentEntity.fromJson(Map<String, dynamic> json) =>
      MedicamentEntity(
        id: json["id"],
        title: json["title"],
        hour: json["hour"],
        dateOnlyOneTime: json["dateOnlyOneTime"],
        fromDate: json["fromDate"],
        toDate: json["toDate"],
        tookMedicament: json["tookMedicament"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "hour": hour,
        "dateOnlyOneTime": dateOnlyOneTime,
        "fromDate": fromDate,
        "toDate": toDate,
        "tookMedicament": tookMedicament,
      };
}
