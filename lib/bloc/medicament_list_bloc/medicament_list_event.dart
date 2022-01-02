import 'package:equatable/equatable.dart';
import 'package:medicaments_app/data/models/medicament.dart';

abstract class MedicamentListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetMedicamentListEvent extends MedicamentListEvent {
  GetMedicamentListEvent();
}

class AddMedicamentEvent extends MedicamentListEvent {
  final DateTime date;
  final String title;
  final DateTime hour;
  final Medicament medicament;

  AddMedicamentEvent(this.date, this.title, this.hour, this.medicament);

  @override
  List<Object?> get props => [date, title, hour, medicament];
}

class AddRangeOfMedicamentEvent extends MedicamentListEvent {
  final DateTime fromDate;
  final DateTime toDate;
  final String title;
  final DateTime hour;
  final List<Medicament> medicamentList;

  AddRangeOfMedicamentEvent(
      this.fromDate, this.toDate, this.title, this.hour, this.medicamentList);

  @override
  List<Object?> get props => [fromDate, toDate, title, hour, medicamentList];
}

class RemoveMedicamentEvent extends MedicamentListEvent {
  final DateTime date;
  final Medicament medicament;

  RemoveMedicamentEvent(this.date, this.medicament);

  @override
  List<Object?> get props => [date, medicament];
}