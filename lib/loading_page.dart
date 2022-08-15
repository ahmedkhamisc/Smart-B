import 'package:flutter/material.dart';

class loadingPage extends StatelessWidget {
  const loadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Image.asset(
          'images/logo.png',
          height: 170,
          width: 170,
        ),
      )),
    );
  }
}
