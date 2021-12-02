import 'dart:collection';
import 'package:medicaments_app/data/models/medicament.dart';

class MedicamentListState {
  final bool isLoading;
  late final LinkedHashMap<DateTime, List<Medicament>>? medicamentList;

  MedicamentListState(this.isLoading, this.medicamentList);

  MedicamentListState copyWith({
    bool? isLoading,
    LinkedHashMap<DateTime, List<Medicament>>? medicamentList,
  }) {
    return MedicamentListState(
      isLoading ?? this.isLoading,
      medicamentList ?? this.medicamentList,
    );
  }

  MedicamentListState copyLoading({
    bool? isLoading,
  }) {
    return MedicamentListState(
      isLoading ?? this.isLoading,
      medicamentList,
    );
  }

  MedicamentListState addMedicament(
      {required Medicament medicament, required DateTime date}) {
    List<Medicament> list = [medicament];
    Map<DateTime, List<Medicament>> map = {date: list};
    medicamentList!.addAll(map);

    return MedicamentListState(
      isLoading,
      medicamentList,
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
      isLoading,
      medicamentList,
    );
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }
}

class MedicamentListInitialState extends MedicamentListState {
  MedicamentListInitialState()
      : super(false, LinkedHashMap<DateTime, List<Medicament>>());
}

class MedicamentListLoadingState extends MedicamentListState {
  MedicamentListLoadingState(
      LinkedHashMap<DateTime, List<Medicament>>? medicamentList)
      : super(true, medicamentList);
}

class MedicamentListLoadedState extends MedicamentListState {
  MedicamentListLoadedState(
      LinkedHashMap<DateTime, List<Medicament>>? medicamentList)
      : super(false, medicamentList);
}

class MedicamentAddedState extends MedicamentListState {
  MedicamentAddedState(
      LinkedHashMap<DateTime, List<Medicament>>? medicamentList)
      : super(false, medicamentList);
}

class RangeMedicamentAddedState extends MedicamentListState {
  RangeMedicamentAddedState(
      LinkedHashMap<DateTime, List<Medicament>>? medicamentList)
      : super(false, medicamentList);
}
