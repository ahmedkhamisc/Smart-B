import 'package:awesome_notifications/awesome_notifications.dart';
import 'dart:async';
import 'package:flutter/material.dart';

Future<void> createScheduleNotification({
  required int id,
  required String title,
  required String body,
}) async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: id, channelKey: 'schedule_channel', title: title, body: body),
      schedule: NotificationCalendar(
          timeZone: 'GMT+03:00',
          repeats: true,
          hour: 15,
          minute: 0,
          second: 0,
          millisecond: 0));
}

Future<void> createNotificationWithButtons({
  required int id,
  required String title,
  required String body,
}) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: id, channelKey: 'button_channel', title: title, body: body),
    actionButtons: <NotificationActionButton>[
      NotificationActionButton(
          key: 'Completed', label: 'Completed', color: Color(0xFF44CBB1)),
      NotificationActionButton(
          key: 'Skipped', label: 'Skipped', color: Colors.grey),
    ],
  );
}
