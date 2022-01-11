import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:medicaments_app/app.dart';
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
  const MedicamentsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
      home: const App(),
      routes: {
        routeHome: (_) =>
            const HomePage(key: PageStorageKey(routeHomeKey)),
        routeTookMedicament: (_) => const TookMedicamentPage(),
        routeMedicamentList: (_) =>
            const MedicamentsPage(key: PageStorageKey(routeMedicamentsPageKey)),
        routeAdd: (_) => AddMedicamentPage(),
        routeSettings: (_) =>
            const SettingsPage(key: PageStorageKey(routeSettingsPageKey)),
      },
    );
  }
}
