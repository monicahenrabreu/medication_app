import 'package:medicaments_app/data/models/medicament.dart';

abstract class MedicamentListEvent {}

class GetMedicamentListEvent extends MedicamentListEvent {
  GetMedicamentListEvent();
}

class AddMedicamentEvent extends MedicamentListEvent {
  final DateTime date;
  final String title;
  final DateTime hour;
  final Medicament medicament;

  AddMedicamentEvent(this.date, this.title, this.hour, this.medicament);
}

class AddRangeOfMedicamentEvent extends MedicamentListEvent {
  final DateTime fromDate;
  final DateTime toDate;
  final String title;
  final DateTime hour;
  final List<Medicament> medicamentList;

  AddRangeOfMedicamentEvent(
      this.fromDate, this.toDate, this.title, this.hour, this.medicamentList);
}
