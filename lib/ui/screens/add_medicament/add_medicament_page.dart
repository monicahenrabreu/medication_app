import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicaments_app/bloc/calendar/bloc.dart';
import 'package:medicaments_app/bloc/medicament_list_bloc/bloc.dart';
import 'package:medicaments_app/data/models/calendar.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:medicaments_app/ui/widgets/add_medicament_form.dart';
import 'package:medicaments_app/ui/widgets/calendar_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddMedicamentPage extends StatelessWidget {
  const AddMedicamentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(AppLocalizations.of(context)!.addMedicamentTitle),
      ),
      body: BlocListener<MedicamentListBloc, MedicamentListState>(
        listener: (context, state) {
          if (state is MedicamentAddedState ||
              state is RangeMedicamentAddedState) {
            final LinkedHashMap<DateTime, List<Medicament>>? medicamentList =
                context.read<MedicamentListBloc>().state.medicamentList;

            Calendar? calendar = context.read<CalendarBloc>().state.calendar;

            if (state is MedicamentAddedState) {
              context
                  .read<CalendarBloc>()
                  .add(CalendarOnAddMedicamentEvent(calendar!, medicamentList));
            } else if (state is RangeMedicamentAddedState) {
              context.read<CalendarBloc>().add(
                  CalendarOnAddRangeOfMedicamentEvent(
                      calendar!, medicamentList));
            }
            Navigator.of(context).pop();
          }
        },
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: const [
              CalendarWidget(
                hasRange: true,
              ),
              AddMedicamentForm()
            ],
          ),
        ),
      ),
    );
  }
}
