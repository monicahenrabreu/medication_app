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

  MedicamentListLoadingState copyLoading() {
    return MedicamentListLoadingState(
      medicamentList: medicamentList,
    );
  }

  MedicamentListState addMedicament(
      {required Medicament medicament, required DateTime date}) {
    List<Medicament> list = [medicament];
    Map<DateTime, List<Medicament>> map = {date: list};
    medicamentList!.addAll(map);

    return MedicamentListState(
      isLoading: isLoading,
      medicamentList: medicamentList,
    );
  }

  MedicamentListState addRangeOfMedicament(
      {required Medicament medicament,
      required DateTime fromDate,
      required DateTime toDate}) {
    List<Medicament> list = [medicament];
    DateTime date = fromDate;

    while (date.compareTo(toDate) <= 0) {
      Map<DateTime, List<Medicament>> map = {date: list};
      medicamentList!.addAll(map);

      date = date.add(const Duration(days: 1));
    }

    return MedicamentListState(
      isLoading: isLoading,
      medicamentList: medicamentList,
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
      {LinkedHashMap<DateTime, List<Medicament>>? medicamentList})
      : super(isLoading: true, medicamentList: medicamentList);
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
