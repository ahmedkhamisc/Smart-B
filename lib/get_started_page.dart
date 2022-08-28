import 'package:flutter/material.dart';
import 'package:smart_b/home_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:smart_b/home_relatedPerson_page.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  DatabaseReference _dbref = FirebaseDatabase.instance.ref();
  Iterable<DataSnapshot> user = [];
  Iterable<DataSnapshot> read() {
    _dbref
        .child("Users")
        .child("BOX1")
        .once()
        .then((event) => user = event.snapshot.children);
    return user;
  }

  TextEditingController UserController = new TextEditingController();
  bool errorVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              //margin:EdgeInsets.only(bottom: 200.0) ,
              child: Image.asset(
            "images/logo.png",
            height: 170,
            width: 170,
          )),
          SizedBox(
            height: 60.0,
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              controller: UserController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Your User ID",
                  labelStyle: TextStyle(fontSize: 20)),
            ),
          ),
          Visibility(
            visible: errorVisible,
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: const Text(
                'Error: User Id is wrong',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          Container(
            height: 61,
            width: 218,
            decoration: BoxDecoration(
                color: Color(0xFF44CBB1),
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: FlatButton(
              onPressed: () {
                bool temp = false;
                setState(() async {
                  for (var i in read()) {
                    if (UserController.text == i.value &&
                        user != [] &&
                        i.value.toString().contains('P')) {
                      temp = true;
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool("PisLoggedIn", true);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const homePage()));
                    } else if (UserController.text == i.value &&
                        user != [] &&
                        i.value.toString().contains('R')) {
                      temp = true;
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool("RisLoggedIn", true);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const homeRelatedPersonPage()));
                    }
                  }
                });
                if (!temp)
                  errorVisible = true;
                else
                  errorVisible = false;
              },
              child: Text('Get started',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ),
        ],
      )),
    );
  }
}
