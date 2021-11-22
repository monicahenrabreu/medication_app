import 'dart:collection';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicaments_app/bloc/calendar/bloc.dart';
import 'package:medicaments_app/data/models/calendar.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:medicaments_app/ui/screens/home/utils.dart';
import 'package:provider/src/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatefulWidget {
  final LinkedHashMap<DateTime, List<Medicament>>? medicamentList;

  const CalendarWidget({Key? key, this.medicamentList}) : super(key: key);

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
        onRangeSelected: _onRangeSelected,
        onFormatChanged: _onFormatChanged,
        onPageChanged: _onPageChanged,
        calendarBuilders: _calendarBuilder(),
      );
    });
  }

  List<Medicament> _getEventsForDay(DateTime date) {
    //since this param date is comming with Z at the end, we need to remove it
    final _dateFormat = DateFormat('d MMM yyyy');
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
    context.read<CalendarBloc>().add(CalendarOnRangeSelectedEvent(calendar));
  }

  void _onPageChanged(DateTime focusedDay) {
    context.read<CalendarBloc>().add(CalendarOnPageChangedEvent(focusedDay));
  }

  void _onFormatChanged(CalendarFormat format) {
    context.read<CalendarBloc>().add(CalendarOnFormatChangedEvent(format));
  }

  _calendarBuilder() {
    return CalendarBuilders<Medicament>(
      markerBuilder: (context, date, events) {
        Widget children = Container();

        if (events.isNotEmpty) {
          children = Positioned(
            child: _buildEventsMarker(date, events),
          );
        }
        return children;
      },
    );
  }

  Widget _buildEventsMarker(DateTime date, List<Medicament> medicaments) {
    bool took = true;

    for (Medicament medicament in medicaments) {
      if (medicament.tookPill == TookPill.didNotTook) {
        took = false;
      }
    }

    DateTime now = DateTime.now();

    if (date.compareTo(DateTime(now.year, now.month, now.day)) < 0) {
      return Opacity(
        opacity: 0.9,
        child: Container(
            margin: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: took ? Colors.green : Colors.red,
            ),
            child: took
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                  )
                : Transform.rotate(
                    angle: 180,
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ))),
      );
    }

    return Badge(
      badgeColor: Colors.grey,
      badgeContent: Text(
        medicaments.length.toString(),
        style: const TextStyle().copyWith(
          color: Colors.white,
          fontSize: 10.0,
        ),
      ),
    );
  }
}
