import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:medicaments_app/configs/constants.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class DateAndHours extends StatelessWidget {
  const DateAndHours({required this.medicament, Key? key}) : super(key: key);

  final Medicament medicament;

  @override
  Widget build(BuildContext context) {
    final _dateFormat = DateFormat(Constants.dateFormat);
    final _hourFormat = DateFormat(Constants.hourFormat);
    final hour = _hourFormat.format(medicament.hour);

    if (medicament.dateOnlyOneTime != null) {
      final date = _dateFormat.format(medicament.dateOnlyOneTime!);
      return Text(AppLocalizations.of(context)!.medicamentsPageDateOnlyOneTime +
          date +
          AppLocalizations.of(context)!.medicamentsPageAtHours +
          hour);
    }

    final fromDate = _dateFormat.format(medicament.fromDate!);
    final toDate = _dateFormat.format(medicament.toDate!);
    return Text(AppLocalizations.of(context)!.medicamentsPageFromDate +
        fromDate +
        AppLocalizations.of(context)!.medicamentsPageToDate +
        toDate +
        AppLocalizations.of(context)!.medicamentsPageAtHours +
        hour);
  }
}
