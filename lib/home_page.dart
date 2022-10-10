import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'moreInformation_page.dart';
import 'addDrug_page.dart';
import 'dart:async';
import 'services/firebase&Constants.dart';
import 'get_started_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class homePage extends StatefulWidget {
  homePage({Key? key, this.user}) : super(key: key);
  String? user;
  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  late final TabController controller;
  late final List _pagesBody;

  Color indicatorColor = Color(0xFF44CBB1);
  bool showBottomBar = true;
  @override
  void initState() {
    getDailyAdvice();
    _pageController = PageController();
    controller = TabController(length: 2, vsync: this);
    _pagesBody = [
      homePageBody(user: widget.user),
      moreInformationPage(
        user: widget.user,
      ),
    ];
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    controller.dispose();
    super.dispose();
  }

  Widget reviewSaved = Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [],
  );
  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: _pagesBody[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (val) {
          setState(() {
            _currentIndex = val;
          });
        },
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF44CBB1),
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
              label: '', icon: Icon(FontAwesomeIcons.calendarCheck)),
          BottomNavigationBarItem(
              label: '', icon: Icon(FontAwesomeIcons.prescriptionBottleMedical))
        ],
      ),
    );
  }
}

class homePageBody extends StatefulWidget {
  homePageBody({Key? key, this.user}) : super(key: key);
  String? user;
  @override
  State<homePageBody> createState() => _homePageBodyState();
}

Column tempRev = Column(
  children: const [
    Expanded(child: Text('Add Drugs to show daily reviews for it'))
  ],
);

class _homePageBodyState extends State<homePageBody> {
  int t = 0;
  bool checkLogout = false;
  late Size size;
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

  late double fontSize;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(size.width * 0.05),
                    child: const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Daily Review',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        )),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: size.width * 0.26),
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
                  padding: const EdgeInsets.all(21),
                  child: StreamBuilder(
                      initialData: tempRev,
                      stream: getDailyRevData(),
                      builder: (context, AsyncSnapshot<Widget> snapshot) {
                        if (t == 0) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(
                              color: Color(0xFF44CBB1),
                            );
                          }
                        }
                        if (snapshot.data == null) {
                          t = 1;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Center(
                                child: Text('No doses for today'),
                              )
                            ],
                          );
                        }
                        t = 1;
                        return snapshot.data!;
                      })),
            )
          ],
        ),
      ),
    );
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("PisLoggedIn", false);
    prefs.setBool("RisLoggedIn", false);
    DatabaseReference _dbref = FirebaseDatabase.instance.ref();
    _dbref.child("Users").child("current").set('no one');
  }

  Future<void> _showMyDialogLogout(
      {required String title, required String body}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: Color(0xFF44CBB1),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(title),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(body),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Yes',
                style: TextStyle(color: Color(0xFF44CBB1)),
              ),
              onPressed: () {
                logout().then((value) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const GetStarted()),
                      (route) => false);
                });
              },
            ),
            TextButton(
              child: const Text(
                'No',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                checkLogout = true;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
