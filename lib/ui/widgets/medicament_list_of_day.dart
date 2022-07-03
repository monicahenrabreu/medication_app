import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicaments_app/bloc/calendar/bloc.dart';
import 'package:medicaments_app/bloc/medicament_list_bloc/bloc.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medicaments_app/ui/widgets/list_tile_medicament_widget.dart';

class MedicamentListOfDay extends StatelessWidget {
  MedicamentListOfDay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LinkedHashMap<DateTime, List<Medicament>>? medicamentList =
        context.read<MedicamentListBloc>().state.copyWith().medicamentList;

    return BlocBuilder<CalendarBloc, CalendarState>(builder: (context, state) {
      if (state.copyWith().calendar!.selectedDay != null) {
        DateTime selectedDay = state.copyWith().calendar!.selectedDay!;

        DateTime day =
            DateTime(selectedDay.year, selectedDay.month, selectedDay.day);

        List<Medicament> medicaments = medicamentList![day] ?? [];

        if (medicaments.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(AppLocalizations.of(context)!.noMedicaments),
          );
        }

        return Expanded(
          child: ListView.builder(
            itemCount: medicaments.length,
            itemBuilder: (context, index) {
              return ListTileMedicamentWidget(
                medicament: medicaments[index],
                dateTime: day,
                showDetails: true,
              );
            },
          ),
        );
      } else {
        return const CircularProgressIndicator();
      }
    });
  }
}
