import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medicaments_app/bloc/calendar/bloc.dart';
import 'package:medicaments_app/data/models/calendar.dart';

class DaysChoosedMedicament extends StatelessWidget {
  const DaysChoosedMedicament({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _dateFormat = DateFormat('d MMM yyyy');

    return BlocBuilder<CalendarBloc, CalendarState>(builder: (context, state) {
      Calendar? calendarState = state.calendar;
      if (calendarState == null) {
        return const Text('Error!');
      }
      if (state is CalendarLoadingState) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return Column(
        children: [
          calendarState.selectedDay != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Only one day'),
                    Text(_dateFormat.format(calendarState.selectedDay!)),
                  ],
                )
              : Container(),
          calendarState.rangeStartDay != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('From'),
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
                    const Text('To'),
                    Text(_dateFormat.format(calendarState.rangeEndDay!)),
                  ],
                )
              : Container()
        ],
      );
    });
  }
}
