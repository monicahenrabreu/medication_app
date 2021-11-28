import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicaments_app/bloc/medicament_list_bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicaments_app/ui/screens/widgets/add_medicament_icon.dart';
import 'package:medicaments_app/ui/screens/widgets/calendar_widget.dart';
import 'package:medicaments_app/ui/screens/widgets/medicament_list_of_day.dart';
import 'package:flutter/cupertino.dart';
import 'package:medicaments_app/notifications.dart';

class HomePage extends StatefulWidget {
  const HomePage(
    this.notificationAppLaunchDetails, {
    Key? key,
  }) : super(key: key);

  final NotificationAppLaunchDetails? notificationAppLaunchDetails;

  bool get didNotificationLaunchApp =>
      notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<MedicamentListBloc>().add(GetMedicamentListEvent());
    Notifications.init(context);
  }

  @override
  void dispose() {
    Notifications.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Medicaments'),
      ),
      body: BlocBuilder<MedicamentListBloc, MedicamentListState>(
        builder: (context, state) {
          if (state is MedicamentListLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: [
              CalendarWidget(medicamentList: state.copyWith().medicamentList),
              const SizedBox(height: 8.0),
              const AddMedicamentIcon(),
              const SizedBox(height: 8.0),
              MedicamentListOfDay(),
            ],
          );
        },
      ),
    );
  }
}
