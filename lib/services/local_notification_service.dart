import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

class localNotificationService {
  localNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();
  Future<void> intialize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    final InitializationSettings settings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _localNotificationService.initialize(settings);
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails andriodNotifiactionDetails =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
    );

    const IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails();
    return const NotificationDetails(
        android: andriodNotifiactionDetails, iOS: iosNotificationDetails);
  }

  Future<void> showScheduleNotification(
      {required int id,
      required String title,
      required String body,
      required int hours,
      required int min,
      required int sec}) async {
    final details = await _notificationDetails();
    var dateTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, hours, min, sec);
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    if (dateTime.isBefore(now))
      dateTime = dateTime.add(const Duration(days: 1));
    else
      dateTime = dateTime;
    await _localNotificationService.zonedSchedule(
        id, title, body, tz.TZDateTime.from(dateTime, tz.local), details,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void _onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print('id $id');
  }
}
