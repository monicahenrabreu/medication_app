class NotificationState {
  int? rescheduleMinutes;

  NotificationState(this.rescheduleMinutes);

  NotificationState copyWith() {
    return NotificationState(rescheduleMinutes);
  }

  SaveRescheduleNotificationMinutesState saveRescheduleMinutes(
      int? rescheduleMinutes) {
    return SaveRescheduleNotificationMinutesState(
        rescheduleMinutes ?? this.rescheduleMinutes);
  }
}

class NotificationInitialState extends NotificationState {
  NotificationInitialState() : super(5);
}

class SaveRescheduleNotificationMinutesState extends NotificationState {
  SaveRescheduleNotificationMinutesState(int? rescheduleMinutes)
      : super(rescheduleMinutes);
}
