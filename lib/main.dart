import 'package:flutter/material.dart';
import 'package:smart_b/test.dart';
import 'get_started_page.dart';
import 'home_page.dart';
import 'addDrug_page.dart';
import 'moreInformation_page.dart';
import 'moreInformation_relatedPerson_page.dart';
import 'home_relatedPerson_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var status1 = prefs.getBool('PisLoggedIn') ?? false;
  var status2 = prefs.getBool('RisLoggedIn') ?? false;
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
      home: homePage()));
  // status1 == true
  //     ? homePage()
  //     : status2 == true
  //         ? homeRelatedPersonPage()
  //         : GetStarted()));
}
