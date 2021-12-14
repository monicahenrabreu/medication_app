import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicaments_app/bloc/user_medicament_list_bloc/bloc.dart';
import 'package:medicaments_app/data/provider/medicament_provider.dart';

class UserMedicamentListBloc
    extends Bloc<UserMedicamentListEvent, UserMedicamentListState> {
  final MedicamentProvider provider;

  UserMedicamentListBloc(this.provider)
      : super(UserMedicamentListInitialState()) {
    on<GetUserMedicamentListEvent>(_onGetUserMedicamentListEvent);
  }

  //TODO: QUESTION
  void _onGetUserMedicamentListEvent(GetUserMedicamentListEvent event,
      Emitter<UserMedicamentListState> emit) async {
    emit(state.copyLoading(isLoading: true));
    final medicamentList = provider.getUserMedicamentList();
    //emit(state.copyWith(medicamentList: medicamentList));
    emit(UserMedicamentListLoadedState(medicamentList));
  }
}
