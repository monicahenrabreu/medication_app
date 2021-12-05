import 'dart:collection';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:medicaments_app/configs/constants.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:medicaments_app/data/models/medicament_entity.dart';
import 'package:medicaments_app/data/models/medicament_list_entity.dart';
import 'package:medicaments_app/data/provider/base_medicament_provider.dart';

class MedicamentProvider extends BaseMedicamentProvider {
  final Box<MedicamentListEntity> hiveBox;
  final _dateFormat = DateFormat(Constants.dateFormat);

  MedicamentProvider(this.hiveBox);

  @override
  LinkedHashMap<DateTime, List<Medicament>> getMedicamentList() {
    Map hiveMap = hiveBox.toMap();
    LinkedHashMap<DateTime, List<Medicament>> medicamentList =
        LinkedHashMap<DateTime, List<Medicament>>();

    hiveMap.forEach((key, value) {
      DateTime date = _dateFormat.parse(key);
      final medicamentEntities = hiveMap[key] as MedicamentListEntity;

      List<Medicament> list = [];

      if (medicamentEntities.medicamentEntities.isNotEmpty) {
        for (var medicament in medicamentEntities.medicamentEntities) {
          list.add(Medicament(
              id: medicament.id,
              title: medicament.title,
              hour: medicament.hour,
              tookMedicament: medicament.tookMedicament));
        }
      }

      medicamentList[date] = list;
    });

    return medicamentList;
  }

  @override
  Future<void> addMedicament(DateTime date, Medicament medicament) async {
    MedicamentEntity medicamentEntity = MedicamentEntity(
        id: medicament.id,
        title: medicament.title,
        hour: medicament.hour,
        tookMedicament: medicament.tookMedicament);
    final key = _dateFormat.format(date);
    final MedicamentListEntity currentList =
        hiveBox.get(key) ?? MedicamentListEntity(medicamentEntities: []);
    currentList.medicamentEntities.add(medicamentEntity);
    await hiveBox.put(_dateFormat.format(date), currentList);
  }

  @override
  Future<void> addRangeOfMedicament(
      DateTime fromDate, DateTime toDate, Medicament medicament) async {
    DateTime date = fromDate;

    while (date.compareTo(toDate) <= 0) {
      final key = _dateFormat.format(date);
      final currentList =
          hiveBox.get(key) ?? MedicamentListEntity(medicamentEntities: []);

      MedicamentEntity medicamentEntity = MedicamentEntity(
          id: medicament.id,
          title: medicament.title,
          hour: medicament.hour,
          tookMedicament: medicament.tookMedicament);

      currentList.medicamentEntities.add(medicamentEntity);
      await hiveBox.put(_dateFormat.format(date), currentList);
      date = date.add(const Duration(days: 1));
    }
  }

  @override
  Medicament? getMedicament(String date, String id) {
    Map hiveMap = hiveBox.toMap();

    final medicamentEntities = hiveMap[date] as MedicamentListEntity;

    List<MedicamentEntity> entities = medicamentEntities.medicamentEntities;

    MedicamentEntity? medicamentEntity;

    for (MedicamentEntity medicament in entities) {
      if (medicament.id == id) {
        medicamentEntity = medicament;
        break;
      }
    }

    if (medicamentEntity == null) {
      return null;
    }

    Medicament medicament = Medicament(
        id: medicamentEntity.id,
        title: medicamentEntity.title,
        hour: medicamentEntity.hour,
        tookMedicament: medicamentEntity.tookMedicament);

    return medicament;
  }

  @override
  Medicament? editMedicament(String date, String id, bool tookMedicament) {
    Map hiveMap = hiveBox.toMap();

    final medicamentEntities = hiveMap[date] as MedicamentListEntity;

    List<MedicamentEntity> entities = medicamentEntities.medicamentEntities;

    for (MedicamentEntity medicamentEntity in entities) {
      if (medicamentEntity.id == id) {
        medicamentEntity.tookMedicament = tookMedicament;
        break;
      }
    }

    hiveBox.put(date, MedicamentListEntity(medicamentEntities: entities));
  }
}
