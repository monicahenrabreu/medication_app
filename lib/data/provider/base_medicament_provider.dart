import 'dart:collection';
import 'package:medicaments_app/data/models/medicament.dart';

abstract class BaseMedicamentProvider {
  LinkedHashMap<DateTime, List<Medicament>> getMedicamentList();

  void addMedicament (DateTime date, Medicament medicament);

  void addRangeOfMedicament (DateTime fromDate, DateTime toDate, Medicament medicament);
}