import 'dart:collection';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:medicaments_app/configs/constants.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:medicaments_app/data/models/medicament_entity.dart';
import 'package:medicaments_app/data/models/medicament_list_entity.dart';
import 'package:medicaments_app/data/provider/base_medicament_provider.dart';
import 'package:uuid/uuid.dart';

class MedicamentProvider extends BaseMedicamentProvider {
  final Box<MedicamentListEntity> hiveBox;
  final Box<MedicamentEntity> hiveUserMedicamentsBox;
  final _dateFormat = DateFormat(Constants.dateFormat);

  MedicamentProvider(this.hiveBox, this.hiveUserMedicamentsBox);

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
  List<Medicament>? getMedicamentListOfDay(DateTime date) {
    Map hiveMap = hiveBox.toMap();
    List<Medicament> list = [];
    final key = _dateFormat.format(date);

    if (hiveMap.isNotEmpty) {
      final medicamentEntities = hiveMap[key] as MedicamentListEntity;

      if (medicamentEntities.medicamentEntities.isNotEmpty) {
        for (var medicament in medicamentEntities.medicamentEntities) {
          list.add(Medicament(
              id: medicament.id,
              title: medicament.title,
              hour: medicament.hour,
              tookMedicament: medicament.tookMedicament));
        }
      }
    }

    return list;
  }

  @override
  Future<bool> addMedicament(DateTime date, Medicament medicament) async {
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

    medicamentEntity.dateOnlyOneTime = date;
    await hiveUserMedicamentsBox.add(medicamentEntity);
    return true;
  }

  @override
  Future<bool> addRangeOfMedicament(DateTime fromDate, DateTime toDate,
      String title, DateTime hour, List<Medicament> medicamentList) async {
    DateTime date = fromDate;
    int index = 0;

    while (date.compareTo(toDate) <= 0) {
      final _dateFormat = DateFormat(Constants.dateFormat);

      final key = _dateFormat.format(date);
      final currentList =
          hiveBox.get(key) ?? MedicamentListEntity(medicamentEntities: []);

      MedicamentEntity medicamentEntity = MedicamentEntity(
          id: medicamentList[index].id,
          title: medicamentList[index].title,
          hour: medicamentList[index].hour);

      currentList.medicamentEntities.add(medicamentEntity);
      await hiveBox.put(_dateFormat.format(date), currentList);
      date = date.add(const Duration(days: 1));
      index++;
    }

    var uuid = const Uuid();

    final _dateFormat = DateFormat(Constants.dateFormat);
    final _formatedDate = _dateFormat.format(date);

    String id = _formatedDate + '--' + uuid.v1();

    MedicamentEntity medicamentEntity = MedicamentEntity(
        id: id, title: title, hour: hour, fromDate: fromDate, toDate: toDate);

    await hiveUserMedicamentsBox.add(medicamentEntity);
    return true;
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

  @override
  List<Medicament>? getUserMedicamentList() {
    Iterable<MedicamentEntity> medicaments = hiveUserMedicamentsBox.values;

    List<Medicament>? medicamentList = List.of([]);

    for (MedicamentEntity medicamentEntity in medicaments) {
      medicamentList.add(Medicament(
          id: medicamentEntity.id,
          title: medicamentEntity.title,
          hour: medicamentEntity.hour,
          dateOnlyOneTime: medicamentEntity.dateOnlyOneTime,
          fromDate: medicamentEntity.fromDate,
          toDate: medicamentEntity.toDate,
          tookMedicament: medicamentEntity.tookMedicament));
    }

    return medicamentList;
  }
}
