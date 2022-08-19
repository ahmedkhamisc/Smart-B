import 'package:flutter/material.dart';

class moreInformationPage extends StatefulWidget {
  const moreInformationPage({Key? key}) : super(key: key);

  @override
  State<moreInformationPage> createState() => _moreInformationPageState();
}

class _moreInformationPageState extends State<moreInformationPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //text 'medicine'
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(30),
                child: const Text(
                  'Medicines',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              medicine(size: size),
              SizedBox(
                height: 30,
              ),
              medicine(size: size),

              SizedBox(
                height: 30,
              ),
              medicine(size: size),
            ],
          ),
        ),
      ),
    );
  }
}

class medicine extends StatelessWidget {
  const medicine({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        padding: EdgeInsets.only(
            left: size.width * 0.05,
            bottom: size.height * 0.015,
            top: size.height * 0.015),
        decoration: const BoxDecoration(
          color: Color(0xFF44CBB1),
          borderRadius: BorderRadius.all(
            Radius.circular(28),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: size.width * 0.56,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset("images/pills-bottle.png"),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Panadol',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'headache treatment',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      const Text(
                        'Time per doses:',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        '12AM -1 pill/ 3PM-2 pills / 9PM-1 pill',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      const Divider(
                        color: Colors.black,
                        indent: 2,
                        endIndent: 2,
                        height: 10,
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      const Text(
                        'Bottle Number : 1',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        'Number of pills : 30',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        'Pill Doses : 3 Times/d',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      const Divider(
                        color: Colors.black,
                        indent: 2,
                        endIndent: 2,
                        height: 10,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        'Recommended: 3 Times/d',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black45,
                        ),
                      ),
                      const Text(
                        'Required age : +13',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black45,
                        ),
                      ),
                      const Text(
                        'Dose time: after eating',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black45,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),

            // VerticalDivider(
            //   color: Colors.red,width: 50,
            //   thickness: 5,indent: 5,endIndent: 5,
            // ),

            SizedBox(
                width: size.width * 0.25,
                child: Center(
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.clear,
                        color: Colors.red,
                        size: 50,
                      )),
                ))
          ],
        ));
  }
}
