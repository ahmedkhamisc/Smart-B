import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:smart_b/services/bluetoothService.dart';
import 'package:smart_b/services/firebase&Constants.dart';
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
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeService();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var status1 = prefs.getBool('PisLoggedIn') ?? false;
  var status2 = prefs.getBool('RisLoggedIn') ?? false;
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
  // status1 == true
  //     ? homePage()
  //     : status2 == true
  //         ? homeRelatedPersonPage()
  //         : GetStarted()));
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch
bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');

  return true;
}

void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();
  await Firebase.initializeApp();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  print('hiiii');
  // bring to foreground
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    final hello = preferences.getString("hello");
    print(hello);
    getBackgroundServices();

    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
          title: 'Status', content: 'Services are on');
    }

    /// you can see this log in logcat
    print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
  });
}

get() {
  print('test');
}
