import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'services/firebase&Constants.dart';

class moreInformationPage extends StatefulWidget {
  moreInformationPage({Key? key, this.user}) : super(key: key);
  String? user;
  @override
  State<moreInformationPage> createState() => _moreInformationPageState();
}

class _moreInformationPageState extends State<moreInformationPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<Column> snapshot) {
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(30),
                    child: const Text(
                      'Medicines',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                StreamBuilder(
                    stream: widget.user != null
                        ? getMedicineData(size: size, user: widget.user)
                        : getMedicineData(size: size),
                    builder: (context, AsyncSnapshot<Widget> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(
                          color: Color(0xFF44CBB1),
                        );
                      }
                      return snapshot.data!;
                    }),
              ],
            ),
          ),
        ),
      );
    });
  }
}
