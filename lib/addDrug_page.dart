import 'package:flutter/material.dart';

class addDrugPage extends StatefulWidget {
  const addDrugPage({Key? key}) : super(key: key);

  @override
  State<addDrugPage> createState() => _addDrugPageState();
}

class _addDrugPageState extends State<addDrugPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Text('add drug page'),
        ),
      ),
    );
  }
}
