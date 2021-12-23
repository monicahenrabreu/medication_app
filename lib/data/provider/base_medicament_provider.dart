import 'dart:collection';
import 'package:medicaments_app/data/models/medicament.dart';

abstract class BaseMedicamentProvider {
  LinkedHashMap<DateTime, List<Medicament>> getMedicamentList();

  List<Medicament>? getMedicamentListOfDay(DateTime date);

  Future<bool> addMedicament(DateTime date, Medicament medicament);

  Future<bool> addRangeOfMedicament(DateTime fromDate, DateTime toDate,
      String title, DateTime hour, List<Medicament> medicamentList);

  Medicament? getMedicament(String date, String id);

  Medicament? editMedicament(String date, String id, bool tookMedicament);

  List<Medicament>? getUserMedicamentList();
}
