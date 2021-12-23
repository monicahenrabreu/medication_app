import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicaments_app/bloc/notification/notification_event.dart';
import 'package:medicaments_app/bloc/notification/notification_state.dart';
import 'package:medicaments_app/data/provider/notifications_provider.dart';
import 'package:medicaments_app/medicaments_app.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc(NotificationsProvider notifications)
      : super(NotificationInitialState(notifications)) {
    on<InitNotificationEvent>(_onInitNotificationEvent);
    on<ScheduleDailyNotificationEvent>(_onScheduleDailyNotificationEvent);
    on<RescheduleNotificationEvent>(_onRescheduleNotificationEvent);
    on<SaveRescheduleSettingsEvent>(_onSaveRescheduleSettingsEvent);
  }

  _onInitNotificationEvent(
      InitNotificationEvent event, Emitter<NotificationState> emit) async {
    _requestPermissions();
    _configureSelectNotificationSubject(event.context, emit);
  }

  Future<void> _onScheduleDailyNotificationEvent(
      ScheduleDailyNotificationEvent event,
      Emitter<NotificationState> emit) async {
    int index = state.notifications!.getIndex();
    await state.notifications!.flutterLocalNotificationsPlugin.zonedSchedule(
        index,
        'Medication',
        event.medicament.title,
        _scheduleDate(event.date, event.medicament.hour),
        const NotificationDetails(
          android: AndroidNotificationDetails('daily notification channel id',
              'daily notification channel name',
              channelDescription: 'daily notification description'),
        ),
        androidAllowWhileIdle: true,
        payload: event.medicament.id,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);

    state.notifications!.setIndex(index + 1);
    emit(state.copyWith(state.notifications!.getIndex()));
  }

  Future<void> _onRescheduleNotificationEvent(RescheduleNotificationEvent event,
      Emitter<NotificationState> emit) async {
    tz.TZDateTime date = tz.TZDateTime.now(tz.local)
        .add(Duration(seconds: state.rescheduleMinutes!));

    int index = state.notifications!.getIndex();

    await state.notifications!.flutterLocalNotificationsPlugin.zonedSchedule(
        index,
        'Medication',
        event.medicament.title,
        date,
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidAllowWhileIdle: true,
        payload: event.medicament.id,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);

    state.notifications!.setIndex(index + 1);
    emit(state.copyWith(state.notifications!.getIndex()));
  }

  _onSaveRescheduleSettingsEvent(SaveRescheduleSettingsEvent event,
      Emitter<NotificationState> emit) async {
    emit(state.saveRescheduleMinutes(event.minutes));
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

  void _configureSelectNotificationSubject(
      BuildContext context, Emitter<NotificationState> emit) {
    state.notifications!.selectNotificationSubject.stream
        .listen((String? payload) async {
      await Navigator.pushNamed(context, routeTookMedicament,
          arguments: payload);
    });
  }
}
