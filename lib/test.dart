import 'package:flutter/material.dart';
import 'services/firebase&Constants.dart';
import 'package:timeago/timeago.dart' as timeago;

class test extends StatefulWidget {
  const test({Key? key}) : super(key: key);

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  final fifteenAgo = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: TextButton(
        onPressed: () {
          setState(() {
            // getNotification('name', 1, 0, 39, 0);
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
