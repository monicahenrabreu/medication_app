import 'package:medicaments_app/data/provider/notifications_provider.dart';

class NotificationState {
  int? index;
  NotificationsProvider? notifications;

  NotificationState(this.index, this.notifications);

  NotificationState copyWith(int? index) {
    return NotificationState(index ?? this.index, notifications);
  }
}

class NotificationInitialState extends NotificationState {
  NotificationInitialState(NotificationsProvider notifications) : super(0, notifications);
}

class ReceivedNotificationState extends NotificationState {
  ReceivedNotificationState(int? index, NotificationsProvider? notifications) : super(index, notifications);
}
