import 'package:flutter/material.dart';
import 'package:medicaments_app/data/provider/medicament_provider.dart';
import 'package:medicaments_app/ui/medicaments_app.dart';
import 'package:medicaments_app/ui/screens/home/home_page.dart';
import 'package:medicaments_app/ui/screens/medicaments/medicaments_page.dart';
import 'package:medicaments_app/ui/screens/settings/settings_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicaments_app/bloc/notification/bloc.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;
  late MedicamentProvider medicamentProvider;

  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(InitNotificationEvent(context));
  }

  final screens = [
    const HomePage(key: PageStorageKey(routeHomeKey)),
    const MedicamentsPage(key: PageStorageKey(routeMedicamentsPageKey)),
    const SettingsPage(key: PageStorageKey(routeSettingsPageKey)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IndexedStack(children: [Center(child: screens[_currentIndex])]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        onTap: (index) => setState(() {
          _currentIndex = index;
        }),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list), label: 'Medicament List'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Settings')
        ],
      ),
    );
  }
}
