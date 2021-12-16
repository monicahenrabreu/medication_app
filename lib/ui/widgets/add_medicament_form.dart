import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:medicaments_app/bloc/notification/bloc.dart';
import 'package:intl/intl.dart';
import 'package:medicaments_app/configs/constants.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:medicaments_app/ui/widgets/date_time_medicament_picker.dart';
import 'package:medicaments_app/ui/widgets/days_choosed_medicament.dart';
import 'package:medicaments_app/ui/widgets/save_cancel_medicament_button.dart';
import 'package:medicaments_app/ui/widgets/text_medicament_form_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicaments_app/bloc/calendar/bloc.dart';
import 'package:medicaments_app/bloc/medicament_list_bloc/bloc.dart';
import 'package:medicaments_app/data/models/calendar.dart';
import 'package:uuid/uuid.dart';

class AddMedicamentForm extends StatefulWidget {
  const AddMedicamentForm({Key? key}) : super(key: key);

  @override
  State<AddMedicamentForm> createState() => _AddMedicamentFormState();
}

class _AddMedicamentFormState extends State<AddMedicamentForm> {
  final TextEditingController _controllerName = TextEditingController();
  late TextEditingController _timePickerController;
  final _formKey = GlobalKey<FormState>();
  final DateFormat _timeFormat = DateFormat(Constants.hourFormat);

  @override
  void initState() {
    super.initState();
    _timePickerController =
        TextEditingController(text: _timeFormat.format(DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Wrap(
          alignment: WrapAlignment.start,
          runSpacing: 20.0,
          children: [
            TextMedicamentFormField(controllerName: _controllerName),
            const SizedBox(
              height: 10.0,
            ),
            const DaysChoosedMedicament(),
            const SizedBox(
              height: 10.0,
            ),
            DateTimeMedicamentPicker(
              timePickerController: _timePickerController,
            ),
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
    Calendar? calendar = context.read<CalendarBloc>().state.calendar;

    if (calendar != null) {
      if (calendar.selectedDay != null) {
        final _dateFormat = DateFormat(Constants.dateFormat);
        final date = _dateFormat.format(calendar.selectedDay!);

        var uuid = const Uuid();

        String id = date + '--' + uuid.v1();

        Medicament medicament =
            Medicament(id: id, title: _controllerName.text, hour: _time);
        context.read<MedicamentListBloc>().add(AddMedicamentEvent(
            calendar.selectedDay!, _controllerName.text, _time, medicament));

        DateTime notificationDate = DateTime(
            calendar.selectedDay!.year,
            calendar.selectedDay!.month,
            calendar.selectedDay!.day,
            _time.hour,
            _time.minute);

        context
            .read<NotificationBloc>()
            .add(ScheduleDailyNotificationEvent(notificationDate, medicament));
      }

      if (calendar.rangeStartDay != null && calendar.rangeEndDay != null) {
        DateTime formDddate = calendar.rangeStartDay!;
        final toDate = calendar.rangeEndDay;
        List<Medicament> medicamentList = List.of([]);

        while (formDddate.compareTo(toDate!) <= 0) {
          final _dateFormat = DateFormat(Constants.dateFormat);
          final _formatedDate = _dateFormat.format(formDddate);

          var uuid = const Uuid();

          String id = _formatedDate + '--' + uuid.v1();

          Medicament medicament =
              Medicament(id: id, title: _controllerName.text, hour: _time);

          medicamentList.add(medicament);

          DateTime notificationDate = DateTime(formDddate.year,
              formDddate.month, formDddate.day, _time.hour, _time.minute);

          print('notificationDate: ' + notificationDate.toString());

          context.read<NotificationBloc>().add(
              ScheduleDailyNotificationEvent(notificationDate, medicament));

          formDddate = formDddate.add(const Duration(days: 1));
        }

        context.read<MedicamentListBloc>().add(AddRangeOfMedicamentEvent(
            calendar.rangeStartDay!,
            calendar.rangeEndDay!,
            _controllerName.text,
            _time,
            medicamentList));
      }
    }
  }

  _onPressedCancel() {
    Navigator.of(context).pop();
  }
}
