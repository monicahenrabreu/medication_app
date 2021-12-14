import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicaments_app/bloc/medicament_list_bloc/bloc.dart';
import 'package:medicaments_app/data/provider/base_medicament_provider.dart';
import 'package:medicaments_app/data/provider/medicament_provider.dart';
import 'medicament_list_event.dart';

class MedicamentListBloc
    extends Bloc<MedicamentListEvent, MedicamentListState> {
  final BaseMedicamentProvider provider;

  MedicamentListBloc(this.provider) : super(MedicamentListInitialState()) {
    on<GetMedicamentListEvent>(_onGetMedicamentListEvent);
    on<AddMedicamentEvent>(_onAddMedicamentEvent);
    on<AddRangeOfMedicamentEvent>(_onAddRangeOfMedicamentEvent);
  }

  void _onGetMedicamentListEvent(
      GetMedicamentListEvent event, Emitter<MedicamentListState> emit) async {
    emit(state.copyLoading());
    final medicamentList = provider.getMedicamentList();
    emit(state.copyWith(medicamentList: medicamentList, isLoading: false));
  }

  void _onAddMedicamentEvent(
      AddMedicamentEvent event, Emitter<MedicamentListState> emit) async {
    emit(state.copyLoading());
    await provider.addMedicament(
        event.date, event.title, event.hour, event.medicament);
    final medicamentList = provider.getMedicamentList();
    emit(MedicamentAddedState(medicamentList));
  }

  void _onAddRangeOfMedicamentEvent(AddRangeOfMedicamentEvent event,
      Emitter<MedicamentListState> emit) async {
    emit(state.copyLoading());
    await provider.addRangeOfMedicament(event.fromDate, event.toDate,
        event.title, event.hour, event.medicamentList);
    final medicamentList = provider.getMedicamentList();
    emit(RangeMedicamentAddedState(medicamentList));
  }
}
