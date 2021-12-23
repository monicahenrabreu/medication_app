import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:medicaments_app/data/provider/medicament_provider.dart';
import 'package:medicaments_app/data/provider/notifications_provider.dart';
import 'package:medicaments_app/ui/app.dart';
import 'package:medicaments_app/ui/screens/add_medicament/add_medicament_page.dart';
import 'package:medicaments_app/ui/screens/home/home_page.dart';
import 'package:medicaments_app/ui/screens/medicaments/medicaments_page.dart';
import 'package:medicaments_app/ui/screens/settings/settings_page.dart';
import 'package:medicaments_app/ui/screens/took_medicament/took_medicament_page.dart';

const String routeHome = '/home';
const String routeHomeKey = 'homePageKey';
const String routeAdd = '/add';
const String routeTookMedicament = '/tookMedicament';
const String routeMedicamentList = '/routeMedicamentList';
const String routeMedicamentsPageKey = 'medicamentsPage';
const String routeSettings = '/settings';
const String routeSettingsPageKey = 'settingsPage';

class MedicamentsApp extends StatelessWidget {
  const MedicamentsApp(
      {Key? key,
      required this.medicamentProvider,
      required this.notificationsProvider})
      : super(key: key);

  final MedicamentProvider medicamentProvider;
  final NotificationsProvider notificationsProvider;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF476c98),
      ),

      // Provide the generated AppLocalizations to the MaterialApp. This
      // allows descendant Widgets to display the correct translations
      // depending on the user's locale.
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('pt', ''),
      ],
      home: App(
        notificationsProvider: notificationsProvider,
      ),
      routes: {
        routeHome: (context) =>
            const HomePage(key: PageStorageKey(routeHomeKey)),
        routeTookMedicament: (context) =>
            TookMedicamentPage(medicamentProvider: medicamentProvider),
        routeMedicamentList: (context) => MedicamentsPage(
            notificationsProvider: notificationsProvider,
            key: const PageStorageKey(routeMedicamentsPageKey)),
        routeAdd: (context) => AddMedicamentPage(),
        routeSettings: (context) =>
            const SettingsPage(key: PageStorageKey(routeSettingsPageKey)),
      },
    );
  }
}
