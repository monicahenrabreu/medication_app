import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicaments_app/bloc/calendar/bloc.dart';
import 'package:medicaments_app/configs/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medicaments_app/data/models/calendar.dart';
import 'package:medicaments_app/utils/utils.dart';

class MedicamentListOfDay extends StatelessWidget {
  MedicamentListOfDay({Key? key}) : super(key: key);

  final DateFormat _timeFormat = DateFormat(Constants.hourFormat);

  @override
  Widget build(BuildContext context) {
    return BlocListener<CalendarBloc, CalendarState>(
      listener: (context, state) {
        if (state is CalendarInitialState ||
            state is CalendarAddedMedicamentState) {
          Calendar calendar =
              context.read<CalendarBloc>().state.copyWith().calendar!;

          calendar.rangeStartDay = null;
          calendar.rangeEndDay = null;
          calendar.focusedDay = calendarToday;
          calendar.selectedDay = calendarToday;

          context.read<CalendarBloc>().add(CalendarOnDaySelectedEvent(
              state.calendar!, state.medicamentList));
        }
      },
      child: Expanded(
        child: BlocBuilder<CalendarBloc, CalendarState>(
          builder: (context, state) {
            if (state.calendar!.selectedEvents == null ||
                state.calendar!.selectedEvents!.isEmpty) {
              return Text(AppLocalizations.of(context)!.noMedicaments);
            }
            return ListView.builder(
              itemCount: state.calendar!.selectedEvents!.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    title: Text(state.calendar!.selectedEvents![index].title),
                    subtitle: Text(_timeFormat
                        .format(state.calendar!.selectedEvents![index].hour)),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
