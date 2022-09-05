import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:smart_b/services/local_notification_service.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'bluetoothService.dart';

DatabaseReference _dbref = FirebaseDatabase.instance.ref();
Map<String, List<int>> daysData = {};
Map<String, List> dosesTimeData = {};

Stream<Widget> getMedicineData({required Size size}) async* {
  while (true) {
    await Future<void>.delayed(const Duration(seconds: 1));
    late Iterable<DataSnapshot> data;
    late String drugName;
    String dosesTime = '';
    late String bottleNumber;
    late String numberOfPills;
    String days = '';
    late String dosesPerDay;
    Column cards = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [],
    );

    await _dbref
        .child("Drugs")
        .once()
        .then((event) => data = event.snapshot.children);
    data.forEach((element) {
      dosesPerDay = element.child("Doses per day").value.toString();
      bottleNumber = element.child("Medicine bottle number").value.toString();
      drugName = element.child("Name").value.toString();
      numberOfPills = element.child("Number of pills").value.toString();
      daysData[drugName] = [];
      int sum = 0;
      if (element.child("Days").hasChild("Sunday")) {
        daysData[drugName] = daysData[drugName]! + [1];
        days += 'Sun, ';
        sum++;
      }
      if (element.child("Days").hasChild("Monday")) {
        daysData[drugName] = daysData[drugName]! + [2];
        days += 'Mon, ';
        sum++;
      }
      if (element.child("Days").hasChild("Tuesday")) {
        daysData[drugName] = daysData[drugName]! + [3];
        days += 'Tue, ';
        sum++;
      }
      if (element.child("Days").hasChild("Wednesday")) {
        daysData[drugName] = daysData[drugName]! + [4];
        days += 'Wed, ';
        sum++;
      }
      if (element.child("Days").hasChild("Thursday")) {
        daysData[drugName] = daysData[drugName]! + [5];
        days += 'Thu, ';
        sum++;
      }
      if (element.child("Days").hasChild("Friday")) {
        daysData[drugName] = daysData[drugName]! + [6];
        days += 'Fri, ';
        sum++;
      }
      if (element.child("Days").hasChild("Saturday")) {
        daysData[drugName] = daysData[drugName]! + [7];
        days += 'Sat, ';
        sum++;
      }
      if (sum == 7) days = 'Every day  ';
      days = days.substring(0, days.length - 2);

      dosesTimeData[drugName] = [];
      if (element.child("Doses Times").hasChild("5")) {
        for (int i = 1; i <= 5; ++i) {
          dosesTimeData[drugName] = dosesTimeData[drugName]! +
              [element.child("Doses Times").child("$i").child("Hour").value] +
              [element.child("Doses Times").child("$i").child("Minute").value] +
              [
                element
                    .child("Doses Times")
                    .child("$i")
                    .child("Number of pills")
                    .value
              ] +
              [element.child("Doses Times").child("$i").child("period").value];
          dosesTime += element
                  .child("Doses Times")
                  .child("$i")
                  .child("Hour")
                  .value
                  .toString() +
              ':' +
              element
                  .child("Doses Times")
                  .child("$i")
                  .child("Minute")
                  .value
                  .toString() +
              element
                  .child("Doses Times")
                  .child("$i")
                  .child("period")
                  .value
                  .toString() +
              ' - ' +
              element
                  .child("Doses Times")
                  .child("$i")
                  .child("Number of pills")
                  .value
                  .toString() +
              'Pills' +
              ', ';
        }
      } else if (element.child("Doses Times").hasChild("4")) {
        for (int i = 1; i <= 4; ++i) {
          dosesTimeData[drugName] = dosesTimeData[drugName]! +
              [element.child("Doses Times").child("$i").child("Hour").value] +
              [element.child("Doses Times").child("$i").child("Minute").value] +
              [
                element
                    .child("Doses Times")
                    .child("$i")
                    .child("Number of pills")
                    .value
              ] +
              [element.child("Doses Times").child("$i").child("period").value];
          dosesTime += element
                  .child("Doses Times")
                  .child("$i")
                  .child("Hour")
                  .value
                  .toString() +
              ':' +
              element
                  .child("Doses Times")
                  .child("$i")
                  .child("Minute")
                  .value
                  .toString() +
              element
                  .child("Doses Times")
                  .child("$i")
                  .child("period")
                  .value
                  .toString() +
              ' - ' +
              element
                  .child("Doses Times")
                  .child("$i")
                  .child("Number of pills")
                  .value
                  .toString() +
              'Pills' +
              ', ';
        }
      } else if (element.child("Doses Times").hasChild("3")) {
        for (int i = 1; i <= 3; ++i) {
          dosesTimeData[drugName] = dosesTimeData[drugName]! +
              [element.child("Doses Times").child("$i").child("Hour").value] +
              [element.child("Doses Times").child("$i").child("Minute").value] +
              [
                element
                    .child("Doses Times")
                    .child("$i")
                    .child("Number of pills")
                    .value
              ] +
              [element.child("Doses Times").child("$i").child("period").value];
          dosesTime += element
                  .child("Doses Times")
                  .child("$i")
                  .child("Hour")
                  .value
                  .toString() +
              ':' +
              element
                  .child("Doses Times")
                  .child("$i")
                  .child("Minute")
                  .value
                  .toString() +
              element
                  .child("Doses Times")
                  .child("$i")
                  .child("period")
                  .value
                  .toString() +
              ' - ' +
              element
                  .child("Doses Times")
                  .child("$i")
                  .child("Number of pills")
                  .value
                  .toString() +
              'Pills' +
              ', ';
        }
      } else if (element.child("Doses Times").hasChild("2")) {
        for (int i = 1; i <= 2; ++i) {
          dosesTimeData[drugName] = dosesTimeData[drugName]! +
              [element.child("Doses Times").child("$i").child("Hour").value] +
              [element.child("Doses Times").child("$i").child("Minute").value] +
              [
                element
                    .child("Doses Times")
                    .child("$i")
                    .child("Number of pills")
                    .value
              ] +
              [element.child("Doses Times").child("$i").child("period").value] +
              [element.child("Doses Times").child("$i").child("Minute").value] +
              [
                element
                    .child("Doses Times")
                    .child("$i")
                    .child("Number of pills")
                    .value
              ] +
              [element.child("Doses Times").child("$i").child("period").value];
          dosesTime += element
                  .child("Doses Times")
                  .child("$i")
                  .child("Hour")
                  .value
                  .toString() +
              ':' +
              element
                  .child("Doses Times")
                  .child("$i")
                  .child("Minute")
                  .value
                  .toString() +
              element
                  .child("Doses Times")
                  .child("$i")
                  .child("period")
                  .value
                  .toString() +
              ' - ' +
              element
                  .child("Doses Times")
                  .child("$i")
                  .child("Number of pills")
                  .value
                  .toString() +
              'Pills' +
              ', ';
        }
      } else {
        dosesTimeData[drugName] = dosesTimeData[drugName]! +
            [element.child("Doses Times").child("1").child("Hour").value] +
            [element.child("Doses Times").child("1").child("Minute").value] +
            [
              element
                  .child("Doses Times")
                  .child("1")
                  .child("Number of pills")
                  .value
            ] +
            [element.child("Doses Times").child("1").child("period").value];

        dosesTime += element
                .child("Doses Times")
                .child("1")
                .child("Hour")
                .value
                .toString() +
            ':' +
            element
                .child("Doses Times")
                .child("1")
                .child("Minute")
                .value
                .toString() +
            element
                .child("Doses Times")
                .child("1")
                .child("period")
                .value
                .toString() +
            ' - ' +
            element
                .child("Doses Times")
                .child("1")
                .child("Number of pills")
                .value
                .toString() +
            ' Pills' +
            ', ';
      }
      dosesTime = dosesTime.substring(0, dosesTime.length - 2);

      cards.children.insert(
          cards.children.length,
          Card(
            size: size,
            drugName: drugName,
            dosesTime: dosesTime,
            bottleNumber: bottleNumber,
            days: days,
            numberOfPills: numberOfPills,
          ));
      days = '';
      dosesTime = '';
    });

    yield cards;
  }
}

