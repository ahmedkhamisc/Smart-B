import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_b/home_page.dart';
import 'package:smart_b/services/local_notification_service.dart';
import 'services/firebase&Constants.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'addDrug_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class test extends StatefulWidget {
  const test({Key? key}) : super(key: key);

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final fifteenAgo = DateTime.now();
  Future<void> showMyDialog(
      {required String title, required String body}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: Color(0xFF44CBB1),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(title),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(body),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Yes',
                style: TextStyle(color: Color(0xFF44CBB1)),
              ),
              onPressed: () {
                // saveChangesCheck = false;
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'No',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                //saveChangesCheck = true;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        onPressed: () {
          //confirmed(name: 'Carvedilol', doseNum: 1, state: 'Completed');
          // timeAll(pillsNums: [0, 0, 0, 0]);
          createNotificationWithButtons(
              id: 0, title: 'Carvedilol', body: 'body', doseNum: 1);
        },
        child: Text('click'),
      )),
    );
  }
}
