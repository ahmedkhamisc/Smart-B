import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class moreInformationRelatedPerson extends StatefulWidget {
  const moreInformationRelatedPerson({Key? key}) : super(key: key);

  @override
  State<moreInformationRelatedPerson> createState() =>
      _moreInformationRelatedPersonState();
}

class _moreInformationRelatedPersonState
    extends State<moreInformationRelatedPerson> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: TextButton(
            onPressed: () {
              // _getNotification(11, 52);
            },
            child: const Text('Get notification'),
          ),
        ),
      ),
    );
  }
}