class Card extends StatelessWidget {
  Card(
      {required this.size,
      required this.drugName,
      required this.dosesTime,
      required this.bottleNumber,
      required this.numberOfPills,
      required this.days});
  final Size size;
  String drugName;
  String dosesTime;
  String bottleNumber;
  String numberOfPills;
  String days;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin:
            EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 10),
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
                        children: [
                          Text(
                            drugName,
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
                      Text(
                        dosesTime,
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
                      Text(
                        'Bottle Number : $bottleNumber',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Number of pills : $numberOfPills',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Days : $days',
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
            SizedBox(
                width: size.width * 0.25,
                child: Center(
                  child: IconButton(
                      onPressed: () {
                        if (drugName != '')
                          _dbref.child("Drugs").child("$drugName").remove();
                      },
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

//
//
//
//
//
//
int id = 0;
Stream<Widget> getDailyRevData() async* {
  while (true) {
    await Future<void>.delayed(const Duration(seconds: 1));
    late Iterable<DataSnapshot> data;
    late String drugName;
    String doseTime = '';
    late int numOfPills;

    Column review = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [],
    );

    await _dbref
        .child("Drugs")
        .once()
        .then((event) => data = event.snapshot.children);
    data.forEach((element) {
      drugName = element.child("Name").value.toString();
      daysData[drugName] = [];
      int sum = 0;
      if (element.child("Days").hasChild("Sunday")) {
        daysData[drugName] = daysData[drugName]! + [7];
      }
      if (element.child("Days").hasChild("Monday")) {
        daysData[drugName] = daysData[drugName]! + [1];
      }
      if (element.child("Days").hasChild("Tuesday")) {
        daysData[drugName] = daysData[drugName]! + [2];
      }
      if (element.child("Days").hasChild("Wednesday")) {
        daysData[drugName] = daysData[drugName]! + [3];
      }
      if (element.child("Days").hasChild("Thursday")) {
        daysData[drugName] = daysData[drugName]! + [4];
      }
      if (element.child("Days").hasChild("Friday")) {
        daysData[drugName] = daysData[drugName]! + [5];
      }
      if (element.child("Days").hasChild("Saturday")) {
        daysData[drugName] = daysData[drugName]! + [6];
      }

      dosesTimeData[drugName] = [];
      if (element.child("Doses Times").hasChild("5")) {
        for (int i = 1; i <= 5; ++i) {
          dosesTimeData[drugName] = dosesTimeData[drugName]! +
              [element.child("Doses Times").child("$i").child("Hour").value] +
              [element.child("Doses Times").child("$i").child("Minute").value] +
              [
                element
                    .child("Doses Times")
                    .child("$i")
                    .child("Number of pills")
                    .value
              ] +
              [element.child("Doses Times").child("$i").child("period").value] +
              [element.child("Doses Times").child("$i").child("State").value];
        }
      } else if (element.child("Doses Times").hasChild("4")) {
        for (int i = 1; i <= 4; ++i) {
          dosesTimeData[drugName] = dosesTimeData[drugName]! +
              [element.child("Doses Times").child("$i").child("Hour").value] +
              [element.child("Doses Times").child("$i").child("Minute").value] +
              [
                element
                    .child("Doses Times")
                    .child("$i")
                    .child("Number of pills")
                    .value
              ] +
              [element.child("Doses Times").child("$i").child("period").value] +
              [element.child("Doses Times").child("$i").child("State").value];
        }
      } else if (element.child("Doses Times").hasChild("3")) {
        for (int i = 1; i <= 3; ++i) {
          dosesTimeData[drugName] = dosesTimeData[drugName]! +
              [element.child("Doses Times").child("$i").child("Hour").value] +
              [element.child("Doses Times").child("$i").child("Minute").value] +
              [
                element
                    .child("Doses Times")
                    .child("$i")
                    .child("Number of pills")
                    .value
              ] +
              [element.child("Doses Times").child("$i").child("period").value] +
              [element.child("Doses Times").child("$i").child("State").value];
        }
      } else if (element.child("Doses Times").hasChild("2")) {
        for (int i = 1; i <= 2; ++i) {
          dosesTimeData[drugName] = dosesTimeData[drugName]! +
              [element.child("Doses Times").child("$i").child("Hour").value] +
              [element.child("Doses Times").child("$i").child("Minute").value] +
              [
                element
                    .child("Doses Times")
                    .child("$i")
                    .child("Number of pills")
                    .value
              ] +
              [element.child("Doses Times").child("$i").child("period").value] +
              [element.child("Doses Times").child("$i").child("State").value];
        }
      } else {
        dosesTimeData[drugName] = dosesTimeData[drugName]! +
            [element.child("Doses Times").child("1").child("Hour").value] +
            [element.child("Doses Times").child("1").child("Minute").value] +
            [
              element
                  .child("Doses Times")
                  .child("1")
                  .child("Number of pills")
                  .value
            ] +
            [element.child("Doses Times").child("1").child("period").value] +
            [element.child("Doses Times").child("1").child("State").value];
      }
    });
    daysData.forEach((key1, value) {
      if (dosesTimeData[key1] != null &&
          DateTime.now().hour == 0 &&
          DateTime.now().minute == 0 &&
          DateTime.now().second == 0)
        for (int i = 1; i <= (dosesTimeData[key1]!.length / 5); i++) {
          _dbref
              .child("Drugs")
              .child("$key1")
              .child("Doses Times")
              .child("$i")
              .child("State")
              .set('Not displayed');
          id = 0;
        }
      if (value.contains(DateTime.now().weekday)) {
        dosesTimeData.forEach((key2, value) {
          int count = 1;
          int hour = 0;
          int min = 0;
          int doseNumber = 1;
          if (key1 == key2)
            for (var i in value) {
              late String now = DateTime.now().hour.toString();
              if (DateTime.now().hour > 12) {
                now = DateTime.now().hour.toString() +
                    ':' +
                    DateTime.now().minute.toString() +
                    ' PM';
              } else {
                now = DateTime.now().hour.toString() +
                    ':' +
                    DateTime.now().minute.toString() +
                    ' AM';
              }
              if (count == 1) {
                doseTime += '$i:';
                hour = i;
              } else if (count == 2) {
                min = i;
                doseTime += '$i';
                doseTime += ' ';
              } else if (count == 3) {
                numOfPills = i;
              } else if (count == 4) {
                doseTime += i.toString();
              } else if (count == 5) {
                DateTime timeAgo = DateTime.utc(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day, hour - 3, min);
                if (doseTime == now) {
                  if (i == 'Not displayed') {
                    review.children.insert(
                        review.children.length,
                        dailyReview(
                          drugName: key1,
                          doseTime: doseTime,
                          state: 'Did you already take $numOfPills pill?',
                          checkVis: true,
                          timeAgo: timeAgo,
                          doseNumber: doseNumber,
                        ));

                    _dbref
                        .child("Drugs")
                        .child("$key1")
                        .child("Doses Times")
                        .child("$doseNumber")
                        .child("State")
                        .set('Displayed');
                  } else if (i == 'Displayed') {
                    review.children.insert(
                        review.children.length,
                        dailyReview(
                          drugName: key1,
                          doseTime: doseTime,
                          state: 'Did you already take a $numOfPills pill?',
                          checkVis: true,
                          timeAgo: timeAgo,
                          doseNumber: doseNumber,
                        ));
                  } else if (i == 'Completed') {
                    review.children.insert(
                        review.children.length,
                        dailyReview(
                          drugName: key1,
                          doseTime: doseTime,
                          state: 'Completed',
                          checkVis: false,
                          timeAgo: timeAgo,
                          doseNumber: doseNumber,
                        ));
                  } else if (i == 'Skipped') {
                    review.children.insert(
                        review.children.length,
                        dailyReview(
                          drugName: key1,
                          doseTime: doseTime,
                          state: 'Skipped',
                          checkVis: false,
                          timeAgo: timeAgo,
                          doseNumber: doseNumber,
                        ));
                  }
                } else if (i == 'Displayed') {
                  review.children.insert(
                      review.children.length,
                      dailyReview(
                        drugName: key1,
                        doseTime: doseTime,
                        state: 'Did you already take a $numOfPills pill?',
                        checkVis: true,
                        timeAgo: timeAgo,
                        doseNumber: doseNumber,
                      ));
                } else if (i == 'Completed') {
                  review.children.insert(
                      review.children.length,
                      dailyReview(
                        drugName: key1,
                        doseTime: doseTime,
                        state: 'Completed',
                        checkVis: false,
                        timeAgo: timeAgo,
                        doseNumber: doseNumber,
                      ));
                } else if (i == 'Skipped') {
                  review.children.insert(
                      review.children.length,
                      dailyReview(
                        drugName: key1,
                        doseTime: doseTime,
                        state: 'Skipped',
                        checkVis: false,
                        timeAgo: timeAgo,
                        doseNumber: doseNumber,
                      ));
                }

                doseTime = '';
                count = 0;
                doseNumber++;
              }
              ++count;
            }
        });
      }
    });
    late Column tst;
    if (review.children.isNotEmpty)
      tst = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: review.children.reversed.toList(),
      );
    else
      tst = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text('No doses for today'),
          )
        ],
      );
    yield tst;
  }
}

Future<void> getBackgroundServices() async {
  late Iterable<DataSnapshot> data;
  late String drugName;
  String doseTime = '';
  late int numOfPills;
  blutoothServiceState service = blutoothServiceState();
  await _dbref
      .child("Drugs")
      .once()
      .then((event) => data = event.snapshot.children);
  data.forEach((element) {
    drugName = element.child("Name").value.toString();
    daysData[drugName] = [];
    int sum = 0;
    if (element.child("Days").hasChild("Sunday")) {
      daysData[drugName] = daysData[drugName]! + [7];
    }
    if (element.child("Days").hasChild("Monday")) {
      daysData[drugName] = daysData[drugName]! + [1];
    }
    if (element.child("Days").hasChild("Tuesday")) {
      daysData[drugName] = daysData[drugName]! + [2];
    }
    if (element.child("Days").hasChild("Wednesday")) {
      daysData[drugName] = daysData[drugName]! + [3];
    }
    if (element.child("Days").hasChild("Thursday")) {
      daysData[drugName] = daysData[drugName]! + [4];
    }
    if (element.child("Days").hasChild("Friday")) {
      daysData[drugName] = daysData[drugName]! + [5];
    }
    if (element.child("Days").hasChild("Saturday")) {
      daysData[drugName] = daysData[drugName]! + [6];
    }

    dosesTimeData[drugName] = [];
    if (element.child("Doses Times").hasChild("5")) {
      for (int i = 1; i <= 5; ++i) {
        dosesTimeData[drugName] = dosesTimeData[drugName]! +
            [element.child("Doses Times").child("$i").child("Hour").value] +
            [element.child("Doses Times").child("$i").child("Minute").value] +
            [
              element
                  .child("Doses Times")
                  .child("$i")
                  .child("Number of pills")
                  .value
            ] +
            [element.child("Doses Times").child("$i").child("period").value] +
            [element.child("Doses Times").child("$i").child("State").value];
      }
    } else if (element.child("Doses Times").hasChild("4")) {
      for (int i = 1; i <= 4; ++i) {
        dosesTimeData[drugName] = dosesTimeData[drugName]! +
            [element.child("Doses Times").child("$i").child("Hour").value] +
            [element.child("Doses Times").child("$i").child("Minute").value] +
            [
              element
                  .child("Doses Times")
                  .child("$i")
                  .child("Number of pills")
                  .value
            ] +
            [element.child("Doses Times").child("$i").child("period").value] +
            [element.child("Doses Times").child("$i").child("State").value];
      }
    } else if (element.child("Doses Times").hasChild("3")) {
      for (int i = 1; i <= 3; ++i) {
        dosesTimeData[drugName] = dosesTimeData[drugName]! +
            [element.child("Doses Times").child("$i").child("Hour").value] +
            [element.child("Doses Times").child("$i").child("Minute").value] +
            [
              element
                  .child("Doses Times")
                  .child("$i")
                  .child("Number of pills")
                  .value
            ] +
            [element.child("Doses Times").child("$i").child("period").value] +
            [element.child("Doses Times").child("$i").child("State").value];
      }
    } else if (element.child("Doses Times").hasChild("2")) {
      for (int i = 1; i <= 2; ++i) {
        dosesTimeData[drugName] = dosesTimeData[drugName]! +
            [element.child("Doses Times").child("$i").child("Hour").value] +
            [element.child("Doses Times").child("$i").child("Minute").value] +
            [
              element
                  .child("Doses Times")
                  .child("$i")
                  .child("Number of pills")
                  .value
            ] +
            [element.child("Doses Times").child("$i").child("period").value] +
            [element.child("Doses Times").child("$i").child("State").value];
      }
    } else {
      dosesTimeData[drugName] = dosesTimeData[drugName]! +
          [element.child("Doses Times").child("1").child("Hour").value] +
          [element.child("Doses Times").child("1").child("Minute").value] +
          [
            element
                .child("Doses Times")
                .child("1")
                .child("Number of pills")
                .value
          ] +
          [element.child("Doses Times").child("1").child("period").value] +
          [element.child("Doses Times").child("1").child("State").value];
    }
  });
  daysData.forEach((key1, value) {
    if (dosesTimeData[key1] != null &&
        DateTime.now().hour == 0 &&
        DateTime.now().minute == 0 &&
        DateTime.now().second == 0)
      for (int i = 1; i <= (dosesTimeData[key1]!.length / 5); i++) {
        _dbref
            .child("Drugs")
            .child("$key1")
            .child("Doses Times")
            .child("$i")
            .child("State")
            .set('Not displayed');
        id = 0;
      }
    if (value.contains(DateTime.now().weekday)) {
      dosesTimeData.forEach((key2, value) {
        int count = 1;
        int hour = 0;
        int min = 0;
        int doseNumber = 1;
        if (key1 == key2)
          for (var i in value) {
            late String now = DateTime.now().hour.toString();
            if (DateTime.now().hour > 12) {
              now = DateTime.now().hour.toString() +
                  ':' +
                  DateTime.now().minute.toString() +
                  ' PM';
            } else {
              now = DateTime.now().hour.toString() +
                  ':' +
                  DateTime.now().minute.toString() +
                  ' AM';
            }
            if (count == 1) {
              doseTime += '$i:';
              hour = i;
            } else if (count == 2) {
              min = i;
              doseTime += '$i';
              doseTime += ' ';
            } else if (count == 3) {
              numOfPills = i;
            } else if (count == 4) {
              doseTime += i.toString();
            } else if (count == 5) {
              DateTime timeAgo = DateTime.utc(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day, hour - 3, min);
              if (doseTime == now) {
                if (i == 'Not displayed') {
                  //service.sendTimeWithNumberOfPills();
                  print('seiii');
                  _dbref
                      .child("Drugs")
                      .child("$key1")
                      .child("Doses Times")
                      .child("$doseNumber")
                      .child("State")
                      .set('Displayed');
                  print(hour);
                  print(min);
                  print(id);
                  createNotificationWithButtons(
                      id: id,
                      title: key1,
                      body: 'Hey there, it\'s time to take $numOfPills pills');
                  ++id;
                }
              }
              doseTime = '';
              count = 0;
              doseNumber++;
            }
            ++count;
          }
      });
    }
  });
}

class dailyReview extends StatefulWidget {
  String drugName;
  String doseTime;
  String state;
  bool checkVis;
  DateTime timeAgo;
  int doseNumber;
  dailyReview(
      {required this.drugName,
      required this.doseTime,
      required this.state,
      required this.checkVis,
      required this.timeAgo,
      required this.doseNumber});
  @override
  State<dailyReview> createState() => _dailyReviewState();
}

class _dailyReviewState extends State<dailyReview> {
  final Text s = const Text(
    'For your health, don\'t miss your dose ',
    style: TextStyle(
        fontSize: 13.0, color: Color(0xFF9B9B9B), fontWeight: FontWeight.bold),
  );
  final Text c = const Text(
    'Good job, keep doing that ',
    style: TextStyle(
        fontSize: 13.0, color: Color(0xFF9B9B9B), fontWeight: FontWeight.bold),
  );
  final Text stateC = const Text(
    'Completed',
    style: TextStyle(
        fontSize: 13.0, color: Color(0xFF44CBB1), fontWeight: FontWeight.bold),
  );
  final Text stateS = const Text(
    'Skipped',
    style: TextStyle(
        fontSize: 13.0, color: Colors.red, fontWeight: FontWeight.bold),
  );
  @override
  Widget build(BuildContext context) {
    Text state() {
      if (widget.state == stateC.data)
        return c;
      else if (widget.state == stateS.data)
        return s;
      else {
        final Text stateQ = Text(
          widget.state,
          style: TextStyle(
              fontSize: 13.0,
              color: Color(0xFF9B9B9B),
              fontWeight: FontWeight.bold),
        );
        return stateQ;
      }
    }

    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      height: 70.0,
      decoration: const BoxDecoration(
        color: Color(0xFFEEEEEE),
        borderRadius: BorderRadius.all(
          Radius.circular(24.0),
        ),
      ),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Container(
              margin: EdgeInsets.symmetric(horizontal: 7),
              child: Image.asset('images/pill.png')),
          Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                widget.drugName,
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                widget.doseTime,
                style: TextStyle(fontSize: 13.0, color: Color(0xFF9B9B9B)),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 5, right: 5),
            child: Text(
              '.',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF9B9B9B)),
            ),
          ),
          Flexible(
            child: Container(
              margin: EdgeInsets.only(top: 5),
              child: state(),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 5, right: 5),
            child: Text(
              '.',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF9B9B9B)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: widget.state.contains('Did')
                ? null
                : widget.state == stateC.data
                    ? stateC
                    : stateS,
          ),
          Container(
            margin: EdgeInsets.only(right: 5),
            child: Visibility(
                visible: widget.checkVis,
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          widget.checkVis = false;
                          _dbref
                              .child("Drugs")
                              .child("${widget.drugName}")
                              .child("Doses Times")
                              .child("${widget.doseNumber}")
                              .child("State")
                              .set('Completed');
                        });
                      },
                      child: Icon(
                        Icons.check,
                        color: Color(0xFF44CBB1),
                      ),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          widget.checkVis = false;
                          _dbref
                              .child("Drugs")
                              .child("${widget.drugName}")
                              .child("Doses Times")
                              .child("${widget.doseNumber}")
                              .child("State")
                              .set('Skipped');
                        });
                      },
                      child: Icon(
                        Icons.clear,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                )),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, right: 5),
            child: Text(
              timeago.format(widget.timeAgo, locale: 'en_short'),
              style: TextStyle(fontSize: 12.0, color: Color(0xFF9B9B9B)),
            ),
          ),
        ],
      ),
    );
  }
}

int count = 0;
List<String> advices = [
  'Alcohol addiction leads to damage to brain cells and frequent strokes',
  'Excessive coffee consumption is harmful to heart patients.',
];
void getDailyAdvice() {
  createScheduleNotification(
      id: count, title: 'Good afternoon', body: advices[count]);
  count++;
  if (count == 2) count = 0;
}
