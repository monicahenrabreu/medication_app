import 'package:medicaments_app/data/models/medicament.dart';

class UserMedicamentListState {
  final bool isLoading;
  late final List<Medicament>? medicamentList;

  UserMedicamentListState(this.isLoading, this.medicamentList);

  UserMedicamentListState copyWith({
    bool? isLoading,
    List<Medicament>? medicamentList,
  }) {
    return UserMedicamentListState(
      isLoading ?? this.isLoading,
      medicamentList ?? this.medicamentList,
    );
  }

  UserMedicamentListState copyLoading({
    bool? isLoading,
  }) {
    return UserMedicamentListState(
      isLoading ?? this.isLoading,
      medicamentList,
    );
  }
}

class UserMedicamentListInitialState extends UserMedicamentListState {
  UserMedicamentListInitialState()
      : super(false, List.of([]));
}

class UserMedicamentListLoadingState extends UserMedicamentListState {
  UserMedicamentListLoadingState(
      List<Medicament>? medicamentList)
      : super(true, medicamentList);
}

class UserMedicamentListLoadedState extends UserMedicamentListState {
  UserMedicamentListLoadedState(
      List<Medicament>? medicamentList)
      : super(false, medicamentList);
}