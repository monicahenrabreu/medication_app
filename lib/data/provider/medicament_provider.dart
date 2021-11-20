import 'dart:collection';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:medicaments_app/data/models/medicament_entity.dart';
import 'package:medicaments_app/data/provider/base_medicament_provider.dart';

class MedicamentProvider extends BaseMedicamentProvider {
  final Box<List<MedicamentEntity>> hiveBox;

  MedicamentProvider(this.hiveBox);

  @override
  LinkedHashMap<DateTime, List<Medicament>> getMedicamentList() {
    Map hiveMap = hiveBox.toMap();
    LinkedHashMap<DateTime, List<Medicament>> medicamentList =
        LinkedHashMap<DateTime, List<Medicament>>();

    hiveMap.forEach((key, value) {
      final _dateFormat = DateFormat('d MMM yyyy');

      DateTime date = _dateFormat.parse(key);
      final medicamentEntities = hiveMap[key] as List<MedicamentEntity>?;

      List<Medicament> list = [];

      if (medicamentEntities != null && (medicamentEntities.isNotEmpty)) {
        for (var medicament in medicamentEntities) {
          list.add(Medicament(
              title: medicament.title,
              hour: medicament.hour,
              tookPill: medicament.tookPill));
        }
      }

      medicamentList[date] = list;
    });

    return medicamentList;
  }

  @override
  void addMedicament(DateTime date, Medicament medicament) async {
    final _dateFormat = DateFormat('d MMM yyyy');
    MedicamentEntity medicamentEntity = MedicamentEntity(
        title: medicament.title,
        hour: medicament.hour,
        tookPill: medicament.tookPill);
    final key = _dateFormat.format(date);
    final List<MedicamentEntity> currentList = hiveBox.get(key) ?? <MedicamentEntity>[];
    currentList.add(medicamentEntity);
    await hiveBox.put(_dateFormat.format(date), currentList);
  }

  @override
  void addRangeOfMedicament(
      DateTime fromDate, DateTime toDate, Medicament medicament) async {
    final _dateFormat = DateFormat('d MMM yyyy');

    DateTime date = fromDate;

    final key = _dateFormat.format(date);
    final currentList = hiveBox.get(key) ?? <MedicamentEntity>[];

    while (date.compareTo(toDate) <= 0) {
      MedicamentEntity medicamentEntity = MedicamentEntity(
          title: medicament.title,
          hour: medicament.hour,
          tookPill: medicament.tookPill);

      currentList.add(medicamentEntity);
      await hiveBox.put(_dateFormat.format(date), currentList);
      date = date.add(const Duration(days: 1));
    }
  }
}
