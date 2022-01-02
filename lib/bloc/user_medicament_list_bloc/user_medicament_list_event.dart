import 'package:equatable/equatable.dart';
import 'package:medicaments_app/data/models/medicament.dart';

abstract class UserMedicamentListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetUserMedicamentListEvent extends UserMedicamentListEvent {
  GetUserMedicamentListEvent();

  @override
  List<Object?> get props => [];
}

class RemoveUserMedicamentEvent extends UserMedicamentListEvent {
  final Medicament medicament;

  RemoveUserMedicamentEvent(this.medicament);

  @override
  List<Object?> get props => [medicament];
}