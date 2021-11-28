import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medicaments_app/bloc/calendar/bloc.dart';
import 'package:medicaments_app/bloc/medicament_list_bloc/bloc.dart';
import 'package:medicaments_app/configs/constants.dart';
import 'package:medicaments_app/data/models/medicament_entity.dart';
import 'package:medicaments_app/data/models/medicament_list_entity.dart';
import 'package:medicaments_app/data/provider/medicament_provider.dart';
import 'package:medicaments_app/notifications.dart';
import 'package:medicaments_app/ui/medicaments_app.dart';

import 'data/models/medicament_entity.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String initialRoute = await Notifications.initialize();

  //Hive initialization
  await Hive.initFlutter();
  Hive.registerAdapter(MedicamentEntityAdapter());
  Hive.registerAdapter(MedicamentListEntityAdapter());
  await Hive.openBox<MedicamentListEntity>(Constants.hiveBox);
  final box = Hive.box<MedicamentListEntity>(Constants.hiveBox);

  final medicamentProvider = MedicamentProvider(box);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<MedicamentListBloc>(
          create: (_) => MedicamentListBloc(medicamentProvider),
        ),
        BlocProvider<CalendarBloc>(
          create: (context) => CalendarBloc(),
        ),
      ],
      child: MedicamentsApp(
        initialRoute: initialRoute,
        notificationAppLaunchDetails:
            Notifications.notificationAppLaunchDetails,
        selectedNotificationPayload: Notifications.selectedNotificationPayload,
      ),
    ),
  );
}
