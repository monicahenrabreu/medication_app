import 'package:flutter/material.dart';
import 'package:medicaments_app/bloc/notification/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:medicaments_app/data/provider/medicament_provider.dart';

class TookMedicamentPage extends StatelessWidget {
  MedicamentProvider medicamentProvider;

  TookMedicamentPage({
    required this.medicamentProvider,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? date;
    String id = '';
    Medicament? medicament;

    final argument = ModalRoute.of(context)!.settings.arguments;

    if (argument != null) {
      id = argument.toString();
      List<String> medicamentId = argument.toString().split('--');
      date = medicamentId.first;
      medicament = medicamentProvider.getMedicament(date, id);
    }

    if (medicament == null) {
      return const Text('Error!');
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(AppLocalizations.of(context)!.didTakeMedicament +
            ' ' +
            medicament.title +
            '?'),
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  medicamentProvider.editMedicament(date!, id, true);
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.didTakeMedicamentYes),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context)
                      .primaryColor, // set the background color
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  medicamentProvider.editMedicament(date!, id, false);
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.didTakeMedicamentNo),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // set the background color
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  medicamentProvider.editMedicament(date!, id, false);
                  context
                      .read<NotificationBloc>()
                      .add(RescheduleNotificationEvent(medicament!));
                  Navigator.pop(context);
                },
                child:
                    Text(AppLocalizations.of(context)!.didTakeMedicamentSnooze),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey, // set the background color
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
