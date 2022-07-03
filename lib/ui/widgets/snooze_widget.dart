import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicaments_app/bloc/notification/bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SnoozeWidget extends StatefulWidget {
  const SnoozeWidget({Key? key}) : super(key: key);

  @override
  State<SnoozeWidget> createState() => _SnoozeWidgetState();
}

class _SnoozeWidgetState extends State<SnoozeWidget> {
  int dropdownValue = 5;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(AppLocalizations.of(context)!.settingsSnooze),
        const SizedBox(width: 20,),
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
          items: <int>[5, 10, 15, 30, 45, 60]
              .map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(value.toString()),
            );
          }).toList(),
        ),
      ],
    );
  }
}
