import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicaments_app/ui/screens/add_medicament/add_medicament_page.dart';
import 'package:medicaments_app/ui/screens/home/home_page.dart';
import 'package:medicaments_app/ui/screens/took_medicament/took_medicament_page.dart';

const String routeHome = '/home';
const String routeAdd = '/add';
const String routeTookMedicament = '/tookMedicament';

class MedicamentsApp extends StatelessWidget {
  const MedicamentsApp(
      {Key? key,
      required this.initialRoute,
      this.notificationAppLaunchDetails,
      this.selectedNotificationPayload})
      : super(key: key);

  final String initialRoute;
  final NotificationAppLaunchDetails? notificationAppLaunchDetails;
  final String? selectedNotificationPayload;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xff6fbe53),
      ),
      initialRoute: initialRoute,
      routes: {
        routeHome: (context) => HomePage(notificationAppLaunchDetails),
        routeTookMedicament: (context) =>
            TookMedicamentPage(selectedNotificationPayload),
      },
      onGenerateRoute: (settings) {
        if (settings.name == routeAdd) {
          final id = settings.arguments as int;
          return MaterialPageRoute(builder: (_) => AddMedicamentPage(id: id));
        }
      },
    );
  }
}
