import 'dart:collection';
import 'package:medicaments_app/data/models/medicament.dart';

abstract class BaseMedicamentProvider {
  LinkedHashMap<DateTime, List<Medicament>> getMedicamentList();

  Future<void> addMedicament(DateTime date, Medicament medicament);

  Future<void> addRangeOfMedicament(
      DateTime fromDate, DateTime toDate, Medicament medicament);

  Medicament? getMedicament(String date, String id);

  Medicament? editMedicament(String date, String id, bool tookMedicament);
}
