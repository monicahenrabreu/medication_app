import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicaments_app/bloc/medicament_list_bloc/medicament_list_bloc.dart';
import 'package:medicaments_app/ui/medicaments_app.dart';

void main() {
  runApp(BlocProvider<MedicamentListBloc>(
      create: (_) => MedicamentListBloc(), child: const MedicamentsApp()));
}
