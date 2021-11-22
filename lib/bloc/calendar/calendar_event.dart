import 'dart:collection';
import 'package:medicaments_app/data/models/calendar.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:table_calendar/table_calendar.dart';

abstract class CalendarEvent {}

class GetCalendarEventsForDayEvent extends CalendarEvent {
  final DateTime date;
  final LinkedHashMap<DateTime, List<Medicament>>? medicamentList;

  GetCalendarEventsForDayEvent(this.date, this.medicamentList);
}

class CalendarOnDaySelectedEvent extends CalendarEvent {
  final Calendar calendar;
  final LinkedHashMap<DateTime, List<Medicament>>? medicamentList;

  CalendarOnDaySelectedEvent(this.calendar, this.medicamentList);
}

class CalendarOnRangeSelectedEvent extends CalendarEvent {
  final Calendar calendar;

  CalendarOnRangeSelectedEvent(this.calendar);
}

class CalendarOnPageChangedEvent extends CalendarEvent {
  final DateTime focusedDay;

  CalendarOnPageChangedEvent(this.focusedDay);
}

class CalendarOnFormatChangedEvent extends CalendarEvent {
  final CalendarFormat format;

  CalendarOnFormatChangedEvent(this.format);
}

class CalendarOnAddMedicamentEvent extends CalendarEvent {
  final Calendar calendar;
  final LinkedHashMap<DateTime, List<Medicament>>? medicamentList;

  CalendarOnAddMedicamentEvent(this.calendar, this.medicamentList);
}
