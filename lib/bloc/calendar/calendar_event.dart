import 'dart:collection';
import 'package:equatable/equatable.dart';
import 'package:medicaments_app/data/models/calendar.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:table_calendar/table_calendar.dart';

abstract class CalendarEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CalendarOnDaySelectedEvent extends CalendarEvent {
  final Calendar calendar;
  final LinkedHashMap<DateTime, List<Medicament>>? medicamentList;

  CalendarOnDaySelectedEvent(this.calendar, this.medicamentList);

  @override
  List<Object?> get props => [calendar, medicamentList];
}

class CalendarOnRangeSelectedEvent extends CalendarEvent {
  final Calendar calendar;
  final LinkedHashMap<DateTime, List<Medicament>>? medicamentList;

  CalendarOnRangeSelectedEvent(this.calendar, this.medicamentList);

  @override
  List<Object?> get props => [calendar, medicamentList];
}

class CalendarOnPageChangedEvent extends CalendarEvent {
  final DateTime focusedDay;

  CalendarOnPageChangedEvent(this.focusedDay);

  @override
  List<Object?> get props => [focusedDay];
}

class CalendarOnFormatChangedEvent extends CalendarEvent {
  final CalendarFormat format;

  CalendarOnFormatChangedEvent(this.format);

  @override
  List<Object?> get props => [format];
}

class CalendarOnAddMedicamentEvent extends CalendarEvent {
  final Calendar calendar;
  final LinkedHashMap<DateTime, List<Medicament>>? medicamentList;

  CalendarOnAddMedicamentEvent(this.calendar, this.medicamentList);

  @override
  List<Object?> get props => [calendar, medicamentList];
}

class CalendarOnAddRangeOfMedicamentEvent extends CalendarEvent {
  final Calendar calendar;
  final LinkedHashMap<DateTime, List<Medicament>>? medicamentList;

  CalendarOnAddRangeOfMedicamentEvent(this.calendar, this.medicamentList);

  @override
  List<Object?> get props => [calendar, medicamentList];
}
