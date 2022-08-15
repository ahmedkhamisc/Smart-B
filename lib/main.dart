import 'dart:async';
import 'package:flutter/material.dart';
import 'get_started_page.dart';
import 'loading_page.dart';
import 'home_page.dart';
import 'addDrug_page.dart';
import 'moreInformation_page.dart';
import 'moreInformation_relatedPerson_page.dart';
import 'home_relatedPerson_page.dart';
import 'services/local_notification_service.dart';

void main() {
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
    home: SplashScreen(),
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final localNotificationService service;
  @override
  void initState() {
    service = localNotificationService();
    service.intialize();
    _getNotification();
    super.initState();
    super.initState();
    Timer(
        const Duration(seconds: 2),
        () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GetStarted()),
            ));
  }

  void _getNotification() async {
    await service.showScheduleNotification(
        id: 0,
        title: 'Panadol',
        body: 'Hey there, it\'s time to take two pills');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: loadingPage(),
    );
  }
}
