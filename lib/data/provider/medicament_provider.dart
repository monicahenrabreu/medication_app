import 'dart:collection';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:medicaments_app/data/models/medicament_entity.dart';
import 'package:medicaments_app/data/models/medicament_list_entity.dart';
import 'package:medicaments_app/data/provider/base_medicament_provider.dart';

class MedicamentProvider extends BaseMedicamentProvider {
  final Box<MedicamentListEntity> hiveBox;

  MedicamentProvider(this.hiveBox);

  @override
  LinkedHashMap<DateTime, List<Medicament>> getMedicamentList() {
    Map hiveMap = hiveBox.toMap();
    LinkedHashMap<DateTime, List<Medicament>> medicamentList =
        LinkedHashMap<DateTime, List<Medicament>>();

    hiveMap.forEach((key, value) {
      final _dateFormat = DateFormat('d MMM yyyy');

      DateTime date = _dateFormat.parse(key);
      final medicamentEntities = hiveMap[key] as MedicamentListEntity;

      List<Medicament> list = [];

      if (medicamentEntities.medicamentEntities.isNotEmpty) {
        for (var medicament in medicamentEntities.medicamentEntities) {
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
  Future<void> addMedicament(DateTime date, Medicament medicament) async {
    final _dateFormat = DateFormat('d MMM yyyy');
    MedicamentEntity medicamentEntity = MedicamentEntity(
        title: medicament.title,
        hour: medicament.hour,
        tookPill: medicament.tookPill);
    final key = _dateFormat.format(date);
    final MedicamentListEntity currentList =
        hiveBox.get(key) ?? MedicamentListEntity(medicamentEntities: []);
    currentList.medicamentEntities.add(medicamentEntity);
    await hiveBox.put(_dateFormat.format(date), currentList);
  }

  @override
  Future<void> addRangeOfMedicament(
      DateTime fromDate, DateTime toDate, Medicament medicament) async {
    final _dateFormat = DateFormat('d MMM yyyy');

    DateTime date = fromDate;

    while (date.compareTo(toDate) <= 0) {
      final key = _dateFormat.format(date);
      final currentList =
          hiveBox.get(key) ?? MedicamentListEntity(medicamentEntities: []);

      MedicamentEntity medicamentEntity = MedicamentEntity(
          title: medicament.title,
          hour: medicament.hour,
          tookPill: medicament.tookPill);

      currentList.medicamentEntities.add(medicamentEntity);
      await hiveBox.put(_dateFormat.format(date), currentList);
      date = date.add(const Duration(days: 1));
    }
  }
}
