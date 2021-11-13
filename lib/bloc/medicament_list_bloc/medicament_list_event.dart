import 'package:medicaments_app/data/models/medicament.dart';

abstract class MedicamentListEvent {}

class GetMedicamentListForDayEvent extends MedicamentListEvent {
  final DateTime date;

  GetMedicamentListForDayEvent(this.date);
}

class AddMedicamentEvent extends MedicamentListEvent {
  final Medicament medicament;
  final DateTime date;

  AddMedicamentEvent(this.medicament, this.date);
}

class AddRangeMedicamentEvent extends MedicamentListEvent {
  final Medicament medicament;
  final DateTime fromDate;
  final DateTime toDate;

  AddRangeMedicamentEvent(this.medicament, this.fromDate, this.toDate);
}
