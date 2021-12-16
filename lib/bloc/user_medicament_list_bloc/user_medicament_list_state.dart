import 'package:equatable/equatable.dart';
import 'package:medicaments_app/data/models/medicament.dart';

class UserMedicamentListState extends Equatable {
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

  UserMedicamentListLoadingState copyLoading({
    bool? isLoading,
  }) {
    return UserMedicamentListLoadingState(
      isLoading: isLoading ?? this.isLoading,
      medicamentList: medicamentList,
    );
  }

  UserMedicamentListLoadedState copyResult({List<Medicament>? medicamentList}) {
    return UserMedicamentListLoadedState(
      medicamentList: medicamentList ?? this.medicamentList,
    );
  }

  @override
  int get hashCode => isLoading.hashCode ^ medicamentList.hashCode;

  @override
  List<Object?> get props => [isLoading, medicamentList];
}

class UserMedicamentListInitialState extends UserMedicamentListState {
  UserMedicamentListInitialState() : super(false, List.of([]));
}

class UserMedicamentListLoadingState extends UserMedicamentListState {
  UserMedicamentListLoadingState(
      {required bool isLoading, List<Medicament>? medicamentList})
      : super(isLoading, medicamentList);
}

class UserMedicamentListLoadedState extends UserMedicamentListState {
  UserMedicamentListLoadedState({required List<Medicament>? medicamentList})
      : super(false, medicamentList);
}
