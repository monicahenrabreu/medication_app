import 'dart:collection';
import 'package:equatable/equatable.dart';
import 'package:medicaments_app/data/models/medicament.dart';

class MedicamentListState extends Equatable {
  final bool isLoading;
  late final LinkedHashMap<DateTime, List<Medicament>>? medicamentList;

  MedicamentListState({required this.isLoading, this.medicamentList});

  MedicamentListState copyWith({
    bool? isLoading,
    LinkedHashMap<DateTime, List<Medicament>>? medicamentList,
  }) {
    return MedicamentListState(
      isLoading: isLoading ?? this.isLoading,
      medicamentList: medicamentList ?? this.medicamentList,
    );
  }

  MedicamentListLoadingState copyLoading({
    bool? isLoading,
  }) {
    return MedicamentListLoadingState(
      isLoading: isLoading ?? this.isLoading,
      medicamentList: medicamentList,
    );
  }

  MedicamentAddedState addMedicament(
      {required LinkedHashMap<DateTime, List<Medicament>> medicamentList}) {
    return MedicamentAddedState(
      medicamentList,
    );
  }

  RangeMedicamentAddedState addRangeOfMedicament(
      {required LinkedHashMap<DateTime, List<Medicament>> medicamentList}) {
    return RangeMedicamentAddedState(
      medicamentList,
    );
  }

  MedicamentRemovedState removeMedicament(
      {required LinkedHashMap<DateTime, List<Medicament>> medicamentList}) {
    return MedicamentRemovedState(
      medicamentList,
    );
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  List<Object?> get props => [isLoading, medicamentList];
}

class MedicamentListInitialState extends MedicamentListState {
  MedicamentListInitialState()
      : super(
            isLoading: false,
            medicamentList: LinkedHashMap<DateTime, List<Medicament>>());
}

class MedicamentListLoadingState extends MedicamentListState {
  MedicamentListLoadingState(
      {required bool isLoading,
      LinkedHashMap<DateTime, List<Medicament>>? medicamentList})
      : super(isLoading: isLoading, medicamentList: medicamentList);
}

class MedicamentListLoadedState extends MedicamentListState {
  MedicamentListLoadedState(
      LinkedHashMap<DateTime, List<Medicament>>? medicamentList)
      : super(isLoading: false, medicamentList: medicamentList);
}

class MedicamentAddedState extends MedicamentListState {
  MedicamentAddedState(
      LinkedHashMap<DateTime, List<Medicament>>? medicamentList)
      : super(isLoading: false, medicamentList: medicamentList);
}

class RangeMedicamentAddedState extends MedicamentListState {
  RangeMedicamentAddedState(
      LinkedHashMap<DateTime, List<Medicament>>? medicamentList)
      : super(isLoading: false, medicamentList: medicamentList);
}

class MedicamentRemovedState extends MedicamentListState {
  MedicamentRemovedState(
      LinkedHashMap<DateTime, List<Medicament>>? medicamentList)
      : super(isLoading: false, medicamentList: medicamentList);
}