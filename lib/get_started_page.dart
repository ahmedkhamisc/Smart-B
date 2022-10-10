import 'package:flutter/material.dart';
import 'package:smart_b/home_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  final DatabaseReference _dbref = FirebaseDatabase.instance.ref();
  Iterable<DataSnapshot> user = [];
  Future<Iterable<DataSnapshot>> read() async {
    await _dbref
        .child("Users")
        .child("BOX1")
        .once()
        .then((event) => user = event.snapshot.children);
    return user;
  }

  String whoIs = '';
  TextEditingController UserController = new TextEditingController();
  bool errorVisible = false;
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              Image.asset(
                "images/logo.png",
                height: size.height * 0.5,
                width: size.width * 0.5,
              ),
              Container(
                margin: EdgeInsets.only(
                    left: size.width * 0.08, right: size.width * 0.08),
                child: TextField(
                  controller: UserController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter Your User ID",
                      labelStyle: TextStyle(fontSize: 20)),
                ),
              ),
              Visibility(
                visible: errorVisible,
                child: Container(
                  margin: EdgeInsets.only(top: size.height * 0.005),
                  child: const Text(
                    'Error: The user id is wrong!',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Container(
                height: size.height * 0.1,
                width: size.width * 0.65,
                decoration: const BoxDecoration(
                    color: Color(0xFF44CBB1),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      login().then((_) {
                        if (whoIs == 'P') {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => homePage()),
                              (route) => false);
                        } else if (whoIs == 'R') {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) =>
                                      homePage(user: 'related')),
                              (route) => false);
                        } else {
                          setState(() {
                            errorVisible = true;
                          });
                        }
                      });
                    });
                  },
                  child: const Text('Get started',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    Iterable<DataSnapshot> temp = await read();
    for (var i in temp) {
      if (UserController.text == i.value &&
          user != [] &&
          i.value.toString().contains('P')) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("PisLoggedIn", true);
        _dbref.child("Users").child("BOX1").child("Person").set('person');
        _dbref.child("Users").child("BOX1").child("Related").set('no one');
        whoIs = 'P';
      } else if (UserController.text == i.value &&
          user != [] &&
          i.value.toString().contains('R')) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("RisLoggedIn", true);
        _dbref.child("Users").child("BOX1").child("Related").set('related');
        _dbref.child("Users").child("BOX1").child("Person").set('no one');
        whoIs = 'R';
      }
    }
  }
}
