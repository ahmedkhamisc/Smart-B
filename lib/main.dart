import 'dart:async';
import 'dart:io';
import 'package:awesome_notifications/android_foreground_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:smart_b/services/firebase&Constants.dart';
import 'package:smart_b/services/local_notification_service.dart';
import 'package:smart_b/test.dart';
import 'get_started_page.dart';
import 'home_page.dart';
import 'addDrug_page.dart';
import 'moreInformation_page.dart';
import 'moreInformation_relatedPerson_page.dart';
import 'home_relatedPerson_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:workmanager/workmanager.dart';

const fetchBackground = "fetchBackground";
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case fetchBackground:
        await Firebase.initializeApp().then((value) async {
          for (int i = 1; i <= 900; ++i) {
            await Future.delayed(const Duration(seconds: 1));
            getBackgroundServices();
          }
        });
        break;
    }
    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await initializeService();
  await Workmanager().initialize(
    callbackDispatcher,
  );
  await Workmanager().registerPeriodicTask(
    "1",
    fetchBackground,
    frequency: const Duration(minutes: 15),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      'resource://drawable/logo',
      [
        NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel',
            importance: NotificationImportance.Max,
            defaultColor: Color(0xFF44CBB1),
            ledColor: Colors.white),
        NotificationChannel(
            channelKey: 'schedule_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel',
            importance: NotificationImportance.Max,
            defaultColor: Color(0xFF44CBB1),
            ledColor: Colors.white),
        NotificationChannel(
            channelKey: 'button_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel',
            locked: true,
            importance: NotificationImportance.Max,
            defaultColor: Color(0xFF44CBB1),
            ledColor: Colors.white)
      ],
      debug: true);
  AwesomeNotifications().requestPermissionToSendNotifications();
  AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var status1 = prefs.getBool('PisLoggedIn') ?? false;
  var status2 = prefs.getBool('RisLoggedIn') ?? false;

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            color: Color(0xFF44CBB1),
          ),
          iconTheme: const IconThemeData(
            color: Color(0xFF44CBB1),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF44CBB1),
          ),
        ),
        home: homePage()));
  });
  // status1 == true
  //     ? const homePage()
  //     : status2 == true
  //         ? const homeRelatedPersonPage()
  //         : const GetStarted()));
}
