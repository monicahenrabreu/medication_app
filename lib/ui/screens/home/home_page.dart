import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:medicaments_app/bloc/medicament_list_bloc/bloc.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:medicaments_app/ui/screens/add_medicament/add_medicament_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:badges/badges.dart';
import 'utils.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ValueNotifier<List<Medicament>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    context.read<MedicamentListBloc>().add(GetMedicamentListEvent());
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Medicament> _getEventsForDay(DateTime date) {
    //since this param date is comming with Z at the end, we need to remove it
    final _dateFormat = DateFormat('d MMM yyyy');
    String dateInString = _dateFormat.format(date);
    DateTime dateTransformed = _dateFormat.parse(dateInString);

    LinkedHashMap<DateTime, List<Medicament>>? medicamentList =
        context.read<MedicamentListBloc>().state.medicamentList;
    return medicamentList![dateTransformed] ?? [];
  }

  List<Medicament> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('medicaments'),
      ),
      body: BlocBuilder<MedicamentListBloc, MedicamentListState>(
        builder: (context, state) {
          if (state is MedicamentListLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: [
              _buildCalendar(),
              const SizedBox(height: 8.0),
              _addMedicamentIcon(context),
              const SizedBox(height: 8.0),
              _buildMedicamentListOfDay(),
            ],
          );
        },
      ),
    );
  }

  TableCalendar<Medicament> _buildCalendar() {
    return TableCalendar<Medicament>(
      firstDay: calendarFirstDay,
      lastDay: calendarLastDay,
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      rangeStartDay: _rangeStart,
      rangeEndDay: _rangeEnd,
      calendarFormat: _calendarFormat,
      rangeSelectionMode: _rangeSelectionMode,
      eventLoader: _getEventsForDay,
      startingDayOfWeek: StartingDayOfWeek.monday,
      onDaySelected: _onDaySelected,
      onRangeSelected: _onRangeSelected,
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      calendarBuilders: _calendarBuilder(),
    );
  }

  Expanded _buildMedicamentListOfDay() {
    return Expanded(
      child: ValueListenableBuilder<List<Medicament>>(
        valueListenable: _selectedEvents,
        builder: (context, value, _) {
          return ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListTile(
                  title: Text(value[index].title),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Align _addMedicamentIcon(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddMedicamentPage()),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
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
