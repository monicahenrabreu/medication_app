import 'package:flutter/material.dart';
import 'package:medicaments_app/bloc/medicament_list_bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicaments_app/bloc/notification/bloc.dart';
import 'package:medicaments_app/ui/widgets/add_medicament_icon.dart';
import 'package:medicaments_app/ui/widgets/calendar_widget.dart';
import 'package:medicaments_app/ui/widgets/medicament_list_of_day.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<MedicamentListBloc>().add(GetMedicamentListEvent());
    context.read<NotificationBloc>().add(InitNotificationEvent(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Medicaments'),
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
              MedicamentListOfDay(),
            ],
          );
        },
      ),
    );
  }
}
