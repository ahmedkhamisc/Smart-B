import 'package:flutter/material.dart';
import 'get_started_page.dart';
import 'loading_page.dart';
import 'home_page.dart';
import 'addDrug_page.dart';
import 'moreInformation_page.dart';
import 'moreInformation_relatedPerson_page.dart';
import 'home_relatedPerson_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.light().copyWith(
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        color: Color(0xFF44CBB1),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFF44CBB1),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF44CBB1),
      ),
    ),
    home: SplashScreen(),
  ));
}
