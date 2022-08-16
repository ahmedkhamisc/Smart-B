import 'package:flutter/material.dart';
import 'dart:async';
import 'services/local_notification_service.dart';
import 'get_started_page.dart';

class loadingPage extends StatelessWidget {
  const loadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Image.asset(
          'images/logo.png',
          height: 170,
          width: 170,
        ),
      )),
    );
  }
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
    _getNotification(12, 46, 0);
    _getNotification(12, 47, 1);
    _getNotification(12, 48, 2);

    super.initState();
    Timer(
        const Duration(seconds: 2),
        () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GetStarted()),
            ));
  }

  void _getNotification(int hours, int min, int id) async {
    await service.showScheduleNotification(
      id: id,
      title: 'Panadol',
      body: 'Hey there, it\'s time to take two pills',
      hours: hours,
      min: min,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: loadingPage(),
    );
  }
}
