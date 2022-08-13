import 'package:flutter/material.dart';

class moreInformationPage extends StatefulWidget {
  const moreInformationPage({Key? key}) : super(key: key);

  @override
  State<moreInformationPage> createState() => _moreInformationPageState();
}

class _moreInformationPageState extends State<moreInformationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Text('more information page'),
        ),
      ),
    );
  }
}
