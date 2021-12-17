import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicaments_app/bloc/calendar/bloc.dart';
import 'package:medicaments_app/configs/constants.dart';
import 'package:medicaments_app/data/models/calendar.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:medicaments_app/ui/screens/home/utils.dart';
import 'package:medicaments_app/ui/widgets/medicament_calendar_marker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatefulWidget {
  final LinkedHashMap<DateTime, List<Medicament>>? medicamentList;

  //if hasRange is true it will be possible to select a range
  final bool hasRange;

  const CalendarWidget({Key? key, this.medicamentList, this.hasRange = false})
      : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(builder: (context, state) {
      return TableCalendar<Medicament>(
        firstDay: calendarFirstDay,
        lastDay: calendarLastDay,
        focusedDay: state.calendar!.focusedDay,
        selectedDayPredicate: (day) =>
            isSameDay(state.calendar!.selectedDay, day),
        rangeStartDay: state.calendar!.rangeStartDay,
        rangeEndDay: state.calendar!.rangeEndDay,
        calendarFormat: state.calendar!.calendarFormat,
        rangeSelectionMode: state.calendar!.rangeSelectionMode,
        eventLoader: widget.medicamentList == null ? null : _getEventsForDay,
        startingDayOfWeek: StartingDayOfWeek.monday,
        onDaySelected: _onDaySelected,
        onRangeSelected: widget.hasRange ? _onRangeSelected : null,
        availableCalendarFormats: const {
          CalendarFormat.month: 'Month',
        },
        onPageChanged: _onPageChanged,
        calendarBuilders: _calendarBuilder(),
      );
    });
  }

  List<Medicament> _getEventsForDay(DateTime date) {
    //since this param date is comming with Z at the end, we need to remove it
    final _dateFormat = DateFormat(Constants.dateFormat);
    String dateInString = _dateFormat.format(date);
    DateTime dateTransformed = _dateFormat.parse(dateInString);
    return widget.medicamentList![dateTransformed] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    Calendar calendar = Calendar(
        firstDay: calendarFirstDay,
        lastDay: calendarLastDay,
        selectedDay: selectedDay,
        focusedDay: focusedDay);
    context
        .read<CalendarBloc>()
        .add(CalendarOnDaySelectedEvent(calendar, widget.medicamentList));
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    Calendar calendar = Calendar(
        firstDay: calendarFirstDay,
        lastDay: calendarLastDay,
        focusedDay: focusedDay,
        rangeStartDay: start,
        rangeEndDay: end);
    context
        .read<CalendarBloc>()
        .add(CalendarOnRangeSelectedEvent(calendar, widget.medicamentList));
  }

  void _onPageChanged(DateTime focusedDay) {
    context.read<CalendarBloc>().add(CalendarOnPageChangedEvent(focusedDay));
  }

  _calendarBuilder() {
    return CalendarBuilders<Medicament>(
      markerBuilder: (context, date, medicaments) {
        Widget children = Container();

        if (medicaments.isNotEmpty) {
          children = Positioned(
            child:
                MedicamentCalendarMarker(date: date, medicaments: medicaments),
          );
        }
        return children;
      },
    );
  }
}
