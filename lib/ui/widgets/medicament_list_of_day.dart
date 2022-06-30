import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicaments_app/bloc/calendar/bloc.dart';
import 'package:medicaments_app/bloc/medicament_list_bloc/bloc.dart';
import 'package:medicaments_app/configs/constants.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MedicamentListOfDay extends StatelessWidget {
  MedicamentListOfDay({Key? key}) : super(key: key);

  final DateFormat _timeFormat = DateFormat(Constants.hourFormat);

  @override
  Widget build(BuildContext context) {
    final LinkedHashMap<DateTime, List<Medicament>>? medicamentList =
        context.read<MedicamentListBloc>().state.copyWith().medicamentList;

    return BlocBuilder<CalendarBloc, CalendarState>(builder: (context, state) {
      if (state.copyWith().calendar!.selectedDay != null) {
        DateTime selectedDay = state.copyWith().calendar!.selectedDay!;

        DateTime dd =
            DateTime(selectedDay.year, selectedDay.month, selectedDay.day);

        List<Medicament> medicaments = medicamentList![dd] ?? [];

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
                  title: Text(medicaments[index].title),
                  subtitle: Text(_timeFormat.format(medicaments[index].hour)),
                ),
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
