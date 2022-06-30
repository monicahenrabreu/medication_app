import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:medicaments_app/data/models/received_notification.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationsProvider {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  int _index = 0;

  FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin =>
      _flutterLocalNotificationsPlugin;

  /// Streams are created so that app can respond to notification-related events
  /// since the plugin is initialised in the `main` function
  final BehaviorSubject<ReceivedNotification>
      _didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();

  final BehaviorSubject<String?> _selectNotificationSubject =
      BehaviorSubject<String?>();

  String? _selectedNotificationPayload;

  late final NotificationAppLaunchDetails? _notificationAppLaunchDetails;

  NotificationsProvider();

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
            onDidReceiveLocalNotification: (
              int id,
              String? title,
              String? body,
              String? payload,
            ) async {
              _didReceiveLocalNotificationSubject.add(
                ReceivedNotification(
                  id: id,
                  title: title,
                  body: body,
                  payload: payload,
                ),
              );
            });

    const MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();

    final InitializationSettings _initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);

    _notificationAppLaunchDetails = await _flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();

    await _configureLocalTimeZone();

    if (_notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      _selectedNotificationPayload = _notificationAppLaunchDetails!.payload;
    }

    await _flutterLocalNotificationsPlugin.initialize(_initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
      _selectedNotificationPayload = payload;
      _selectNotificationSubject.add(payload);
    });
  }

  Future<void> scheduleDailyNotification(
      String id, String title, DateTime date, DateTime hour) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        _index,
        'Medication',
        title,
        _scheduleDate(date, hour),
        const NotificationDetails(
          android: AndroidNotificationDetails('daily notification channel id',
              'daily notification channel name',
              channelDescription: 'daily notification description'),
        ),
        androidAllowWhileIdle: true,
        payload: id,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);

    _index++;
  }

  Future<void> rescheduleNotification(
      String id, String title, int rescheduleMinutes) async {
    tz.TZDateTime date =
        tz.TZDateTime.now(tz.local).add(Duration(seconds: rescheduleMinutes));

    await _flutterLocalNotificationsPlugin.zonedSchedule(
        _index,
        'Medication',
        title,
        date,
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidAllowWhileIdle: true,
        payload: id,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
  }

  void requestPermissions() {
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  tz.TZDateTime _scheduleDate(DateTime dateTime, DateTime hour) {
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, dateTime.year,
        dateTime.month, dateTime.day, hour.hour, hour.minute);
    return scheduledDate;
  }

  void configureSelectNotificationSubject(BuildContext context, String route) {
    _selectNotificationSubject.stream.listen((String? payload) async {
      await Navigator.pushNamed(context, route, arguments: payload);
    });
  }

  Future<void> cancelNotification(String id) async {
    List<PendingNotificationRequest> pendingNotifications =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();

    for (PendingNotificationRequest pendingNotification
        in pendingNotifications) {
      if (pendingNotification.payload == id) {
        _flutterLocalNotificationsPlugin.cancel(pendingNotification.id);
        break;
      }
    }
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
