import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'moreInformation_page.dart';
import 'addDrug_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:async';
import 'services/firebase&Constants.dart';
import 'get_started_page.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);
  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage>
    with SingleTickerProviderStateMixin {
  int _currentPageIndex = 0;
  final List _pagesBody = [
    const homePageBody(),
    addDrugPage(),
    moreInformationPage(),
  ];
  late final TabController controller;
  Color indicatorColor = Color(0xFF44CBB1);
  bool showBottomBar = true;
  @override
  void initState() {
    controller = TabController(length: 3, vsync: this);
    getDailyAdvice();
    super.initState();
  }

  void onTapped(int index) {
    setState(() {
      _currentPageIndex = index;
      if (index == 1) {
        indicatorColor = Colors.white;
        showBottomBar = false;
      } else {
        indicatorColor = Color(0xFF44CBB1);
        showBottomBar = true;
      }
    });
  }

  Widget reviewSaved = Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [],
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pagesBody[_currentPageIndex],
      bottomNavigationBar: showBottomBar
          ? Container(
              color: Colors.white,
              child: TabBar(
                controller: controller,
                padding: EdgeInsets.only(bottom: 20.0),
                unselectedLabelColor: const Color(0xFF44CBB1),
                labelColor: const Color(0xFF44CBB1),
                indicatorColor: indicatorColor,
                indicatorSize: TabBarIndicatorSize.label,
                onTap: onTapped,
                tabs: const [
                  Tab(
                    icon: Icon(
                      Icons.home,
                      size: 36.0,
                    ),
                  ),
                  Tab(
                    icon: FloatingActionButton(
                      onPressed: null,
                      child: Icon(
                        Icons.add,
                        size: 36.0,
                      ),
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.wysiwyg,
                      size: 36.0,
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}

class homePageBody extends StatefulWidget {
  const homePageBody({Key? key}) : super(key: key);

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
  int _current = 0;
  final CarouselController _controller = CarouselController();
  bool checkLogout = false;
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    fontSize = size.height * 0.024;
    imgHeight = size.height * 0.17;
    imgWidth = size.width * 0.17;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: CarouselSlider(
                  items: adviceList,
                  carouselController: _controller,
                  options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 2.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: adviceList.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: size.width * 0.035,
                      height: size.height * 0.035,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF44CBB1)
                            .withOpacity(_current == entry.key ? 0.9 : 0.3),
                      ),
                    ),
                  );
                }).toList(),
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 33.0, top: 25.0),
                    child: const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Daily Review',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17.0),
                        )),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(left: size.height * 0.27, top: 25.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _showMyDialogLogout(
                              title: 'Smart-B support',
                              body: 'Are you sure you want to logout?');
                        });
                      },
                      child: const Icon(
                        Icons.logout,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(21),
                  child: Column(
                    children: [
                      StreamBuilder(
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
                          }),
                    ],
                  ))
            ],
          ),
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

late double fontSize;
late double imgHeight;
late double imgWidth;
final List<Widget> adviceList = [
  Container(
    decoration: const BoxDecoration(
      color: Color(0xFF44CBB1),
      borderRadius: BorderRadius.all(
        Radius.circular(28),
      ),
    ),
    child: Row(
      children: <Widget>[
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(left: 25.0, top: 25.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Drink milk daily to prevent osteoporosis and bone fractures and even help you maintain a healthy weight',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
        ),
        Flexible(
          child: Container(
            margin: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                'images/milk.png',
                height: imgHeight,
                width: imgWidth,
                alignment: Alignment.bottomRight,
              ),
            ),
          ),
        ),
      ],
    ),
  ),
  Container(
    decoration: const BoxDecoration(
      color: Color(0xFF44CBB1),
      borderRadius: BorderRadius.all(
        Radius.circular(28),
      ),
    ),
    child: Row(
      children: <Widget>[
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(left: 25.0, top: 25.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Excessive coffee consumption is harmful to heart patients',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
        ),
        Flexible(
          child: Container(
            margin: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                'images/cup.png',
                height: imgHeight,
                width: imgWidth,
                alignment: Alignment.bottomRight,
              ),
            ),
          ),
        ),
      ],
    ),
  ),
  Container(
    decoration: const BoxDecoration(
      color: Color(0xFF44CBB1),
      borderRadius: BorderRadius.all(
        Radius.circular(28),
      ),
    ),
    child: Row(
      children: <Widget>[
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(left: 25.0, top: 25.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Inadequate sleep reduces leptin levels; It is responsible for the feeling of satiety',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
        ),
        Flexible(
          child: Container(
            margin: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                'images/sleeping.png',
                height: imgHeight,
                width: imgWidth,
                alignment: Alignment.bottomRight,
              ),
            ),
          ),
        ),
      ],
    ),
  ),
];
