import 'package:flutter/material.dart';
import 'package:medicaments_app/configs/constants.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:intl/intl.dart';
import 'package:medicaments_app/ui/widgets/list_tile_medicament_subtitle_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicaments_app/data/provider/medicament_provider.dart';

class ListTileMedicamentWidget extends StatelessWidget {
  ListTileMedicamentWidget(
      {Key? key,
      required this.medicament,
      this.showDetails = false,
      this.showSubtitle = false,
      this.dateTime})
      : super(key: key);

  final Medicament medicament;
  final bool showDetails;
  final bool showSubtitle;
  final DateTime? dateTime;

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
        subtitle: showSubtitle
            ? ListTileMedicamentSubtitleWidget(
                medicament: medicament,
              )
            : null,
        trailing: showDetails
            ? Checkbox(
                value: medicament.tookMedicament,
                onChanged: (bool? value) {
                  List<String> medicamentId =
                      medicament.id.toString().split('--');
                  final date = medicamentId.first;

                  context
                      .read<MedicamentProvider>()
                      .editMedicament(date, medicament.id, value!);
                },
              )
            : null,
      ),
    );
  }
}
