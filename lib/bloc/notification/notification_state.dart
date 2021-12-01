import 'package:medicaments_app/notifications.dart';

class NotificationState {
  int? index;
  Notifications? notifications;

  NotificationState(this.index, this.notifications);

  NotificationState copyWith(int? index) {
    return NotificationState(index ?? this.index, notifications);
  }
}

class NotificationInitialState extends NotificationState {
  NotificationInitialState(Notifications notifications) : super(0, notifications);
}

class ReceivedNotificationState extends NotificationState {
  ReceivedNotificationState(int? index, Notifications? notifications) : super(index, notifications);
}
