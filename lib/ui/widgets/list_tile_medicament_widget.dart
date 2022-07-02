import 'package:flutter/material.dart';
import 'package:medicaments_app/configs/constants.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:intl/intl.dart';
import 'package:medicaments_app/ui/widgets/list_tile_medicament_subtitle_widget.dart';

class ListTileMedicamentWidget extends StatelessWidget {
  ListTileMedicamentWidget(
      {Key? key, required this.medicament, this.showDetails = false})
      : super(key: key);

  final Medicament medicament;
  final bool showDetails;

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
          style: const TextStyle(fontSize: 14),
        ),
        subtitle: showDetails
            ? ListTileMedicamentSubtitleWidget(
                medicament: medicament,
              )
            : null,
        trailing: showDetails && medicament.hour.compareTo(DateTime.now()) < 0
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
