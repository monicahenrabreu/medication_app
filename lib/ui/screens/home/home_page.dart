import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicaments_app/bloc/medicament_list_bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:medicaments_app/data/provider/medicament_provider.dart';
import 'package:medicaments_app/data/provider/notifications_provider.dart';
import 'package:medicaments_app/medicaments_app.dart';
import 'package:medicaments_app/ui/widgets/calendar_widget.dart';
import 'package:medicaments_app/ui/widgets/medicament_list_of_day.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<MedicamentListBloc>().add(GetMedicamentListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(AppLocalizations.of(context)!.homeTitle),
        actions: [
          IconButton(
            onPressed: _onPressedGoToAddMedicamentPage,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: BlocBuilder<MedicamentListBloc, MedicamentListState>(
        builder: (context, state) {
          if(state is MedicamentListInitialState) {
            _addNextNotifications(context);
          }
          if (state is MedicamentListLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: [
              CalendarWidget(medicamentList: state.copyWith().medicamentList),
              const SizedBox(height: 8.0),
              MedicamentListOfDay(),
              const SizedBox(height: 15),
            ],
          );
        },
      ),
    );
  }

  void _onPressedGoToAddMedicamentPage() {
    Navigator.of(context).pushNamed(routeAdd);
  }

  void _addNextNotifications(BuildContext context) async {
    List<PendingNotificationRequest> numberOfNotifications = await context
        .read<NotificationsProvider>()
        .flutterLocalNotificationsPlugin
        .pendingNotificationRequests();

    if (numberOfNotifications.isEmpty) {
      DateTime now = DateTime.now();

      List<Medicament> medicaments =
          context.read<MedicamentProvider>().getMedicamentListOfDay(now) ??
              [];

      if (medicaments.isNotEmpty) {
        medicaments.forEach((medicament) async {
          if(medicament.hour.compareTo(now) >= 0){
            await context.read<NotificationsProvider>().scheduleDailyNotification(
                medicament.id, medicament.title, now, medicament.hour);
          }
        });
      }
    }
  }
}
