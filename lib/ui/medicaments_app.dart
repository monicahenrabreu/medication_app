import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:medicaments_app/data/provider/medicament_provider.dart';
import 'package:medicaments_app/ui/screens/add_medicament/add_medicament_page.dart';
import 'package:medicaments_app/ui/screens/home/home_page.dart';
import 'package:medicaments_app/ui/screens/medicaments/medicaments_page.dart';
import 'package:medicaments_app/ui/screens/took_medicament/took_medicament_page.dart';

const String routeHome = '/home';
const String routeAdd = '/add';
const String routeTookMedicament = '/tookMedicament';
const String routeMedicamentList = '/routeMedicamentList';

class MedicamentsApp extends StatelessWidget {
  const MedicamentsApp(
      {Key? key, required this.initialRoute, required this.medicamentProvider})
      : super(key: key);

  final String initialRoute;
  final MedicamentProvider medicamentProvider;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xff6fbe53),
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

      initialRoute: initialRoute,
      routes: {
        routeHome: (context) => const HomePage(),
        routeTookMedicament: (context) =>
            TookMedicamentPage(medicamentProvider: medicamentProvider),
        routeMedicamentList: (context) => const MedicamentsPage(),
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
