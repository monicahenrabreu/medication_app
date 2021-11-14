import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medicaments_app/bloc/medicament_list_bloc/medicament_list_bloc.dart';
import 'package:medicaments_app/bloc/medicament_list_bloc/medicament_list_event.dart';
import 'package:medicaments_app/bloc/medicament_list_bloc/medicament_list_state.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:medicaments_app/ui/screens/widgets/date_time_medicament_picker.dart';
import 'package:medicaments_app/ui/screens/widgets/days_choosed_medicament.dart';
import 'package:medicaments_app/ui/screens/widgets/save_cancel_medicament_button.dart';
import 'package:medicaments_app/ui/screens/widgets/text_medicament_form_field.dart';
import 'package:table_calendar/table_calendar.dart';
import '../home/utils.dart';

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
  late List<Medicament> _selectedEvents;

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
        title: const Text('Add Medicament'),
      ),
      body: BlocBuilder<MedicamentListBloc, MedicamentListState>(
        builder: (context, state) {
          return Column(
            children: [buildCalendar(), _buildFormToAddMedicament()],
          );
        },
      ),
    );
  }

  Padding _buildFormToAddMedicament() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Wrap(
          alignment: WrapAlignment.start,
          runSpacing: 20.0,
          children: [
            TextMedicamentFormField(_controllerName),
            const SizedBox(
              height: 10.0,
            ),
            DaysChoosedMedicament(_selectedDay, _rangeStart, _rangeEnd),
            const SizedBox(
              height: 10.0,
            ),
            DateTimeMedicamentPicker(_timePickerController),
            SaveCancelMedicamentButton(_onPressedCancel, _onPressedSave),
          ],
        ),
      ),
    );
  }

  TableCalendar<dynamic> buildCalendar() {
    return TableCalendar(
      firstDay: calendarFirstDay,
      lastDay: calendarLastDay,
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
    );
  }

  _onPressedSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    DateTime _time = _timeFormat.parse(_timePickerController.value.text);
    Medicament medicament =
        Medicament(title: _controllerName.text, hour: _time);

    setState(() {
      _selectedEvents.add(medicament);
    });

    if (_selectedDay != null) {
      context
          .read<MedicamentListBloc>()
          .add(AddMedicamentEvent(medicament, _selectedDay!));
    }

    if (_rangeStart != null && _rangeEnd != null) {
      context
          .read<MedicamentListBloc>()
          .add(AddRangeOfMedicamentEvent(medicament, _rangeStart!, _rangeEnd!));
    }

    Navigator.of(context).pop();
  }

  _onPressedCancel() {
    Navigator.of(context).pop();
  }
}
