import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicaments_app/bloc/user_medicament_list_bloc/bloc.dart';
import 'package:medicaments_app/data/provider/base_medicament_provider.dart';

class UserMedicamentListBloc
    extends Bloc<UserMedicamentListEvent, UserMedicamentListState> {
  final BaseMedicamentProvider provider;

  UserMedicamentListBloc(this.provider)
      : super(UserMedicamentListInitialState()) {
    on<GetUserMedicamentListEvent>(_onGetUserMedicamentListEvent);
  }

  void _onGetUserMedicamentListEvent(GetUserMedicamentListEvent event,
      Emitter<UserMedicamentListState> emit) async {
    emit(state.copyLoading(isLoading: true));
    final medicamentList = provider.getUserMedicamentList();
    emit(state.copyResult(medicamentList: medicamentList));
  }
}
