import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicaments_app/bloc/calendar/bloc.dart';
import 'package:medicaments_app/bloc/medicament_list_bloc/bloc.dart';
import 'package:medicaments_app/data/models/calendar.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:medicaments_app/ui/widgets/add_medicament_form.dart';
import 'package:medicaments_app/ui/widgets/calendar_widget.dart';

class AddMedicamentPage extends StatefulWidget {
  final int id;

  const AddMedicamentPage({Key? key, required this.id}) : super(key: key);

  @override
  _AddMedicamentPageState createState() => _AddMedicamentPageState();
}

class _AddMedicamentPageState extends State<AddMedicamentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Add Medicament'),
      ),
      body: BlocListener<MedicamentListBloc, MedicamentListState>(
        listener: (context, state) {
          if (state is MedicamentAddedState || state is RangeMedicamentAddedState) {
            final LinkedHashMap<DateTime, List<Medicament>>? medicamentList =
                context.read<MedicamentListBloc>().state.medicamentList;

            Calendar? calendar = context.read<CalendarBloc>().state.calendar;

            context
                .read<CalendarBloc>()
                .add(CalendarOnAddMedicamentEvent(calendar!, medicamentList));
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
