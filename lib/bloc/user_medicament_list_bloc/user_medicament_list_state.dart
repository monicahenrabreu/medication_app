import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:medicaments_app/data/models/medicament.dart';

@immutable
abstract class UserMedicamentListState extends Equatable {
  final List<Medicament>? medicamentList;

  const UserMedicamentListState(this.medicamentList);

  @override
  List<Object?> get props => [medicamentList];
}

class UserMedicamentListInitialState extends UserMedicamentListState {
  UserMedicamentListInitialState() : super(List.of([]));
}

class GetUserMedicamentList extends UserMedicamentListState {
  const GetUserMedicamentList(
      {List<Medicament>? medicamentList})
      : super(medicamentList);
}

class RemoveUserMedicamentList extends UserMedicamentListState {
  const RemoveUserMedicamentList(
      {List<Medicament>? medicamentList})
      : super(medicamentList);
}
