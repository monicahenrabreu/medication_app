import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicaments_app/bloc/medicament_list_bloc/bloc.dart';
import 'package:medicaments_app/bloc/user_medicament_list_bloc/bloc.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:medicaments_app/data/provider/notifications_provider.dart';
import 'package:medicaments_app/ui/widgets/date_and_hours.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserMedicamentsWidget extends StatefulWidget {
  const UserMedicamentsWidget({Key? key}) : super(key: key);

  @override
  State<UserMedicamentsWidget> createState() => _UserMedicamentsWidgetState();
}

class _UserMedicamentsWidgetState extends State<UserMedicamentsWidget> {

  late List<Medicament> medicaments;

  @override
  void initState() {
    medicaments =
    context.read<UserMedicamentListBloc>().state.copyWith().medicamentList!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: medicaments.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: UniqueKey(),
          onDismissed: (_) {
            _removeNotifications(medicaments[index]);
            final snackBar = SnackBar(
              content: Text(medicaments[index].title +
                  ' ' +
                  AppLocalizations.of(context)!.medicamentRemoved),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            setState(() {
              medicaments.removeAt(index);
            });
          },
          // Show a red background as the item is swiped away.
          background: Container(color: Colors.red),
          child: Container(
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
              subtitle: DateAndHours(medicament: medicaments[index]),
            ),
          ),
        );
      },
    );
  }

  //if the medicament to remove is from today in order to only search the notification if exists
  void _removeNotifications(Medicament medicament) async {

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime selectedD = DateTime(medicament.dateOnlyOneTime!.year, medicament.dateOnlyOneTime!.month, medicament.dateOnlyOneTime!.day);

    if(selectedD.compareTo(today) == 0 && medicament.hour.compareTo(today) > 0) {
      List<PendingNotificationRequest> pendingNotifications = await context
          .read<NotificationsProvider>()
          .flutterLocalNotificationsPlugin
          .pendingNotificationRequests();

      pendingNotifications.forEach((element) {
        if(element.payload == medicament.id){
          context
              .read<NotificationsProvider>()
              .flutterLocalNotificationsPlugin.cancel(element.id);
          print('notificacao eliminada! ' + medicament.id);
        }
      });
    }
    if(medicament.dateOnlyOneTime != null) {
      context.read<UserMedicamentListBloc>().add(RemoveUserMedicamentEvent(medicament));
      context.read<MedicamentListBloc>().add(RemoveMedicamentEvent(medicament.dateOnlyOneTime!, medicament));
    }
  }
}
