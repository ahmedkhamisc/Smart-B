import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase&Constants.dart';

Future<void> createBasicNotification({
  required int id,
  required String title,
  required String body,
}) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: id, channelKey: 'basic_channel', title: title, body: body),
  );
}

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

Future<void> createNotificationWithButtons(
    {required int id,
    required String title,
    required String body,
    required int doseNum}) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: id,
        channelKey: 'button_channel',
        title: title,
        body: body,
        summary: '$doseNum'),
    actionButtons: <NotificationActionButton>[
      NotificationActionButton(
          key: 'Completed',
          label: 'Completed',
          color: const Color(0xFF44CBB1),
          actionType: ActionType.SilentBackgroundAction),
      NotificationActionButton(
          key: 'Skipped',
          label: 'Skipped',
          color: Colors.grey,
          actionType: ActionType.SilentBackgroundAction),
    ],
  );
}

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    globalState[receivedAction.title.toString()] = 'Skipped';
  }

  /// Use this method to detect when the user taps on a notification or action button
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    await Firebase.initializeApp();
    print(receivedAction.buttonKeyPressed);
    if (receivedAction.buttonKeyPressed == 'Completed') {
      await confirmed(
          name: receivedAction.title.toString(),
          doseNum: int.parse(receivedAction.summary!),
          state: 'Completed');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int drugsChecked = prefs.getInt("drugsChecked")!;
      --drugsChecked;
      drugsChecked == 0
          ? {
              setLifeCycleState(state: 'confirmed'),
            }
          : {};
      prefs.setInt("drugsChecked", drugsChecked);
    } else if (receivedAction.buttonKeyPressed == 'Skipped') {
      print(receivedAction.summary);
      await confirmed(
          name: receivedAction.title.toString(),
          doseNum: int.parse(receivedAction.summary!),
          state: 'Skipped');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int drugsChecked = prefs.getInt("drugsChecked")!;
      --drugsChecked;
      drugsChecked == 0
          ? {
              setLifeCycleState(state: 'confirmed'),
            }
          : {};
      prefs.setInt("drugsChecked", drugsChecked);
    } else {
      print('Notification was clicked');
    }
    // // Navigate into pages, avoiding to open the notification details page over another details page already opened
    // MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil('/notification-page',
    //         (route) => (route.settings.name != '/notification-page') || route.isFirst,
    //     arguments: receivedAction);
  }
}
