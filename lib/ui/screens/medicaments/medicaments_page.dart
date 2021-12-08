import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicaments_app/bloc/user_medicament_list_bloc/bloc.dart';
import 'package:medicaments_app/ui/widgets/date_and_hours.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MedicamentsPage extends StatefulWidget {
  const MedicamentsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MedicamentsPage> createState() => _MedicamentsPageState();
}

class _MedicamentsPageState extends State<MedicamentsPage> {
  @override
  void initState() {
    super.initState();
    context.read<UserMedicamentListBloc>().add(GetUserMedicamentListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(AppLocalizations.of(context)!.medicamentsTitle),
      ),
      body: BlocBuilder<UserMedicamentListBloc, UserMedicamentListState>(
        builder: (context, state) {
          if (state is UserMedicamentListLoadingState) {
            return const CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: state.copyWith().medicamentList!.length,
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
                  title: Text(state.copyWith().medicamentList![index].title),
                  subtitle: DateAndHours(
                      medicament: state.copyWith().medicamentList![index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
