import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:medicaments_app/data/provider/notifications_provider.dart';
import 'package:medicaments_app/ui/widgets/date_and_hours.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserMedicamentsWidget extends StatefulWidget {
  final List<Medicament> medicaments;

  const UserMedicamentsWidget({required this.medicaments, Key? key})
      : super(key: key);

  @override
  State<UserMedicamentsWidget> createState() => _UserMedicamentsWidgetState();
}

class _UserMedicamentsWidgetState extends State<UserMedicamentsWidget> {
  late final List<Medicament> medicaments;

  @override
  void initState() {
    super.initState();
    medicaments = widget.medicaments;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: medicaments.length,
      itemBuilder: (context, index) {
        final item = medicaments[index];
        return Dismissible(
          key: Key(item.id),
          onDismissed: (direction) {
            _removeNotifications(index);
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

  void _removeNotifications(int index) async {
    //TODO: Check if the medicament to remove is from today in order to only search the notification if exists
    context
        .read<NotificationsProvider>()
        .cancelNotification(medicaments[index].id);
  }
}
