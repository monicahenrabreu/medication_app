import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicaments_app/bloc/notification/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:medicaments_app/data/provider/medicament_provider.dart';
import 'package:medicaments_app/data/provider/notifications_provider.dart';

class TookMedicamentPage extends StatelessWidget {
  const TookMedicamentPage({
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
      medicament = context.read<MedicamentProvider>().getMedicament(date, id);
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
                  context
                      .read<MedicamentProvider>()
                      .editMedicament(date!, id, true);
                  _addNextNotifications(context);
                },
                child: Text(AppLocalizations.of(context)!.didTakeMedicamentYes),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xff6fbe53), // set the background color
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<MedicamentProvider>()
                      .editMedicament(date!, id, false);
                  _addNextNotifications(context);
                },
                child: Text(AppLocalizations.of(context)!.didTakeMedicamentNo),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // set the background color
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<MedicamentProvider>()
                      .editMedicament(date!, id, false);
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

  //if this medicament is the last one of the of day then fetch the medicaments for next day
  void _addNextNotifications(BuildContext context) async {
    List<PendingNotificationRequest> numberOfNotifications = await context
        .read<NotificationsProvider>()
        .flutterLocalNotificationsPlugin
        .pendingNotificationRequests();

    if (numberOfNotifications.isEmpty) {
      DateTime now = DateTime.now();
      DateTime tomorrow =
          DateTime(now.year, now.month, now.day).add(const Duration(days: 1));

      List<Medicament> medicaments =
          context.read<MedicamentProvider>().getMedicamentListOfDay(tomorrow) ??
              [];

      if (medicaments.isNotEmpty) {
        medicaments.forEach((medicament) async {
          await context.read<NotificationsProvider>().scheduleDailyNotification(
              medicament.id, medicament.title, tomorrow, medicament.hour);
        });
      }
    }

    Navigator.pop(context);
  }
}
