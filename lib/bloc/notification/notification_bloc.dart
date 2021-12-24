import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicaments_app/bloc/notification/notification_event.dart';
import 'package:medicaments_app/bloc/notification/notification_state.dart';
import 'package:medicaments_app/data/provider/notifications_provider.dart';
import 'package:medicaments_app/medicaments_app.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationsProvider provider;

  NotificationBloc(this.provider) : super(NotificationInitialState()) {
    on<InitNotificationEvent>(_onInitNotificationEvent);
    on<ScheduleDailyNotificationEvent>(_onScheduleDailyNotificationEvent);
    on<RescheduleNotificationEvent>(_onRescheduleNotificationEvent);
    on<SaveRescheduleSettingsEvent>(_onSaveRescheduleSettingsEvent);
  }

  _onInitNotificationEvent(
      InitNotificationEvent event, Emitter<NotificationState> emit) async {
    provider.requestPermissions();
    _configureSelectNotificationSubject(event.context, emit);
  }

  Future<void> _onScheduleDailyNotificationEvent(
      ScheduleDailyNotificationEvent event,
      Emitter<NotificationState> emit) async {
    await provider.scheduleDailyNotification(event.medicament.id,
        event.medicament.title, event.date, event.medicament.hour);
    emit(state.copyWith());
  }

  Future<void> _onRescheduleNotificationEvent(RescheduleNotificationEvent event,
      Emitter<NotificationState> emit) async {
    await provider.rescheduleNotification(
        event.medicament.id, event.medicament.title, state.rescheduleMinutes!);
    emit(state.copyWith());
  }

  _onSaveRescheduleSettingsEvent(SaveRescheduleSettingsEvent event,
      Emitter<NotificationState> emit) async {
    emit(state.saveRescheduleMinutes(event.minutes));
  }

  void _configureSelectNotificationSubject(
      BuildContext context, Emitter<NotificationState> emit) {
    provider.configureSelectNotificationSubject(context, routeTookMedicament);
  }
}
