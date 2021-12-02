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
import 'package:medicaments_app/ui/widgets/calendar_widget.dart';
import 'package:medicaments_app/ui/widgets/date_time_medicament_picker.dart';
import 'package:medicaments_app/ui/widgets/days_choosed_medicament.dart';
import 'package:medicaments_app/ui/widgets/save_cancel_medicament_button.dart';
import 'package:medicaments_app/ui/widgets/text_medicament_form_field.dart';

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
      body: BlocListener<MedicamentListBloc, MedicamentListState>(
        listener: (context, state) {
          if(state is MedicamentAddedState || state is RangeMedicamentAddedState){
            final LinkedHashMap<DateTime, List<Medicament>>? medicamentList =
                context.read<MedicamentListBloc>().state.medicamentList;

            Calendar? calendar = context.read<CalendarBloc>().state.calendar;

            context
                .read<CalendarBloc>()
                .add(CalendarOnAddMedicamentEvent(calendar!, medicamentList));
            Navigator.of(context).pop();
          }
        },
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
              children: [const CalendarWidget(), _buildFormToAddMedicament()],
            ),
        ),
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
        context
            .read<MedicamentListBloc>()
            .add(AddMedicamentEvent(medicament, calendar.selectedDay!));
      }

      if (calendar.rangeStartDay != null && calendar.rangeEndDay != null) {
        context.read<MedicamentListBloc>().add(AddRangeOfMedicamentEvent(
            medicament, calendar.rangeStartDay!, calendar.rangeEndDay!));
      }

      if (calendar.selectedDay != null ||
          (calendar.rangeStartDay != null && calendar.rangeEndDay != null)) {
        DateTime date = DateTime(
            calendar.selectedDay!.year,
            calendar.selectedDay!.month,
            calendar.selectedDay!.day,
            _time.hour,
            _time.minute);
        context
            .read<NotificationBloc>()
            .add(ScheduleDailyNotificationEvent(date, medicament));
      }
    }
  }

  _onPressedCancel() {
    Navigator.of(context).pop();
  }
}
