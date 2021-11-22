import 'package:flutter/material.dart';
import 'package:medicaments_app/bloc/calendar/bloc.dart';
import 'package:medicaments_app/bloc/medicament_list_bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicaments_app/ui/screens/widgets/add_medicament_icon.dart';
import 'package:medicaments_app/ui/screens/widgets/calendar_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<MedicamentListBloc>().add(GetMedicamentListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('medicaments'),
      ),
      body: BlocBuilder<MedicamentListBloc, MedicamentListState>(
        builder: (context, state) {
          if (state is MedicamentListLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: [
              CalendarWidget(medicamentList: state.copyWith().medicamentList),
              const SizedBox(height: 8.0),
              const AddMedicamentIcon(),
              const SizedBox(height: 8.0),
              _buildMedicamentListOfDay(),
            ],
          );
        },
      ),
    );
  }

  Expanded _buildMedicamentListOfDay() {
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
