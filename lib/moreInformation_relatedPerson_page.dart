import 'package:flutter/material.dart';
import 'services/local_notification_service.dart';

class moreInformationRelatedPerson extends StatefulWidget {
  const moreInformationRelatedPerson({Key? key}) : super(key: key);

  @override
  State<moreInformationRelatedPerson> createState() =>
      _moreInformationRelatedPersonState();
}

class _moreInformationRelatedPersonState
    extends State<moreInformationRelatedPerson> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: TextButton(
            onPressed: () {},
            child: const Text('Get notification'),
          ),
        ),
      ),
    );
  }
}
