import 'dart:collection';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicaments_app/bloc/medicament_list_bloc/medicament_list_event.dart';
import 'package:medicaments_app/bloc/medicament_list_bloc/medicament_list_state.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'medicament_list_event.dart';

class MedicamentListBloc
    extends Bloc<MedicamentListEvent, MedicamentListState> {
  MedicamentListBloc() : super(MedicamentListInitialState()) {
    on<GetMedicamentListForDayEvent>(_onGetMedicamentListForDayEvent);
    on<AddMedicamentEvent>(_onAddMedicamentEvent);
    on<AddRangeMedicamentEvent>(_onAddRangeMedicamentEvent);
  }

  void _onGetMedicamentListForDayEvent(GetMedicamentListForDayEvent event,
      Emitter<MedicamentListState> emit) async {
    emit(MedicamentListInitialState());
    emit(
        MedicamentListLoadedState(LinkedHashMap<DateTime, List<Medicament>>()));
  }

  void _onAddMedicamentEvent(
      AddMedicamentEvent event, Emitter<MedicamentListState> emit) async {
    state.addMedicament(medicament: event.medicament, date: event.date);

    final medicamentList = state.medicamentList;

    emit(MedicamentListLoadedState(medicamentList));
  }

  void _onAddRangeMedicamentEvent(
      AddRangeMedicamentEvent event, Emitter<MedicamentListState> emit) async {
    state.addRangeOfMedicament(
        medicament: event.medicament,
        toDate: event.toDate,
        fromDate: event.fromDate);

    final medicamentList = state.medicamentList;

    emit(MedicamentListLoadedState(medicamentList));
  }
}
