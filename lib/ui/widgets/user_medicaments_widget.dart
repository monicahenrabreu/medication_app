import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicaments_app/bloc/medicament_list_bloc/bloc.dart';
import 'package:medicaments_app/bloc/user_medicament_list_bloc/bloc.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:medicaments_app/data/provider/notifications_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medicaments_app/ui/widgets/list_tile_medicament_widget.dart';

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
          child: ListTileMedicamentWidget(
            medicament: medicaments[index],
            showDetails: false,
            showSubtitle: true,
          ),
        );
      },
    );
  }

  //if the medicament to remove is from today in order to only search the notification if exists
  void _removeNotifications(Medicament medicament) async {
    if (medicament.dateOnlyOneTime != null) {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      DateTime selectedD = DateTime(medicament.dateOnlyOneTime!.year,
          medicament.dateOnlyOneTime!.month, medicament.dateOnlyOneTime!.day);

      if (selectedD.compareTo(today) == 0 &&
          medicament.hour.compareTo(now) > 0) {
        List<PendingNotificationRequest> pendingNotifications = await context
            .read<NotificationsProvider>()
            .flutterLocalNotificationsPlugin
            .pendingNotificationRequests();

        pendingNotifications.forEach((element) {
          if (element.payload == medicament.id) {
            context
                .read<NotificationsProvider>()
                .flutterLocalNotificationsPlugin
                .cancel(element.id);
          }
        });
      }
      context
          .read<UserMedicamentListBloc>()
          .add(RemoveUserMedicamentEvent(medicament));
      context
          .read<MedicamentListBloc>()
          .add(RemoveMedicamentEvent(medicament.dateOnlyOneTime!, medicament));
    } else if (medicament.fromDate != null && medicament.toDate != null) {
      DateTime date = medicament.fromDate!;
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      List<String> medicamentId = medicament.id.toString().split('--');
      String uniqueId = medicamentId.last;

      while (date.compareTo(medicament.toDate!) <= 0) {
        DateTime selectedD = DateTime(date.year, date.month, date.day);
        DateTime pp = DateTime(selectedD.year, selectedD.month, selectedD.day,
            medicament.hour.hour, medicament.hour.minute);

        if (selectedD.compareTo(today) == 0 && pp.compareTo(now) > 0) {
          List<PendingNotificationRequest> pendingNotifications = await context
              .read<NotificationsProvider>()
              .flutterLocalNotificationsPlugin
              .pendingNotificationRequests();

          pendingNotifications.forEach((element) {
            List<String> medicamentId = element.payload!.split('--');
            String payloadId = medicamentId.last;
            if (payloadId == uniqueId) {
              context
                  .read<NotificationsProvider>()
                  .flutterLocalNotificationsPlugin
                  .cancel(element.id);
            }
          });
        }

        date = date.add(const Duration(days: 1));
      }

      context
          .read<UserMedicamentListBloc>()
          .add(RemoveUserMedicamentEvent(medicament));
      context
          .read<MedicamentListBloc>()
          .add(RemoveMedicamentRangeEvent(medicament));
    }
  }
}
