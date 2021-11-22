import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicaments_app/bloc/calendar/bloc.dart';

class MedicamentListOfDay extends StatelessWidget {

  const MedicamentListOfDay({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<CalendarBloc, CalendarState>(
        builder: (context, state) {
          //add error
          // if(state.calendar == null || state.calendar.selectedEvents == null || state.calendar.selectedEvents.isEmpty)

          if (state.calendar!.selectedEvents == null ||
              state.calendar!.selectedEvents!.isEmpty) {
            return const Text('No medicaments yet!');
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
