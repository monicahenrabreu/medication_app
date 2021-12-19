import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medicaments_app/bloc/calendar/bloc.dart';
import 'package:medicaments_app/bloc/medicament_list_bloc/bloc.dart';
import 'package:medicaments_app/bloc/user_medicament_list_bloc/bloc.dart';
import 'package:medicaments_app/configs/constants.dart';
import 'package:medicaments_app/data/models/medicament_entity.dart';
import 'package:medicaments_app/data/models/medicament_list_entity.dart';
import 'package:medicaments_app/data/provider/medicament_provider.dart';
import 'package:medicaments_app/data/provider/notifications_provider.dart';
import 'package:medicaments_app/ui/medicaments_app.dart';
import 'package:medicaments_app/bloc/notification/notification_bloc.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  NotificationsProvider notifications = NotificationsProvider();
  await notifications.initialize();

  //Hive initialization
  await Hive.initFlutter();
  Hive.registerAdapter(MedicamentEntityAdapter());
  Hive.registerAdapter(MedicamentListEntityAdapter());
  await Hive.openBox<MedicamentListEntity>(Constants.hiveBox);
  final box = Hive.box<MedicamentListEntity>(Constants.hiveBox);

  await Hive.openBox<MedicamentEntity>(Constants.hiveUserMedicaments);
  final boxUserMedicaments =
      Hive.box<MedicamentEntity>(Constants.hiveUserMedicaments);

  final medicamentProvider = MedicamentProvider(box, boxUserMedicaments);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<MedicamentListBloc>(
          create: (_) => MedicamentListBloc(medicamentProvider),
        ),
        BlocProvider<CalendarBloc>(
          create: (context) => CalendarBloc(),
        ),
        BlocProvider<NotificationBloc>(
          create: (context) => NotificationBloc(notifications),
        ),
        BlocProvider<UserMedicamentListBloc>(
          create: (_) => UserMedicamentListBloc(medicamentProvider),
        ),
      ],
      child: MedicamentsApp(
          medicamentProvider: medicamentProvider),
    ),
  );
}
