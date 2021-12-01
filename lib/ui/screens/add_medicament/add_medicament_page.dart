import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medicaments_app/bloc/calendar/bloc.dart';
import 'package:medicaments_app/bloc/medicament_list_bloc/bloc.dart';
import 'package:medicaments_app/bloc/notification/bloc.dart';
import 'package:medicaments_app/data/models/calendar.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:medicaments_app/ui/screens/widgets/calendar_widget.dart';
import 'package:medicaments_app/ui/screens/widgets/date_time_medicament_picker.dart';
import 'package:medicaments_app/ui/screens/widgets/days_choosed_medicament.dart';
import 'package:medicaments_app/ui/screens/widgets/save_cancel_medicament_button.dart';
import 'package:medicaments_app/ui/screens/widgets/text_medicament_form_field.dart';

class AddMedicamentPage extends StatefulWidget {
  final int id;

  const AddMedicamentPage({Key? key, required this.id}) : super(key: key);

  @override
  _AddMedicamentPageState createState() => _AddMedicamentPageState();
}

class _AddMedicamentPageState extends State<AddMedicamentPage> {
  final TextEditingController _controllerName = TextEditingController();
  late TextEditingController _timePickerController;
  final _formKey = GlobalKey<FormState>();
  final DateFormat _timeFormat = DateFormat('HH:mm');

  @override
  void initState() {
    super.initState();
    _timePickerController =
        TextEditingController(text: _timeFormat.format(DateTime.now()));
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
            children: [const CalendarWidget(), _buildFormToAddMedicament()],
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
            const DaysChoosedMedicament(),
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

  _onPressedSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    DateTime _time = _timeFormat.parse(_timePickerController.value.text);
    Medicament medicament =
        Medicament(title: _controllerName.text, hour: _time);

    Calendar? calendar = context.read<CalendarBloc>().state.calendar;

    if (calendar != null) {
      if (calendar.selectedDay != null) {
        //TODO: Check aqui
        context
            .read<MedicamentListBloc>()
            .add(AddMedicamentEvent(medicament, calendar.selectedDay!));

        final LinkedHashMap<DateTime, List<Medicament>>? medicamentList =
            context.read<MedicamentListBloc>().state.medicamentList;

        context
            .read<CalendarBloc>()
            .add(CalendarOnAddMedicamentEvent(calendar, medicamentList));
      }

      if (calendar.rangeStartDay != null && calendar.rangeEndDay != null) {
        context.read<MedicamentListBloc>().add(AddRangeOfMedicamentEvent(
            medicament, calendar.rangeStartDay!, calendar.rangeEndDay!));

        final LinkedHashMap<DateTime, List<Medicament>>? medicamentList =
            context.read<MedicamentListBloc>().state.medicamentList;

        context
            .read<CalendarBloc>()
            .add(CalendarOnAddMedicamentEvent(calendar, medicamentList));
      }

      if (calendar.selectedDay != null ||
          (calendar.rangeStartDay != null && calendar.rangeEndDay != null)) {
        DateTime date = DateTime(
            calendar.selectedDay!.year,
            calendar.selectedDay!.month,
            calendar.selectedDay!.day,
            _time.hour,
            _time.minute);
        //Notifications.scheduleDailyNotification(date, medicament);
        context
            .read<NotificationBloc>()
            .add(ScheduleDailyNotificationEvent(date, medicament));
      }
    }
    Navigator.of(context).pop();
  }

  _onPressedCancel() {
    Navigator.of(context).pop();
  }
}
