import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicaments_app/bloc/user_medicament_list_bloc/bloc.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:medicaments_app/data/provider/base_medicament_provider.dart';

class UserMedicamentListCubit extends Cubit<UserMedicamentListState> {
  final BaseMedicamentProvider provider;

  UserMedicamentListCubit(this.provider)
      : super(UserMedicamentListInitialState());

  void getUserMedicamentListEvent() async {
    final medicamentList = provider.getUserMedicamentList();
    emit(GetUserMedicamentList(medicamentList: medicamentList));
  }

  void removeUserMedicamentEvent(Medicament medicament) async {
    await provider.removeUserMedicament(medicament.id);
    final medicamentList = provider.getUserMedicamentList();
    emit(RemoveUserMedicamentList(medicamentList: medicamentList));
  }
}
