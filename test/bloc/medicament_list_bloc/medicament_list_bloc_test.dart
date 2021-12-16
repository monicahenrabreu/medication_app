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
            isLoading: true,
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
          isLoading: true,
          medicamentList: LinkedHashMap<DateTime, List<Medicament>>(),
        ),
        MedicamentListState(isLoading: false, medicamentList: medicamentList),
      ],
    );
  });

  group("AddMedicamentEvent", () {
    late MockMedicamentProvider provider;

    final DateTime date = DateTime(2021, 12, 12);
    final DateTime hour = DateTime(2021, 12, 12, 15, 30);
    const String title = 'Bruffen';
    final Medicament medicament = Medicament(
      id: "",
      title: title,
      hour: DateTime(2021, 12, 12),
    );

    final medicamentList = LinkedHashMap<DateTime, List<Medicament>>.from(
      {
        DateTime(2021, 12, 12): [
          Medicament(
            id: "",
            title: title,
            hour: DateTime(2021, 12, 12, 15, 30),
          ),
        ],
      },
    );

    setUp(() {
      provider = MockMedicamentProvider();
    });

    blocTest<MedicamentListBloc, MedicamentListState>(
      'emits isLoading: true when AddMedicamentEvent is called',
      build: () => MedicamentListBloc(provider),
      act: (bloc) =>
          bloc.add(AddMedicamentEvent(date, title, hour, medicament)),
      expect: () => <MedicamentListState>[
        MedicamentListLoadingState(
            isLoading: true,
            medicamentList: LinkedHashMap<DateTime, List<Medicament>>())
      ],
    );

    blocTest<MedicamentListBloc, MedicamentListState>(
      'emits isLoading: true when AddMedicamentEvent is called and after adding'
          'the medicament emits isLoading: false',
      build: () => MedicamentListBloc(provider),
      act: (bloc) =>
          bloc.add(AddMedicamentEvent(date, title, hour, medicament)),
      setUp: () {
        when(() => provider.addMedicament(date, medicament))
            .thenAnswer((_) => Future.value(true));
        when(() => provider.getMedicamentList()).thenReturn(medicamentList);
      },
      expect: () => <MedicamentListState>[
        MedicamentListLoadingState(
          isLoading: true,
          medicamentList: LinkedHashMap<DateTime, List<Medicament>>(),
        ),
        MedicamentAddedState(medicamentList),
      ],
    );
  });

  group("AddRangeOfMedicamentEvent", () {
    late MockMedicamentProvider provider;

    final DateTime fromDate = DateTime(2021, 12, 12);
    final DateTime toDate = DateTime(2021, 12, 15);
    final DateTime hour = DateTime(2021, 12, 12, 15, 30);
    const String title = 'Bruffen';

    final medicaments = <Medicament>[];
    final medicamentList = LinkedHashMap<DateTime, List<Medicament>>.from(
      {
        DateTime(2021, 12, 12): [
          Medicament(
            id: "",
            title: title,
            fromDate: fromDate,
            toDate: toDate,
            hour: DateTime(2021, 12, 12, 15, 30),
          ),
        ],
      },
    );

    setUp(() {
      provider = MockMedicamentProvider();
    });

    blocTest<MedicamentListBloc, MedicamentListState>(
      'emits isLoading: true when AddRangeOfMedicamentEvent is called'
          'and after adding the medicaments emits isLoading: false',
      build: () => MedicamentListBloc(provider),
      act: (bloc) => bloc.add(AddRangeOfMedicamentEvent(
          fromDate, toDate, title, hour, medicaments)),
      setUp: () {
        when(() => provider.addRangeOfMedicament(
                fromDate, toDate, title, hour, medicaments))
            .thenAnswer((_) => Future.value(true));
        when(() => provider.getMedicamentList()).thenReturn(medicamentList);
      },
      expect: () => <MedicamentListState>[
        MedicamentListLoadingState(
            isLoading: true,
            medicamentList: LinkedHashMap<DateTime, List<Medicament>>()),
        RangeMedicamentAddedState(medicamentList),
      ],
    );
  });
}
