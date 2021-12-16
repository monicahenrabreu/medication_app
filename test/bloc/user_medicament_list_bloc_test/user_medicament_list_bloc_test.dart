import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicaments_app/bloc/user_medicament_list_bloc/bloc.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  group("GetUserMedicamentListEvent", () {
    late MockMedicamentProvider provider;

    final medicamentList = List<Medicament>.from(
      {
        Medicament(
          id: '1',
          title: 'Bruffen',
          hour: DateTime(2021, 12, 12),
        ),
      },
    );

    setUp(() {
      provider = MockMedicamentProvider();
    });

    blocTest<UserMedicamentListBloc, UserMedicamentListState>(
      'emits isLoading: true and when UserMedicamentListBloc is called'
          'and emits isLoading: false and retrieves the medicamentList',
      build: () => UserMedicamentListBloc(provider),
      act: (bloc) => bloc.add(GetUserMedicamentListEvent()),
      setUp: () {
        when(() => provider.getUserMedicamentList()).thenReturn(medicamentList);
      },
      expect: () => <UserMedicamentListState>[
        UserMedicamentListLoadingState(
            isLoading: true, medicamentList: const []),
        UserMedicamentListLoadedState(medicamentList: medicamentList)
      ],
    );
  });
}
