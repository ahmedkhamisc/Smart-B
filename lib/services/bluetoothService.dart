import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:smart_b/services/local_notification_service.dart';
import 'package:firebase_database/firebase_database.dart';

class blutoothService extends StatefulWidget {
  String? text;
  blutoothService({this.text});
  @override
  State<blutoothService> createState() => blutoothServiceState();
}

class blutoothServiceState extends State<blutoothService> {
  BluetoothConnection? connection;
  bool isConnecting = true;
  bool get isConnected => connection != null && connection!.isConnected;

  bool isDisconnecting = false;

  String _messageBuffer = '';

  void initState() {
    super.initState();

    BluetoothConnection.toAddress('00:14:03:05:F8:27').then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection!.input!.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
          createBasicNotification(
              id: 0,
              title: 'Connection problem',
              body:
                  'Maybe your bluetooth is off or the box is far from the phone');
        } else {
          print('Disconnected remotely!');
          createBasicNotification(
              id: 0,
              title: 'Connection problem',
              body:
                  'Maybe your bluetooth is off or the box is far from the phone');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
      createBasicNotification(
          id: 0,
          title: 'Connection problem',
          body: 'Maybe your bluetooth is off or the box is far from the phone');
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection!.dispose();
      connection = null;
    }
    myController.dispose();

    super.dispose();
  }

  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: myController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    sendTimeWithNumberOfPills();
                    //_sendMessage(myController.text);
                  });
                },
                child: const Text('Send'))
          ],
        ),
      ),
    );
  }

  DatabaseReference _dbref = FirebaseDatabase.instance.ref();
  late Iterable<DataSnapshot> drugs;

  String test = '';
  void _onDataReceived(Uint8List data) {
    //  data.removeWhere((element) => element == [10]);
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    //print(data);
    if (data.first != 120) {
      data.forEach((byte) {
        if (byte == 8 || byte == 127) {
          backspacesCounter++;
        }
      });
      Uint8List buffer = Uint8List(data.length - backspacesCounter);
      int bufferIndex = buffer.length;

      // Apply backspace control character
      backspacesCounter = 0;
      for (int i = data.length - 1; i >= 0; i--) {
        if (data[i] == 8 || data[i] == 127) {
          backspacesCounter++;
        } else {
          if (backspacesCounter > 0) {
            backspacesCounter--;
          } else {
            buffer[--bufferIndex] = data[i];
          }
        }

        // Create message if there is new line character
        String dataString = String.fromCharCodes(buffer);
        int index = buffer.indexOf(13);
        _messageBuffer = '';
        if (~index != 0) {
          setState(() {
            if (backspacesCounter > 0)
              _messageBuffer.substring(
                  0, _messageBuffer.length - backspacesCounter);
            else
              _messageBuffer + dataString.substring(0, index);
            _messageBuffer = dataString.substring(index);
          });
        } else {
          _messageBuffer = (backspacesCounter > 0
              ? _messageBuffer.substring(
                  0, _messageBuffer.length - backspacesCounter)
              : _messageBuffer + dataString);
        }
      }
      if (_messageBuffer.trim() == 'confirmed') {
        confirmed('confirmed');
      }

      print(_messageBuffer.trim());
      setState(() {
        test = _messageBuffer.trim();
      });
    }
  }

  void sendMessage(String text) async {
    text = text.trim();

    if (text.length > 0) {
      try {
        List<int> list = text.codeUnits;
        Uint8List bytes = Uint8List.fromList(list);
        connection!.output.add(bytes);
        await connection!.output.allSent;

        setState(() {
          print('all sent');
          print(bytes);
        });
        //
        // Future.delayed(Duration(milliseconds: 333)).then((_) {
        //   listScrollController.animateTo(
        //       listScrollController.position.maxScrollExtent,
        //       duration: Duration(milliseconds: 333),
        //       curve: Curves.easeOut);
        // });
      } catch (e) {
        // Ignore error, but notify state
        setState(() {
          print('Error');
        });
      }
    }
  }

  Future<void> sendTimeWithNumberOfPills() async {
    print('hereeeeeeeeeeee');
  }
  //   _sendMessage('time');
  //   await Future<void>.delayed(const Duration(seconds: 2));
  //   _sendMessage('today1-1');
  //   await Future<void>.delayed(const Duration(seconds: 2));
  //   _sendMessage('today1-2');
  // }
}

