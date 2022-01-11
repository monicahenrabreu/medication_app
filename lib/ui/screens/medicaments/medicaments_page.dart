import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
    context.read<UserMedicamentListBloc>().add(GetUserMedicamentListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(AppLocalizations.of(context)!.medicamentListTitle),
      ),
      body: BlocBuilder<UserMedicamentListBloc, UserMedicamentListState>(
        builder: (context, state) {
          if (state is UserMedicamentListLoadedState) {
            return const UserMedicamentsWidget();
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
