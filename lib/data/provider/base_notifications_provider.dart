import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicaments_app/data/models/received_notification.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseNotificationsProvider {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  /// Streams are created so that app can respond to notification-related events
  /// since the plugin is initialised in the `main` function
  final BehaviorSubject<ReceivedNotification>
  didReceiveLocalNotificationSubject =
  BehaviorSubject<ReceivedNotification>();

  final BehaviorSubject<String?> selectNotificationSubject =
  BehaviorSubject<String?>();

  String? selectedNotificationPayload;

  late final NotificationAppLaunchDetails? notificationAppLaunchDetails;

  Future<String> initialize();
}
