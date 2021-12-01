import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicaments_app/bloc/notification/notification_event.dart';
import 'package:medicaments_app/bloc/notification/notification_state.dart';
import 'package:medicaments_app/data/models/received_notification.dart';
import 'package:medicaments_app/notifications.dart';
import 'package:medicaments_app/ui/medicaments_app.dart';
import 'package:medicaments_app/ui/screens/took_medicament/took_medicament_page.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc(Notifications notifications)
      : super(NotificationInitialState(notifications)) {
    on<InitNotificationEvent>(_onInitNotificationEvent);
    on<ScheduleDailyNotificationEvent>(_onScheduleDailyNotificationEvent);
    on<RescheduleNotificationEvent>(_onRescheduleNotificationEvent);
  }

  _onInitNotificationEvent(
      InitNotificationEvent event, Emitter<NotificationState> emit) async {
    _requestPermissions();
    _configureDidReceiveLocalNotificationSubject(event.context, emit);
    _configureSelectNotificationSubject(event.context, emit);
  }

  Future<void> _onScheduleDailyNotificationEvent(
      ScheduleDailyNotificationEvent event,
      Emitter<NotificationState> emit) async {
    await state.notifications!.flutterLocalNotificationsPlugin.zonedSchedule(
        state.index!,
        event.medicament.title,
        event.medicament.title,
        _scheduleDate(event.date, event.medicament.hour),
        const NotificationDetails(
          android: AndroidNotificationDetails('daily notification channel id',
              'daily notification channel name',
              channelDescription: 'daily notification description'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);

    emit(state.copyWith(state.index! +
        1)); //, state.notifications!.flutterLocalNotificationsPlugin));
  }

  Future<void> _onRescheduleNotificationEvent(RescheduleNotificationEvent event,
      Emitter<NotificationState> emit) async {
    tz.TZDateTime date =
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));

    await state.notifications!.flutterLocalNotificationsPlugin.zonedSchedule(
        state.index!,
        'scheduled title',
        'scheduled body',
        date,
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);

    emit(state.copyWith(
        state.index! + 1)); //, state.flutterLocalNotificationsPlugin));
  }

  tz.TZDateTime _scheduleDate(DateTime dateTime, DateTime hour) {
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, dateTime.year,
        dateTime.month, dateTime.day, hour.hour, hour.minute);
    return scheduledDate;
  }

  void _requestPermissions() {
    state.notifications!.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    state.notifications!.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject(
      BuildContext context, Emitter<NotificationState> emit) {
    state.notifications!.didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title!)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body!)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        TookMedicamentPage(receivedNotification.payload),
                  ),
                );
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject(
      BuildContext context, Emitter<NotificationState> emit) {
    state.notifications!.selectNotificationSubject.stream
        .listen((String? payload) async {
      await Navigator.pushNamed(context, routeTookMedicament);
    });
  }
}
