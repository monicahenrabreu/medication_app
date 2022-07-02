import 'package:flutter/material.dart';
import 'package:medicaments_app/configs/constants.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:intl/intl.dart';

class ListTileMedicamentWidget extends StatelessWidget {
  ListTileMedicamentWidget({Key? key, required this.medicament})
      : super(key: key);

  final Medicament medicament;

  final DateFormat _timeFormat = DateFormat(Constants.hourFormat);

  @override
  Widget build(BuildContext context) {
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
        title: Text(
          '${medicament.title} - ${_timeFormat.format(medicament.hour)}',
          style: TextStyle(fontSize: 14),
        ),
        trailing: medicament.hour.compareTo(DateTime.now()) < 0
            ? (medicament.tookMedicament
                ? const Icon(
                    Icons.check,
                    color: Colors.green,
                  )
                : const Icon(
                    Icons.close,
                    color: Colors.red,
                  ))
            : null,
      ),
    );
  }
}
