import 'package:hive/hive.dart';
import 'package:medicaments_app/data/models/medicament_entity.dart';

part 'medicament_list_entity.g.dart';

@HiveType(typeId: 1)
class MedicamentListEntity extends HiveObject {
  MedicamentListEntity({required this.medicamentEntities});

  @HiveField(0)
  List<MedicamentEntity> medicamentEntities;
}
