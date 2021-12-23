import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medicaments_app/bloc/calendar/bloc.dart';
import 'package:medicaments_app/bloc/medicament_list_bloc/bloc.dart';
import 'package:medicaments_app/bloc/notification/bloc.dart';
import 'package:medicaments_app/bloc/user_medicament_list_bloc/bloc.dart';
import 'package:medicaments_app/configs/constants.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:medicaments_app/data/models/medicament_entity.dart';
import 'package:medicaments_app/data/models/medicament_list_entity.dart';
import 'package:medicaments_app/data/provider/medicament_provider.dart';
import 'package:medicaments_app/data/provider/notifications_provider.dart';
import 'package:medicaments_app/medicaments_app.dart';
import 'package:medicaments_app/bloc/notification/notification_bloc.dart';
import 'package:cron/cron.dart';
import 'package:timezone/timezone.dart' as tz;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  NotificationsProvider notificationsProvider = NotificationsProvider();
  await notificationsProvider.initialize();

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

  tz.TZDateTime _scheduleDate(DateTime dateTime, DateTime hour) {
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, dateTime.year,
        dateTime.month, dateTime.day, hour.hour, hour.minute);
    return scheduledDate;
  }

  final cron = Cron();
  cron.schedule(Schedule.parse('0 0 * * *'), () async {
    await notificationsProvider.flutterLocalNotificationsPlugin.cancelAll();
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    List<Medicament>? medicaments =
        medicamentProvider.getMedicamentListOfDay(today) ?? [];

    if (medicaments.isNotEmpty) {
      for (var medicament in medicaments) {
        DateTime date = DateTime(today.year, today.month, today.day,
            medicament.hour.hour, medicament.hour.minute);
        //ScheduleDailyNotificationEvent(date, medicament);

        print('ja que nao da para fazer de outra maneira...');
        int index = notificationsProvider.getIndex();

        await notificationsProvider.flutterLocalNotificationsPlugin
            .zonedSchedule(
                index,
                'Medication',
                medicament.title,
                _scheduleDate(date, medicament.hour),
                const NotificationDetails(
                  android: AndroidNotificationDetails(
                      'daily notification channel id',
                      'daily notification channel name',
                      channelDescription: 'daily notification description'),
                ),
                androidAllowWhileIdle: true,
                payload: medicament.id,
                uiLocalNotificationDateInterpretation:
                    UILocalNotificationDateInterpretation.absoluteTime);

        notificationsProvider.setIndex(index + 1);
      }
    }
  });

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
          create: (context) => NotificationBloc(notificationsProvider),
        ),
        BlocProvider<UserMedicamentListBloc>(
          create: (_) => UserMedicamentListBloc(medicamentProvider),
        ),
      ],
      child: MedicamentsApp(
          medicamentProvider: medicamentProvider,
          notificationsProvider: notificationsProvider),
    ),
  );
}
