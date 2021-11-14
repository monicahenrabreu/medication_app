import 'dart:collection';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:medicaments_app/data/models/medicament_entity.dart';
import 'package:medicaments_app/data/provider/base_medicament_provider.dart';

class MedicamentProvider extends BaseMedicamentProvider {
  @override
  LinkedHashMap<DateTime, List<Medicament>> getMedicamentList() {
    Map list = Hive.box<MedicamentEntity>('medicaments').toMap();

    LinkedHashMap<DateTime, List<Medicament>> medicamentList =
        LinkedHashMap<DateTime, List<Medicament>>();

    list.forEach((key, value) {
      final _dateFormat = DateFormat('d MMM yyyy');

      DateTime date = _dateFormat.parse(key);
      List<Medicament> list = [];

      list.add(Medicament(
          title: value.title, hour: value.hour, tookPill: value.tookPill));

      Map<DateTime, List<Medicament>> map = {date: list};
      medicamentList.addAll(map);
    });

    return medicamentList;
  }

  @override
  void addMedicament(DateTime date, Medicament medicament) {
    final _dateFormat = DateFormat('d MMM yyyy');
    MedicamentEntity medicamentEntity = MedicamentEntity(
        title: medicament.title,
        hour: medicament.hour,
        tookPill: medicament.tookPill);
    Hive.box<MedicamentEntity>('medicaments')
        .put(_dateFormat.format(date), medicamentEntity);
  }

  @override
  void addRangeOfMedicament(DateTime fromDate, DateTime toDate, Medicament medicament) {
    final _dateFormat = DateFormat('d MMM yyyy');
    MedicamentEntity medicamentEntity = MedicamentEntity(
        title: medicament.title,
        hour: medicament.hour,
        tookPill: medicament.tookPill);

    DateTime date = fromDate;

    while (date.compareTo(toDate) <= 0) {
      Hive.box<MedicamentEntity>('medicaments')
          .put(_dateFormat.format(date), medicamentEntity);
      date = date.add(const Duration(days: 1));
    }
  }
}
