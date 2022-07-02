import 'package:flutter/material.dart';
import 'package:medicaments_app/configs/constants.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:intl/intl.dart';

class ListTileMedicamentSubtitleWidget extends StatelessWidget {
  ListTileMedicamentSubtitleWidget(
      {Key? key, required this.medicament,})
      : super(key: key);

  final Medicament medicament;

  final DateFormat _dateFormat = DateFormat(Constants.dateFormat);

  @override
  Widget build(BuildContext context) {
    if (medicament.dateOnlyOneTime != null) {
      return Text(
        _dateFormat.format(medicament.dateOnlyOneTime!),
        style: const TextStyle(fontSize: 14),
      );
    }

    return Text(
      '${_dateFormat.format(medicament.fromDate!)} - ${_dateFormat.format(medicament.toDate!)}',
      style: const TextStyle(fontSize: 14),
    );
  }
}
