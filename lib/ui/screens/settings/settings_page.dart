import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicaments_app/bloc/notification/bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int dropdownValue = 5;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(AppLocalizations.of(context)!.settings),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Text(AppLocalizations.of(context)!.settingsSnooze)),
            DropdownButton<int>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_drop_down),
              elevation: 16,
              underline: Container(
                height: 2,
                color: Theme.of(context).primaryColor,
              ),
              onChanged: (int? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                  context.read<NotificationBloc>().add(SaveRescheduleSettingsEvent(newValue*60));
                });
              },
              items: <int>[5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55]
                  .map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
            )
          ],
        ));
  }
}
