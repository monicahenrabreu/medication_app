import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DaysChoosedMedicament extends StatelessWidget {
  final DateTime? selectedDay;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;

  const DaysChoosedMedicament(this.selectedDay, this.rangeStart, this.rangeEnd,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _dateFormat = DateFormat('d MMM yyyy');

    return Column(
      children: [
        selectedDay != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Only one day'),
                  Text(_dateFormat.format(selectedDay!)),
                ],
              )
            : Container(),
        rangeStart != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('From'),
                  Text(_dateFormat.format(rangeStart!)),
                ],
              )
            : Container(),
        const SizedBox(
          height: 10.0,
        ),
        rangeEnd != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('To'),
                  Text(_dateFormat.format(rangeEnd!)),
                ],
              )
            : Container()
      ],
    );
  }
}
