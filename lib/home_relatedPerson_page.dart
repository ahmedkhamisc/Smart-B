import 'package:flutter/material.dart';

class homeRelatedPersonPage extends StatefulWidget {
  const homeRelatedPersonPage({Key? key}) : super(key: key);

  @override
  State<homeRelatedPersonPage> createState() => _homeRelatedPersonPageState();
}

class _homeRelatedPersonPageState extends State<homeRelatedPersonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Text('home related person page'),
        ),
      ),
    );
  }
}
