import 'dart:collection';
import 'package:equatable/equatable.dart';
import 'package:medicaments_app/data/models/calendar.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:medicaments_app/ui/screens/home/utils.dart';

class CalendarState extends Equatable {
  final bool isLoading;
  final Calendar? calendar;
  final LinkedHashMap<DateTime, List<Medicament>>? medicamentList;

  CalendarState(this.isLoading, this.calendar, this.medicamentList);

  CalendarState copyWith({
    bool? isLoading,
    Calendar? calendar,
    LinkedHashMap<DateTime, List<Medicament>>? medicamentList,
  }) {
    return CalendarState(isLoading ?? this.isLoading, calendar ?? this.calendar,
        medicamentList ?? this.medicamentList);
  }

  CalendarState copyLoading({
    bool? isLoading,
  }) {
    return CalendarState(isLoading ?? this.isLoading, calendar, medicamentList);
  }

  CalendarAddedMedicamentState copyAddedMedicament(
    Calendar? calendar,
    LinkedHashMap<DateTime, List<Medicament>>? medicamentList,
  ) {
    return CalendarAddedMedicamentState(calendar, medicamentList);
  }

  @override
  List<Object?> get props => [isLoading, calendar, medicamentList];
}

class CalendarInitialState extends CalendarState {
  CalendarInitialState()
      : super(
            false,
            Calendar(
                firstDay: calendarFirstDay,
                lastDay: calendarLastDay,
                focusedDay: calendarToday,
                selectedDay: calendarToday),
            LinkedHashMap<DateTime, List<Medicament>>());
}

class CalendarLoadingState extends CalendarState {
  CalendarLoadingState(Calendar? calendar,
      LinkedHashMap<DateTime, List<Medicament>>? medicamentList)
      : super(true, calendar, medicamentList);
}

class CalendarLoadedState extends CalendarState {
  CalendarLoadedState(Calendar? calendar,
      LinkedHashMap<DateTime, List<Medicament>>? medicamentList)
      : super(false, calendar, medicamentList);
}

class CalendarAddedMedicamentState extends CalendarState {
  CalendarAddedMedicamentState(Calendar? calendar,
      LinkedHashMap<DateTime, List<Medicament>>? medicamentList)
      : super(false, calendar, medicamentList);
}
