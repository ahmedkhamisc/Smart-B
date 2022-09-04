import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

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
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
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

  int count = 30;
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
      if (_messageBuffer == 'confirmed') print(--count);

      print(_messageBuffer.trim());
      setState(() {
        test = _messageBuffer.trim();
      });
    }
  }

  void _sendMessage(String text) async {
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
    _sendMessage('time');
    await Future<void>.delayed(const Duration(seconds: 2));
    _sendMessage('today1-1');
    await Future<void>.delayed(const Duration(seconds: 2));
    _sendMessage('today1-2');
  }
}
