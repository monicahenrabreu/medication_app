import 'package:medicaments_app/data/provider/notifications_provider.dart';

class NotificationState {
  int? index;
  NotificationsProvider? notifications;
  int? rescheduleMinutes;

  NotificationState(this.index, this.notifications, this.rescheduleMinutes);

  NotificationState copyWith(int? index) {
    return NotificationState(index ?? this.index, notifications, rescheduleMinutes);
  }

  SaveRescheduleNotificationMinutesState saveRescheduleMinutes(
      int? rescheduleMinutes) {
    return SaveRescheduleNotificationMinutesState(index,
        notifications, rescheduleMinutes ?? this.rescheduleMinutes);
  }
}

class NotificationInitialState extends NotificationState {
  NotificationInitialState(NotificationsProvider notifications)
      : super(0, notifications, 5);
}

class SaveRescheduleNotificationMinutesState extends NotificationState {
  SaveRescheduleNotificationMinutesState(
      int? index, NotificationsProvider? notifications, int? rescheduleMinutes)
      : super(index, notifications, rescheduleMinutes);
}
