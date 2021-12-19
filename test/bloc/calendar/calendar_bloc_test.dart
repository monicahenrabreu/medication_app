import 'dart:collection';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicaments_app/bloc/calendar/bloc.dart';
import 'package:medicaments_app/data/models/calendar.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:medicaments_app/utils/utils.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  group("CalendarOnDaySelectedEvent", () {
    final calendar = Calendar(
      firstDay: calendarFirstDay,
      lastDay: calendarLastDay,
      focusedDay: calendarToday,
      selectedDay: DateTime(2021, 12, 12),
    );

    final calendar1Expected = Calendar(
      firstDay: calendarFirstDay,
      lastDay: calendarLastDay,
      focusedDay: calendarToday,
      selectedDay: calendarToday,
    );

    final medicamentList = LinkedHashMap<DateTime, List<Medicament>>.from(
      {
        DateTime(2021, 12, 12): [
          Medicament(
            id: "",
            title: 'Bruffen',
            fromDate: DateTime(2021, 12, 1),
            toDate: DateTime(2021, 12, 10),
            hour: DateTime(2021, 12, 12, 15, 30),
          ),
        ],
      },
    );

    final calendarExpected = Calendar(
        firstDay: calendarFirstDay,
        lastDay: calendarLastDay,
        focusedDay: calendarToday,
        selectedDay: DateTime(2021, 12, 12),
        selectedEvents: [
          Medicament(
            id: "",
            title: 'Bruffen',
            fromDate: DateTime(2021, 12, 1),
            toDate: DateTime(2021, 12, 10),
            hour: DateTime(2021, 12, 12, 15, 30),
          )
        ]);

    blocTest<CalendarBloc, CalendarState>(
      'emits isLoading: true and when CalendarOnDaySelectedEvent is called'
      'and emits isLoading: false and retrieves the calendar and the medicamentList',
      build: () => CalendarBloc(),
      act: (bloc) =>
          bloc.add(CalendarOnDaySelectedEvent(calendar, medicamentList)),
      expect: () => <CalendarState>[
        CalendarState(true, calendar1Expected,
            LinkedHashMap<DateTime, List<Medicament>>()),
        CalendarState(false, calendarExpected, medicamentList)
      ],
    );
  });

  group("CalendarOnRangeSelectedEvent", () {
    final calendar = Calendar(
        firstDay: calendarFirstDay,
        lastDay: calendarLastDay,
        focusedDay: calendarToday,
        selectedDay: calendarToday);

    final medicamentList = LinkedHashMap<DateTime, List<Medicament>>.from(
      {
        DateTime(2021, 12, 12): [
          Medicament(
            id: "",
            title: 'Bruffen',
            fromDate: DateTime(2021, 12, 1),
            toDate: DateTime(2021, 12, 10),
            hour: DateTime(2021, 12, 12, 15, 30),
          ),
        ],
      },
    );

    final calendarExpected = Calendar(
        firstDay: calendarFirstDay,
        lastDay: calendarLastDay,
        selectedDay: null,
        focusedDay: calendarToday,
        rangeStartDay: null,
        rangeEndDay: null,
        rangeSelectionMode: RangeSelectionMode.toggledOn,
        selectedEvents: null);

    blocTest<CalendarBloc, CalendarState>(
      'emits isLoading: true and when CalendarOnRangeSelectedEvent is called'
      'and emits isLoading: false and retrieves the calendar and the medicamentList',
      build: () => CalendarBloc(),
      act: (bloc) =>
          bloc.add(CalendarOnRangeSelectedEvent(calendar, medicamentList)),
      expect: () => <CalendarState>[
        CalendarState(
            true, calendar, LinkedHashMap<DateTime, List<Medicament>>()),
        CalendarState(false, calendarExpected, medicamentList)
      ],
    );
  });

  group("CalendarOnPageChangedEvent", () {
    final calendar = Calendar(
        firstDay: calendarFirstDay,
        lastDay: calendarLastDay,
        focusedDay: calendarToday,
        selectedDay: calendarToday);

    final calendarExpected = Calendar(
        firstDay: calendarFirstDay,
        lastDay: calendarLastDay,
        focusedDay: DateTime(2021, 12, 6),
        selectedDay: calendarToday,
        rangeStartDay: null,
        rangeEndDay: null,
        rangeSelectionMode: RangeSelectionMode.toggledOff,
        selectedEvents: null);

    blocTest<CalendarBloc, CalendarState>(
      'emits isLoading: true and when CalendarOnPageChangedEvent is called'
      'and emits isLoading: false and retrieves the medicamentList',
      build: () => CalendarBloc(),
      act: (bloc) =>
          bloc.add(CalendarOnPageChangedEvent(DateTime(2021, 12, 6))),
      expect: () => <CalendarState>[
        CalendarState(
            true, calendar, LinkedHashMap<DateTime, List<Medicament>>()),
        CalendarState(false, calendarExpected,
            LinkedHashMap<DateTime, List<Medicament>>())
      ],
    );
  });

  group("CalendarOnAddMedicamentEvent", () {

    final calendar = Calendar(
        firstDay: calendarFirstDay,
        lastDay: calendarLastDay,
        focusedDay: calendarToday,
        selectedDay: calendarToday);

    final medicamentList = LinkedHashMap<DateTime, List<Medicament>>.from(
      {
        DateTime(2021, 12, 12): [
          Medicament(
            id: "",
            title: 'Bruffen',
            fromDate: DateTime(2021, 12, 1),
            toDate: DateTime(2021, 12, 10),
            hour: DateTime(2021, 12, 12, 15, 30),
          ),
        ],
      },
    );

    blocTest<CalendarBloc, CalendarState>(
      'emits isLoading: true and when CalendarOnAddMedicamentEvent is called'
          'and emits isLoading: false and retrieves the medicamentList',
      build: () => CalendarBloc(),
      act: (bloc) =>
          bloc.add(CalendarOnAddMedicamentEvent(calendar, medicamentList)),
      expect: () => <CalendarState>[
        CalendarState(
            true, calendar, LinkedHashMap<DateTime, List<Medicament>>()),
        CalendarAddedMedicamentState(calendar, medicamentList)
      ],
    );
  });

  group("CalendarOnAddRangeOfMedicamentEvent", () {
    final calendar = Calendar(
        firstDay: calendarFirstDay,
        lastDay: calendarLastDay,
        focusedDay: calendarToday,
        selectedDay: calendarToday);

    final medicamentList = LinkedHashMap<DateTime, List<Medicament>>.from(
      {
        DateTime(2021, 12, 12): [
          Medicament(
            id: "",
            title: 'Bruffen',
            fromDate: DateTime(2021, 12, 1),
            toDate: DateTime(2021, 12, 10),
            hour: DateTime(2021, 12, 12, 15, 30),
          ),
        ],
      },
    );

    blocTest<CalendarBloc, CalendarState>(
      'emits isLoading: true and when CalendarOnAddRangeOfMedicamentEvent is called'
          'and emits isLoading: false and retrieves the medicamentList',
      build: () => CalendarBloc(),
      act: (bloc) => bloc
          .add(CalendarOnAddRangeOfMedicamentEvent(calendar, medicamentList)),
      expect: () => <CalendarState>[
        CalendarState(
            true, calendar, LinkedHashMap<DateTime, List<Medicament>>()),
        CalendarAddedMedicamentState(calendar, medicamentList)
      ],
    );
  });
}
