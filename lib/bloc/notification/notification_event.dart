import 'package:flutter/material.dart';
import 'package:medicaments_app/data/models/medicament.dart';

abstract class NotificationEvent {}

class InitNotificationEvent extends NotificationEvent {
  final BuildContext context;
  InitNotificationEvent(this.context);
}

class ScheduleDailyNotificationEvent extends NotificationEvent {
  final DateTime date;
  final Medicament medicament;

  ScheduleDailyNotificationEvent(this.date, this.medicament);
}

class RescheduleNotificationEvent extends NotificationEvent {
  RescheduleNotificationEvent();
}

class ReceivedNotificationEvent extends NotificationEvent {
  ReceivedNotificationEvent();
}

