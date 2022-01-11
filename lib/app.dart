import 'package:flutter/material.dart';
import 'package:medicaments_app/medicaments_app.dart';
import 'package:medicaments_app/ui/screens/home/home_page.dart';
import 'package:medicaments_app/ui/screens/medicaments/medicaments_page.dart';
import 'package:medicaments_app/ui/screens/settings/settings_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicaments_app/bloc/notification/bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;
  late var screens;

  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(InitNotificationEvent(context));

    screens = const [
      HomePage(key: PageStorageKey(routeHomeKey)),
      MedicamentsPage(key: PageStorageKey(routeMedicamentsPageKey)),
      SettingsPage(key: PageStorageKey(routeSettingsPageKey)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IndexedStack(children: [Center(child: screens[_currentIndex])]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).primaryColor,
        iconSize: 24,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        onTap: (index) => setState(() {
          _currentIndex = index;
        }),
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: AppLocalizations.of(context)!.bottomNavigationBarItemHome),
          BottomNavigationBarItem(
              icon: const Icon(Icons.list),
              label: AppLocalizations.of(context)!
                  .bottomNavigationBarItemMedicamentList),
          BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label:
                  AppLocalizations.of(context)!.bottomNavigationBarItemSettings)
        ],
      ),
    );
  }
}
