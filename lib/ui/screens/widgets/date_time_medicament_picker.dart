import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class DateTimeMedicamentPicker extends StatelessWidget {
  final TextEditingController timePickerController;

  const DateTimeMedicamentPicker(this.timePickerController, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DateTimePicker(
      type: DateTimePickerType.time,
      controller: timePickerController,
      icon: const Padding(
        padding: EdgeInsets.fromLTRB(5.0, 4.0, 0.0, 1.0),
        child: Icon(Icons.event),
      ),
      timeLabelText: 'DueTime',
    );
  }
}
