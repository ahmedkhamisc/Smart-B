import 'package:flutter/material.dart';

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
        child: Container(
          child: Text('more information related person page'),
        ),
      ),
    );
  }
}
