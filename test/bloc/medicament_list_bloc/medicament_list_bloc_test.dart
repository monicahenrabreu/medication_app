import 'dart:collection';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicaments_app/bloc/medicament_list_bloc/bloc.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  group("GetMedicamentListEvent", () {
    late MockMedicamentProvider provider;
    late MedicamentListBloc bloc;

    final medicamentList = LinkedHashMap<DateTime, List<Medicament>>.from(
      {
        DateTime(2021, 12, 12): [
          Medicament(
            id: "",
            title: "",
            hour: DateTime(2021, 12, 12),
          ),
        ],
      },
    );

    setUp(() {
      provider = MockMedicamentProvider();
    });

    blocTest<MedicamentListBloc, MedicamentListState>(
      'emits isLoading: true when GetMedicamentListEvent is called',
      build: () => MedicamentListBloc(provider),
      act: (bloc) => bloc.add(GetMedicamentListEvent()),
      expect: () => <MedicamentListState>[
        MedicamentListLoadingState(
            medicamentList: LinkedHashMap<DateTime, List<Medicament>>())
      ],
    );

    blocTest<MedicamentListBloc, MedicamentListState>(
      'emits isLoading: true when GetMedicamentListEvent is called',
      build: () => MedicamentListBloc(provider),
      act: (bloc) => bloc.add(GetMedicamentListEvent()),
      setUp: () {
        when(() => provider.getMedicamentList()).thenReturn(medicamentList);
      },
      expect: () => <MedicamentListState>[
        MedicamentListLoadingState(
          medicamentList: LinkedHashMap<DateTime, List<Medicament>>(),
        ),
        MedicamentListState(isLoading: false, medicamentList: medicamentList),
      ],
    );
  });
}
