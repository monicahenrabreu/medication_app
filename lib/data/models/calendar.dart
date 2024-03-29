import 'package:equatable/equatable.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends Equatable {
  final DateTime firstDay;
  final DateTime lastDay;
  DateTime focusedDay;
  DateTime? selectedDay;
  DateTime? rangeStartDay;
  DateTime? rangeEndDay;
  RangeSelectionMode rangeSelectionMode;
  CalendarFormat calendarFormat;
  List<Medicament>? selectedEvents;

  Calendar(
      {required this.firstDay,
      required this.lastDay,
      required this.focusedDay,
      this.selectedDay,
      this.rangeStartDay,
      this.rangeEndDay,
      this.rangeSelectionMode = RangeSelectionMode.toggledOff,
      this.calendarFormat = CalendarFormat.month,
      this.selectedEvents});

  @override
  List<Object?> get props => [
        firstDay,
        lastDay,
        focusedDay,
        selectedDay,
        rangeStartDay,
        rangeSelectionMode,
        calendarFormat,
        selectedEvents
      ];
}