Future<void> confirmed(String confirmed_orDrugname, {int? doseNumber}) async {
  DatabaseReference _dbref = FirebaseDatabase.instance.ref();
  late Iterable<DataSnapshot> drugs;
  await _dbref
      .child("Drugs")
      .once()
      .then((event) => drugs = event.snapshot.children);
  if (confirmed_orDrugname == 'confirmed') {
    drugs.forEach((element) {
      if (element.child("Doses Times").hasChild("5")) {
        for (int i = 1; i <= 5; ++i) {
          int hour = int.parse(element
              .child("Doses Times")
              .child("$i")
              .child("Hour")
              .value
              .toString());
          int min = int.parse(element
              .child("Doses Times")
              .child("$i")
              .child("Minute")
              .value
              .toString());
          String day = DateTime.now().weekday == 7
              ? 'Sunday'
              : DateTime.now().weekday == 1
                  ? 'Monday'
                  : DateTime.now().weekday == 2
                      ? 'Tuesday'
                      : DateTime.now().weekday == 3
                          ? 'Wednesday'
                          : DateTime.now().weekday == 4
                              ? 'Thursday'
                              : DateTime.now().weekday == 5
                                  ? 'Friday'
                                  : 'Saturday';
          if (DateTime.now().hour == hour &&
              (DateTime.now().minute >= min &&
                  DateTime.now().minute <= 15 + min) &&
              element.child("Days").hasChild("$day")) {
            _dbref
                .child("Drugs")
                .child("${element.child("Name").value}")
                .child("Number of pills")
                .set(int.parse(
                        element.child("Number of pills").value.toString()) -
                    int.parse(element
                        .child("Doses Times")
                        .child("$i")
                        .child("Number of pills")
                        .value
                        .toString()));
          }
        }
      } else if (element.child("Doses Times").hasChild("4")) {
        for (int i = 1; i <= 4; ++i) {
          int hour = int.parse(element
              .child("Doses Times")
              .child("$i")
              .child("Hour")
              .value
              .toString());
          int min = int.parse(element
              .child("Doses Times")
              .child("$i")
              .child("Minute")
              .value
              .toString());
          String day = DateTime.now().weekday == 7
              ? 'Sunday'
              : DateTime.now().weekday == 1
                  ? 'Monday'
                  : DateTime.now().weekday == 2
                      ? 'Tuesday'
                      : DateTime.now().weekday == 3
                          ? 'Wednesday'
                          : DateTime.now().weekday == 4
                              ? 'Thursday'
                              : DateTime.now().weekday == 5
                                  ? 'Friday'
                                  : 'Saturday';
          if (DateTime.now().hour == hour &&
              (DateTime.now().minute >= min &&
                  DateTime.now().minute <= 15 + min) &&
              element.child("Days").hasChild("$day")) {
            _dbref
                .child("Drugs")
                .child("${element.child("Name").value}")
                .child("Number of pills")
                .set(int.parse(
                        element.child("Number of pills").value.toString()) -
                    int.parse(element
                        .child("Doses Times")
                        .child("$i")
                        .child("Number of pills")
                        .value
                        .toString()));
          }
        }
      } else if (element.child("Doses Times").hasChild("3")) {
        for (int i = 1; i <= 3; ++i) {
          int hour = int.parse(element
              .child("Doses Times")
              .child("$i")
              .child("Hour")
              .value
              .toString());
          int min = int.parse(element
              .child("Doses Times")
              .child("$i")
              .child("Minute")
              .value
              .toString());
          String day = DateTime.now().weekday == 7
              ? 'Sunday'
              : DateTime.now().weekday == 1
                  ? 'Monday'
                  : DateTime.now().weekday == 2
                      ? 'Tuesday'
                      : DateTime.now().weekday == 3
                          ? 'Wednesday'
                          : DateTime.now().weekday == 4
                              ? 'Thursday'
                              : DateTime.now().weekday == 5
                                  ? 'Friday'
                                  : 'Saturday';
          if (DateTime.now().hour == hour &&
              (DateTime.now().minute >= min &&
                  DateTime.now().minute <= 15 + min) &&
              element.child("Days").hasChild("$day")) {
            _dbref
                .child("Drugs")
                .child("${element.child("Name").value}")
                .child("Number of pills")
                .set(int.parse(
                        element.child("Number of pills").value.toString()) -
                    int.parse(element
                        .child("Doses Times")
                        .child("$i")
                        .child("Number of pills")
                        .value
                        .toString()));
          }
        }
      } else if (element.child("Doses Times").hasChild("2")) {
        for (int i = 1; i <= 2; ++i) {
          int hour = int.parse(element
              .child("Doses Times")
              .child("$i")
              .child("Hour")
              .value
              .toString());
          int min = int.parse(element
              .child("Doses Times")
              .child("$i")
              .child("Minute")
              .value
              .toString());
          String day = DateTime.now().weekday == 7
              ? 'Sunday'
              : DateTime.now().weekday == 1
                  ? 'Monday'
                  : DateTime.now().weekday == 2
                      ? 'Tuesday'
                      : DateTime.now().weekday == 3
                          ? 'Wednesday'
                          : DateTime.now().weekday == 4
                              ? 'Thursday'
                              : DateTime.now().weekday == 5
                                  ? 'Friday'
                                  : 'Saturday';
          if (DateTime.now().hour == hour &&
              (DateTime.now().minute >= min &&
                  DateTime.now().minute <= 15 + min) &&
              element.child("Days").hasChild("$day")) {
            _dbref
                .child("Drugs")
                .child("${element.child("Name").value}")
                .child("Number of pills")
                .set(int.parse(
                        element.child("Number of pills").value.toString()) -
                    int.parse(element
                        .child("Doses Times")
                        .child("$i")
                        .child("Number of pills")
                        .value
                        .toString()));
          }
        }
      } else {
        int hour = int.parse(element
            .child("Doses Times")
            .child("1")
            .child("Hour")
            .value
            .toString());
        int min = int.parse(element
            .child("Doses Times")
            .child("1")
            .child("Minute")
            .value
            .toString());
        String day = DateTime.now().weekday == 7
            ? 'Sunday'
            : DateTime.now().weekday == 1
                ? 'Monday'
                : DateTime.now().weekday == 2
                    ? 'Tuesday'
                    : DateTime.now().weekday == 3
                        ? 'Wednesday'
                        : DateTime.now().weekday == 4
                            ? 'Thursday'
                            : DateTime.now().weekday == 5
                                ? 'Friday'
                                : 'Saturday';
        if (DateTime.now().hour == hour &&
            (DateTime.now().minute >= min &&
                DateTime.now().minute <= 15 + min) &&
            element.child("Days").hasChild("$day")) {
          _dbref
              .child("Drugs")
              .child("${element.child("Name").value}")
              .child("Number of pills")
              .set(
                  int.parse(element.child("Number of pills").value.toString()) -
                      int.parse(element
                          .child("Doses Times")
                          .child("1")
                          .child("Number of pills")
                          .value
                          .toString()));
        }
      }
    });
  } else {
    drugs.forEach((element) {
      if (element.child("Name").value.toString() == confirmed_orDrugname)
        _dbref
            .child("Drugs")
            .child("$confirmed_orDrugname")
            .child("Number of pills")
            .set(int.parse(element.child("Number of pills").value.toString()) -
                int.parse(element
                    .child("Doses Times")
                    .child("$doseNumber")
                    .child("Number of pills")
                    .value
                    .toString()));
    });
  }
}

void gg() {
  print(DateTime.sunday);
}
