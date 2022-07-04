import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicaments_app/bloc/user_medicament_list_bloc/bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medicaments_app/ui/widgets/user_medicaments_widget.dart';

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
    context.read<UserMedicamentListCubit>().getUserMedicamentListEvent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(AppLocalizations.of(context)!.medicamentListTitle),
      ),
      body: BlocBuilder<UserMedicamentListCubit, UserMedicamentListState>(
        builder: (context, state) {
          if (state.medicamentList == null) {
            return const CircularProgressIndicator();
          }
          return UserMedicamentsWidget(medicamentList: state.medicamentList!);
        },
      ),
    );
  }
}
