import 'package:flutter/material.dart';
import 'package:medicaments_app/ui/screens/add_medicament/add_medicament_page.dart';
import 'package:medicaments_app/ui/screens/home/home_page.dart';

const String routeHome = '/home';
const String routeAdd = '/add';

class MedicamentsApp extends StatelessWidget {
  const MedicamentsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xff6fbe53),
      ),
      initialRoute: routeHome,
      routes: {
        routeHome: (context) => HomePage(),
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
