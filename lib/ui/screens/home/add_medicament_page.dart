import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:medicaments_app/models/medicament_event.dart';
import 'package:table_calendar/table_calendar.dart';
import 'utils.dart';

class AddMedicamentPage extends StatefulWidget {
  @override
  _AddMedicamentPageState createState() => _AddMedicamentPageState();
}

class _AddMedicamentPageState extends State<AddMedicamentPage> {
  final TextEditingController _controllerName = TextEditingController();
  late TextEditingController _timePickerController;
  final _formKey = GlobalKey<FormState>();
  final DateFormat _timeFormat = DateFormat('HH:mm');
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  final _dateFormat = DateFormat('d MMM yyyy');
  late List<MedicamentEvent> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _selectedEvents = List.of([]);
    _selectedDay = _focusedDay;
    _timePickerController =
        TextEditingController(text: _timeFormat.format(DateTime.now()));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Add Pill'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
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
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Wrap(
                alignment: WrapAlignment.start,
                runSpacing: 20.0,
                children: [
                  TextFormField(
                      controller: _controllerName,
                      validator: _validateName,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          labelText: 'Pill name',
                          labelStyle:
                              const TextStyle(fontSize: 18, color: Colors.grey),
                          hintText: 'ex: Benuron',
                          hintStyle: const TextStyle(color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16)))),
                  const SizedBox(
                    height: 10.0,
                  ),
                  _selectedDay != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Only one day'),
                            Text(_dateFormat.format(_selectedDay!)),
                          ],
                        )
                      : Container(),
                  _rangeStart != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('From'),
                            Text(_dateFormat.format(_rangeStart!)),
                          ],
                        )
                      : Container(),
                  const SizedBox(
                    height: 10.0,
                  ),
                  _rangeEnd != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('To'),
                            Text(_dateFormat.format(_rangeEnd!)),
                          ],
                        )
                      : Container(),
                  const SizedBox(
                    height: 10.0,
                  ),
                  DateTimePicker(
                    type: DateTimePickerType.time,
                    controller: _timePickerController,
                    icon: const Padding(
                      padding: EdgeInsets.fromLTRB(5.0, 4.0, 0.0, 1.0),
                      child: Icon(Icons.event),
                    ),
                    timeLabelText: 'DueTime',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        child: Text('Cancel'),
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 18),
                          primary: Theme.of(context).primaryColor,
                        ),
                        onPressed: _onPressedCancel,
                      ),
                      ElevatedButton(
                        child: Text('Save'),
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 18),
                          primary: Theme.of(context).primaryColor,
                        ),
                        onPressed: () => _onPressedSave(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String? _validateName(String? text) {
    if (text == null || text.isEmpty) {
      return 'NoName';
    }
    return null;
  }

  _onPressedSave(context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    DateTime _time = _timeFormat.parse(_timePickerController.value.text);
    MedicamentEvent event =
        MedicamentEvent(title: _controllerName.text, hour: _time);

    setState(() {
      _selectedEvents.add(event);
    });

    if (_selectedDay != null) {
      addEvent(event, _selectedDay!);
    }

    if (_rangeStart != null && _rangeEnd != null) {
      addRangeOfEvents(event, _rangeStart!, _rangeEnd!);
    }

    Navigator.of(context).pop();
  }

  _onPressedCancel() {
    Navigator.of(context).pop();
  }
}
