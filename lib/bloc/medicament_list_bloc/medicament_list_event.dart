import 'package:medicaments_app/data/models/medicament.dart';

abstract class MedicamentListEvent {}

class GetMedicamentListEvent extends MedicamentListEvent {
  GetMedicamentListEvent();
}

class AddMedicamentEvent extends MedicamentListEvent {
  final Medicament medicament;
  final DateTime date;

  AddMedicamentEvent(this.medicament, this.date);
}

class AddRangeOfMedicamentEvent extends MedicamentListEvent {
  final Medicament medicament;
  final DateTime fromDate;
  final DateTime toDate;

  AddRangeOfMedicamentEvent(this.medicament, this.fromDate, this.toDate);
}
