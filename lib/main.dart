import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medicaments_app/bloc/medicament_list_bloc/bloc.dart';
import 'package:medicaments_app/configs/constants.dart';
import 'package:medicaments_app/data/models/medicament_entity.dart';
import 'package:medicaments_app/data/provider/medicament_provider.dart';
import 'package:medicaments_app/ui/medicaments_app.dart';

import 'data/models/medicament_entity.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(MedicamentEntityAdapter());
  await Hive.openBox<List<MedicamentEntity>>(Constants.hiveBox);

  final box = Hive.box<List<MedicamentEntity>>(Constants.hiveBox);

  final medicamentProvider = MedicamentProvider(box);

  runApp(
    BlocProvider<MedicamentListBloc>(
      create: (_) => MedicamentListBloc(medicamentProvider),
      child: const MedicamentsApp(),
    ),
  );
}
