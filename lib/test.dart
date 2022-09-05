import 'package:flutter/material.dart';
import 'package:smart_b/services/local_notification_service.dart';
import 'services/firebase&Constants.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'services/bluetoothService.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class test extends StatefulWidget {
  const test({Key? key}) : super(key: key);

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  @override
  void initState() {
    AwesomeNotifications().requestPermissionToSendNotifications();
    super.initState();
  }

  final fifteenAgo = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: TextButton(
        onPressed: () {
          setState(() {
            // getNotification('name', 1, 0, 39, 0);
            // blutoothService();
            // createNotificationWithButtons(title: 'test', id: 0, body: 'gg');
            // AwesomeNotifications().actionStream.listen(
            //   (ReceivedAction receivedAction) {
            //     if (receivedAction.buttonKeyPressed == 'Completed') {
            //       print('com');
            //     } else if (receivedAction.buttonKeyPressed == 'Skipped') {
            //       print('skipp');
            //     }
            //
            //     //Here if the user clicks on the notification itself
            //     //without any button
            //   },
            // );

            createScheduleNotification(id: 0, title: 'title', body: 'body');
          });
        },
        child: Text('click'),
      )),
      // StreamBuilder<Object>(
      //     stream: getDailyRevData(),
      //     builder: (context, snapshot) {
      //       return Center(
      //         child: TextButton(
      //           onPressed: () {
      //             print(snapshot.connectionState);
      //           },
      //           child: Text('Click'),
      //         ),
      //       );
      //     }),
    );
  }
}
