import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medicaments_app/bloc/calendar/bloc.dart';
import 'package:medicaments_app/configs/constants.dart';
import 'package:medicaments_app/data/models/calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DaysChoosedMedicament extends StatelessWidget {
  const DaysChoosedMedicament({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _dateFormat = DateFormat(Constants.dateFormat);

    return BlocBuilder<CalendarBloc, CalendarState>(builder: (context, state) {
      Calendar? calendarState = state.calendar;
      if (state is CalendarLoadingState) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return Column(
        children: [
          calendarState!.selectedDay != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(AppLocalizations.of(context)!
                            .daysChoosedMedicamentOnlyOneDay)),
                    Expanded(
                        child: Text(
                            _dateFormat.format(calendarState.selectedDay!))),
                  ],
                )
              : Container(),
          calendarState.rangeStartDay != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!
                        .daysChoosedMedicamentFrom),
                    Text(_dateFormat.format(calendarState.rangeStartDay!)),
                  ],
                )
              : Container(),
          const SizedBox(
            height: 10.0,
          ),
          calendarState.rangeEndDay != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.daysChoosedMedicamentTo),
                    Text(_dateFormat.format(calendarState.rangeEndDay!)),
                  ],
                )
              : Container()
        ],
      );
    });
  }
}
