import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'addDrug_page.dart';
import 'get_started_page.dart';
import 'services/firebase&Constants.dart';

class moreInformationPage extends StatefulWidget {
  moreInformationPage({Key? key, this.user}) : super(key: key);
  String? user;
  @override
  State<moreInformationPage> createState() => _moreInformationPageState();
}

class _moreInformationPageState extends State<moreInformationPage> {
  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        logout().whenComplete(() {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => const GetStarted()),
              (route) => false);
        });
        break;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("PisLoggedIn", false);
    prefs.setBool("RisLoggedIn", false);
    DatabaseReference _dbref = FirebaseDatabase.instance.ref();
    _dbref.child("Users").child("BOX1").child("Related").set('no one');
    _dbref.child("Users").child("BOX1").child("Person").set('no one');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<Column> snapshot) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.all(size.width * 0.05),
                      child: const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Medicines',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          )),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: size.width * 0.3265),
                        child: widget.user == null
                            ? IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) => addDrugPage()));
                                },
                                icon: const Icon(
                                  FontAwesomeIcons.plus,
                                  color: Colors.black,
                                ),
                              )
                            : null,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: widget.user == null
                                ? size.width * 0.001
                                : size.width * 0.12),
                        child: PopupMenuButton<String>(
                          iconSize: 30,
                          icon: Icon(Icons.more_vert,
                              size: size.width * 0.08, color: Colors.black),
                          onSelected: handleClick,
                          itemBuilder: (BuildContext context) {
                            return {'Logout'}.map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: StreamBuilder(
                      stream: widget.user != null
                          ? getMedicineData(size: size, user: widget.user)
                          : getMedicineData(size: size),
                      builder: (context, AsyncSnapshot<Widget> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(
                            color: Color(0xFF44CBB1),
                          );
                        } else if (snapshot.data == null) {
                          return Column(
                            children: const [Text('No meds to show')],
                          );
                        } else if (snapshot.hasError) {
                          return Column(
                            children: const [Text('Error 404')],
                          );
                        } else {
                          return snapshot.data!;
                        }
                      }),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
