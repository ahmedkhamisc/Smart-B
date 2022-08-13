import 'package:flutter/material.dart';
import 'moreInformation_page.dart';
import 'addDrug_page.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage>
    with SingleTickerProviderStateMixin {
  int _currentPageIndex = 0;
  final List _pagesBody = [
    homePageBody(),
    addDrugPage(),
    moreInformationPage(),
  ];

  late final TabController controller;
  Color indicatorColor = Color(0xFF44CBB1);
  bool showBottomBar = true;
  @override
  void initState() {
    controller = TabController(length: 3, vsync: this);
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

class _homePageBodyState extends State<homePageBody> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
