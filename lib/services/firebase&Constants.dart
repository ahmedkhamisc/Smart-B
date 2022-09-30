import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_b/addDrug_page.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:smart_b/services/local_notification_service.dart';

DatabaseReference _dbref = FirebaseDatabase.instance.ref();
Map<String, List<int>> daysData = {};
Map<String, List> dosesTimeData = {};
Map<String, int> pillsLeft = {};
int id = 0;
int countP = 0;
Map<String, int> dosesPerDayData = {};
Map<String, int> bottlesNumbers = {};
int _drugsChecked = 0;
List<int> pillsNums = [0, 0, 0, 0];
List<int> pillsNumsConfirmed = [];
Map<String, List<int>> pillsConfirmed = {};
bool fillOnceInDay = true;
int count = 0;
int countd = 0;
bool isAlert = false;
Map<String, int> medsCheckTypes = {};
List<String> advices = [
  'Alcohol addiction leads to damage to brain cells and frequent strokes',
  'Excessive coffee consumption is harmful to heart patients.',
];
Stream<Widget> getMedicineData({required Size size, String? user}) async* {
  while (true) {
    await Future<void>.delayed(const Duration(seconds: 1));
    late Iterable<DataSnapshot> drugsData;
    late Iterable<DataSnapshot> drugsRecData;
    late Iterable<DataSnapshot> foodRecData;
    late String drugName;
    String dosesTime = '';
    late String bottleNumber;
    late String numberOfPills;
    String days = '';
    late String dosesPerDay;
    String drugType = 'drug';
    String requiredAge = 'No data';
    String recommendedDoses = 'No data';
    String description = 'No data';
    Map<String, List<String>> drugsRecInf = {};
    Column cards = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [],
    );

    await _dbref
        .child("Drugs")
        .once()
        .then((event) => drugsData = event.snapshot.children);

    await _dbref
        .child("Drugs_Recommended_Information")
        .once()
        .then((event) => drugsRecData = event.snapshot.children);

    await _dbref
        .child("Food_Supplements_Recommended_Information")
        .once()
        .then((event) => foodRecData = event.snapshot.children);
    drugsData.forEach((element) {
      dosesPerDay = element.child("Doses per day").value.toString();
      bottleNumber = element.child("Medicine bottle number").value.toString();
      drugName = element.child("Name").value.toString();
      numberOfPills = element.child("Number of pills").value.toString();
      medsCheckTypes[drugName] =
          int.parse(element.child("Check Type").value.toString());
      daysData[drugName] = [];
      drugsRecInf[drugName] = [
        drugType,
        description,
        recommendedDoses,
        requiredAge
      ];
      int sum = 0;

      drugsRecData.forEach((element) {
        drugType = 'drug';
        String drugRecName = element.child("Name").value.toString();
        if (drugName == drugRecName) {
          requiredAge = element.child("Drug_Age_Limit").value.toString();
          recommendedDoses =
              element.child("Recommended_Drug_Dos").value.toString();
          description = element.child("Drug_Description").value.toString();

          drugsRecInf[drugName] = [
            drugType,
            description,
            recommendedDoses,
            requiredAge
          ];
          drugType = 'drug';
          requiredAge = 'No data';
          recommendedDoses = 'No data';
          description = 'No data';
        }
      });
      foodRecData.forEach((element) {
        String drugRecName = element.child("Name").value.toString();
        if (drugName == drugRecName) {
          drugType = 'food';
          requiredAge = element.child("Supp_Age_Limit").value.toString();
          recommendedDoses =
              element.child("Recommended_Supp_Dos").value.toString();
          description = element.child("Supp_Description").value.toString();

          drugsRecInf[drugName] = [
            drugType,
            description,
            recommendedDoses,
            requiredAge
          ];
          drugType = 'drug';
          requiredAge = 'No data';
          recommendedDoses = 'No data';
          description = 'No data';
        }
      });
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
            drugType: drugsRecInf[drugName]!.elementAt(0),
            description: drugsRecInf[drugName]!.elementAt(1),
            recommendedDoses: drugsRecInf[drugName]!.elementAt(2),
            requiredAge: drugsRecInf[drugName]!.elementAt(3),
            size: size,
            drugName: drugName,
            dosesTime: dosesTime,
            bottleNumber: bottleNumber,
            days: days,
            numberOfPills: numberOfPills,
            checkType: medsCheckTypes[drugName] == 1 ? 'App' : 'App and box',
            isRelated: user == 'related' ? true : false,
          ));
      days = '';
      dosesTime = '';
    });

    yield cards;
  }
}

Stream<Widget> getDailyRevData({String? user}) async* {
  while (true) {
    await Future<void>.delayed(const Duration(seconds: 1));
    late Iterable<DataSnapshot> data;
    late String drugName;
    String doseTime = '';
    late int numOfPills;
    late String state;
    Column review = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [],
    );
    //blutoothServiceState service = blutoothServiceState();
    await _dbref
        .child("Drugs")
        .once()
        .then((event) => data = event.snapshot.children);
    await _dbref
        .child("Smart-b1")
        .child("State")
        .once()
        .then((event) => state = event.snapshot.value.toString());
    data.forEach((element) {
      drugName = element.child("Name").value.toString();
      daysData[drugName] = [];
      medsCheckTypes[drugName] =
          int.parse(element.child("Check Type").value.toString());
      dosesPerDayData[drugName] =
          int.parse(element.child("Doses per day").value.toString());
      if (int.parse(element.child("Medicine bottle number").value.toString()) !=
          0) {
        bottlesNumbers[drugName] =
            int.parse(element.child("Medicine bottle number").value.toString());
      }
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
          DateTime.now().second == 0) {
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
      }

      if (value.contains(DateTime.now().weekday)) {
        dosesTimeData.forEach((key2, value) {
          int count = 1;
          int hour = 0;
          int min = 0;
          int doseNumber = 1;
          //bottleNumber=
          if (key1 == key2)
            for (var i in value) {
              late String now = DateTime.now().hour.toString();
              if (DateTime.now().hour >= 12) {
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
                    // bottleNumber.forEach((key, value) {
                    //   if (key == key1) {
                    //     pillsNums[value - 1] = numOfPills;
                    //   }
                    //   _dbref
                    //       .child("Drugs")
                    //       .child("$key1")
                    //       .child("Doses Times")
                    //       .child("$doseNumber")
                    //       .child("State")
                    //       .set('Displayed');
                    // });
                  } else if (i == 'alerted' && user == null) {
                    if (medsCheckTypes[key1] == 1) {
                      review.children.insert(
                          review.children.length,
                          dailyReview(
                            id: id,
                            dosesPerDay: dosesPerDayData[key1]!,
                            drugName: key1,
                            doseTime: doseTime,
                            state:
                                'Hey there! it\'s time to take $numOfPills pills',
                            checkVis: true,
                            timeAgo: timeAgo,
                            doseNumber: doseNumber,
                          ));
                    }
                  } else if (i == 'Completed') {
                    review.children.insert(
                        review.children.length,
                        dailyReview(
                          id: id,
                          dosesPerDay: dosesPerDayData[key1]!,
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
                          id: id,
                          dosesPerDay: dosesPerDayData[key1]!,
                          drugName: key1,
                          doseTime: doseTime,
                          state: 'Skipped',
                          checkVis: false,
                          timeAgo: timeAgo,
                          doseNumber: doseNumber,
                        ));
                  }
                } else if (i == 'alerted' && user == null) {
                  if (medsCheckTypes[key1] == 1) {
                    review.children.insert(
                        review.children.length,
                        dailyReview(
                          id: id,
                          dosesPerDay: dosesPerDayData[key1]!,
                          drugName: key1,
                          doseTime: doseTime,
                          state:
                              'Hey there! it\'s time to take $numOfPills pills',
                          checkVis: true,
                          timeAgo: timeAgo,
                          doseNumber: doseNumber,
                        ));
                  }
                } else if (i == 'Completed') {
                  review.children.insert(
                      review.children.length,
                      dailyReview(
                        id: id,
                        dosesPerDay: dosesPerDayData[key1]!,
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
                        id: id,
                        dosesPerDay: dosesPerDayData[key1]!,
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
    if (review.children.isNotEmpty) {
      tst = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: review.children.reversed.toList(),
      );
    } else {
      tst = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text('No doses for today'),
          )
        ],
      );
    }
    yield tst;
  }
}

Future<void> getBackgroundServices() async {
  String user = await _dbref
      .child("Users")
      .child("current")
      .once()
      .then((value) => value.snapshot.value.toString());
  print(user);
  late Iterable<DataSnapshot> data;
  late String drugName;
  String doseTime = '';
  late String numberOfPillsPublic;
  late int numberOfPillsDoses;
  late String state;
  await _dbref
      .child("Drugs")
      .once()
      .then((event) => data = event.snapshot.children);
  await _dbref
      .child("Smart-b1")
      .child("State")
      .once()
      .then((event) => state = event.snapshot.value.toString());
  data.forEach((element) {
    drugName = element.child("Name").value.toString();
    numberOfPillsPublic = element.child("Number of pills").value.toString();
    pillsConfirmed[drugName] = [int.parse(numberOfPillsPublic)];
    medsCheckTypes[drugName] =
        int.parse(element.child("Check Type").value.toString());
    daysData[drugName] = [];
    if (int.parse(element.child("Medicine bottle number").value.toString()) !=
        0) {
      bottlesNumbers[drugName] =
          int.parse(element.child("Medicine bottle number").value.toString());
    }
    if (fillOnceInDay) pillsLeft[drugName] = 0;
    if (pillsLeft.isNotEmpty &&
        int.parse(numberOfPillsPublic) <= 5 &&
        pillsLeft[drugName] == 0 &&
        user != 'no one') {
      ++id;
      pillsLeft[drugName] = 1;
      if (int.parse(numberOfPillsPublic) != 0) {
        createBasicNotification(
            id: id,
            title: drugName,
            body: 'Only ${numberOfPillsPublic} pills left, fill it please');
      } else {
        createBasicNotification(
            id: id,
            title: drugName,
            body: 'There is no pills anymore, fill it please');
      }
    }
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
  fillOnceInDay = false;
  daysData.forEach((key1, value) {
    if (dosesTimeData[key1] != null &&
        DateTime.now().hour == 0 &&
        DateTime.now().minute == 0 &&
        DateTime.now().second == 0) {
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
      fillOnceInDay = true;
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
            if (DateTime.now().hour >= 12) {
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
              numberOfPillsDoses = i;
            } else if (count == 4) {
              doseTime += i.toString();
            } else if (count == 5) {
              DateTime timeAgo = DateTime.utc(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day, hour - 3, min);
              if (doseTime == now && user == 'person') {
                if (i == 'Not displayed') {
                  print('seiii');
                  _dbref
                      .child("Drugs")
                      .child("$key1")
                      .child("Doses Times")
                      .child("$doseNumber")
                      .child("State")
                      .set('Displayed');
                  bottlesNumbers.forEach((key, value) {
                    if (key == key1) {
                      pillsNums[value - 1] = numberOfPillsDoses;
                    }
                  });
                } else if (i == 'Displayed') {
                  if (medsCheckTypes[key1] == 1) {
                    createNotificationWithButtons(
                        id: id,
                        title: key1,
                        body:
                            'Hey there! it\'s time to take $numberOfPillsDoses pills',
                        doseNum: doseNumber);
                    _dbref
                        .child("Drugs")
                        .child("$key1")
                        .child("Doses Times")
                        .child("$doseNumber")
                        .child("State")
                        .set('alerted');
                    id++;
                  } else {
                    if (state == 'alert') {
                      isAlert = true;
                      createNotificationWithButtons(
                          id: id,
                          title: key1,
                          body:
                              'Hey there, it\'s time to take $numberOfPillsDoses pills',
                          doseNum: doseNumber);
                      id++;
                      ++countd;
                    } else if (state == 'confirmed' &&
                        _drugsChecked > 0 &&
                        !isAlert) {
                      confirmed(
                          name: key1, doseNum: doseNumber, state: 'Completed');

                      --_drugsChecked;
                      _drugsChecked == 0
                          ? {
                              setLifeCycleState(state: 'time off'),
                            }
                          : {};
                    }
                    if (countd == _drugsChecked &&
                        state != 'confirmed' &&
                        state != 'alerted' &&
                        _drugsChecked > 0) {
                      print('fff $_drugsChecked');
                      _dbref.child("Smart-b1").child("State").set('alerted');
                      countd = 0;
                    }
                  }
                }
              } else if (i == 'Displayed' && user == 'person') {
                if (medsCheckTypes[key1] == 1) {
                  createNotificationWithButtons(
                      id: id,
                      title: key1,
                      body:
                          'Hey there! it\'s time to take $numberOfPillsDoses pills',
                      doseNum: doseNumber);
                  id++;
                } else {
                  if (state == 'alert') {
                    isAlert = true;
                    createNotificationWithButtons(
                        id: id,
                        title: key1,
                        body:
                            'Hey there, it\'s time to take $numberOfPillsDoses pills',
                        doseNum: doseNumber);
                    ++id;
                    countd++;
                  } else if (state == 'confirmed' &&
                      _drugsChecked > 0 &&
                      !isAlert) {
                    confirmed(
                        name: key1, doseNum: doseNumber, state: 'Completed');
                    --_drugsChecked;
                    _drugsChecked == 0
                        ? {
                            setLifeCycleState(state: 'time off'),
                          }
                        : {};
                  }
                  if (countd == _drugsChecked &&
                      state != 'confirmed' &&
                      state != 'alerted' &&
                      _drugsChecked > 0) {
                    print(countd);
                    _dbref.child("Smart-b1").child("State").set('alerted');
                    countd = 0;
                  }
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
  if (pillsNums.contains(1) || pillsNums.contains(2) || pillsNums.contains(3)) {
    _drugsChecked = 0;
    for (var element in pillsNums) {
      element != 0 ? _drugsChecked++ : {};
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("drugsChecked", _drugsChecked);
    timeAll(pillsNums: pillsNums);
    // pillsNumsConfirmed = pillsNums;
    pillsNums = [0, 0, 0, 0];
  }
  if (state == 'confirmed') {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("drugsChecked", 0);
    _drugsChecked = 0;
  } else if (state == 'time off') {
    isAlert = false;
    _drugsChecked = 0;
    countd = 0;
  }
}

void getDailyAdvice() {
  createScheduleNotification(
      id: count, title: 'Good afternoon', body: advices[count]);
  count++;
  if (count == 2) count = 0;
}

Future<void> confirmed(
    {required String name, required int doseNum, required String state}) async {
  String numOfPillsD = await _dbref
      .child("Drugs")
      .child("$name")
      .child("Doses Times")
      .child("$doseNum")
      .child("Number of pills")
      .once()
      .then((value) => value.snapshot.value.toString());
  String numOfPillsP = await _dbref
      .child("Drugs")
      .child("$name")
      .child("Number of pills")
      .once()
      .then((value) => value.snapshot.value.toString());
  state == 'Completed'
      ? {
          _dbref
              .child("Drugs")
              .child("$name")
              .child("Doses Times")
              .child("$doseNum")
              .child("State")
              .set('Completed'),
          _dbref
              .child("Drugs")
              .child("$name")
              .child("Number of pills")
              .set(int.parse(numOfPillsP) - int.parse(numOfPillsD)),
        }
      : {
          _dbref
              .child("Drugs")
              .child("$name")
              .child("Doses Times")
              .child("$doseNum")
              .child("State")
              .set('Skipped'),
        };
}

Future<void> timeAll({required List<int> pillsNums}) async {
  print(pillsNums);
  _dbref.child("Smart-b1").child("Bottle1").set('dis${pillsNums[0]}');
  _dbref.child("Smart-b1").child("Bottle2").set('dis${pillsNums[1]}');
  _dbref.child("Smart-b1").child("Bottle3").set('dis${pillsNums[2]}');
  _dbref.child("Smart-b1").child("Bottle4").set('dis${pillsNums[3]}');
  _dbref.child("Smart-b1").child("State").set('TimeAll');
}

Future<void> setLifeCycleState({required String state}) async {
  _dbref.child("Smart-b1").child("State").set(state);

  state == 'time off'
      ? {
          _dbref.child("Smart-b1").child("Bottle1").set('dis'),
          _dbref.child("Smart-b1").child("Bottle2").set('dis'),
          _dbref.child("Smart-b1").child("Bottle3").set('dis'),
          _dbref.child("Smart-b1").child("Bottle4").set('dis'),
        }
      : {};
}

//classes
class dailyReview extends StatefulWidget {
  String drugName;
  String doseTime;
  String state;
  bool checkVis;
  DateTime timeAgo;
  int doseNumber;
  int dosesPerDay;
  int id;
  dailyReview(
      {required this.drugName,
      required this.doseTime,
      required this.state,
      required this.checkVis,
      required this.timeAgo,
      required this.doseNumber,
      required this.dosesPerDay,
      required this.id});
  @override
  State<dailyReview> createState() => _dailyReviewState();
}

class _dailyReviewState extends State<dailyReview> {
  //blutoothServiceState service = blutoothServiceState();
  final Text s = const Text(
    'For your health, don\'t miss your dose ',
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
    Text c;
    int dosesLeft = widget.dosesPerDay - widget.doseNumber;
    if (dosesLeft == 0) {
      c = Text(
        'Good job, all doses are done',
        style: TextStyle(
            fontSize: 13.0,
            color: Color(0xFF9B9B9B),
            fontWeight: FontWeight.bold),
      );
    } else {
      c = Text(
        'Good job, $dosesLeft doses left for today ',
        style: TextStyle(
            fontSize: 13.0,
            color: Color(0xFF9B9B9B),
            fontWeight: FontWeight.bold),
      );
    }

    Text state() {
      if (widget.state == stateC.data) {
        return c;
      } else if (widget.state == stateS.data) {
        return s;
      } else {
        final Text stateQ = Text(
          widget.state,
          style: const TextStyle(
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
            child: const Text(
              '.',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF9B9B9B)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: widget.state.contains('Hey there')
                ? null
                : widget.state == stateC.data
                    ? stateC
                    : stateS,
          ),
          Container(
            margin: const EdgeInsets.only(right: 5),
            child: Visibility(
                visible: widget.checkVis,
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          widget.checkVis = false;
                          AwesomeNotifications().cancel(widget.id);
                          confirmed(
                              name: widget.drugName,
                              doseNum: widget.doseNumber,
                              state: 'Completed');
                        });
                      },
                      child: const Icon(
                        Icons.check,
                        color: Color(0xFF44CBB1),
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          widget.checkVis = false;
                          AwesomeNotifications().cancel(widget.id);
                          confirmed(
                              name: widget.drugName,
                              doseNum: widget.doseNumber,
                              state: 'Skipped');
                        });
                      },
                      child: const Icon(
                        Icons.clear,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                )),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5, right: 5),
            child: Text(
              timeago.format(widget.timeAgo, locale: 'en_short'),
              style: const TextStyle(fontSize: 12.0, color: Color(0xFF9B9B9B)),
            ),
          ),
        ],
      ),
    );
  }
}

class Card extends StatelessWidget {
  Card(
      {required this.size,
      required this.drugName,
      required this.dosesTime,
      required this.bottleNumber,
      required this.numberOfPills,
      required this.days,
      required this.requiredAge,
      required this.recommendedDoses,
      required this.description,
      required this.drugType,
      required this.checkType,
      required this.isRelated});
  final Size size;
  String drugName;
  String dosesTime;
  String bottleNumber;
  String numberOfPills;
  String days;
  String requiredAge;
  String recommendedDoses;
  String description;
  String drugType;
  String checkType;
  bool isRelated;
  @override
  Widget build(BuildContext context) {
    return !isRelated
        ? InkWell(
            onTap: () {
              print('Edit');
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => addDrugPage(
                          name: drugName,
                        )),
              );
            },
            child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05, vertical: 10),
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
                              Image.asset(drugType == 'drug'
                                  ? "images/pills-bottle.png"
                                  : "images/herbal.png"),
                              const SizedBox(
                                width: 5,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    drugName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    description,
                                    style: const TextStyle(
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
                              Text(
                                'Time per doses : $dosesTime',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
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
                                'Remind you through : $checkType',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                              ),
                              Visibility(
                                visible: checkType == 'App' ? false : true,
                                child: Text(
                                  'Bottle Number : $bottleNumber',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Text(
                                'Number of pills : $numberOfPills',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Days : $days',
                                style: const TextStyle(
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
                                'Recommended : $recommendedDoses',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.black45,
                                ),
                              ),
                              Text(
                                'Required age : $requiredAge',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.black45,
                                ),
                              ),
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
                                if (drugName != '') {
                                  bottlesNumbers.removeWhere(
                                      (key, value) => key == drugName);
                                  _dbref
                                      .child("Drugs")
                                      .child("$drugName")
                                      .remove();
                                }
                              },
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.red,
                                size: 50,
                              )),
                        ))
                  ],
                )),
          )
        : Container(
            margin: EdgeInsets.symmetric(
                horizontal: size.width * 0.05, vertical: 10),
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
                          Image.asset(drugType == 'drug'
                              ? "images/pills-bottle.png"
                              : "images/herbal.png"),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                drugName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                description,
                                style: const TextStyle(
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
                          Text(
                            'Time per doses : $dosesTime',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
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
                            'Remind you through : $checkType',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                          Visibility(
                            visible: checkType == 'App' ? false : true,
                            child: Text(
                              'Bottle Number : $bottleNumber',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Text(
                            'Number of pills : $numberOfPills',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Days : $days',
                            style: const TextStyle(
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
                            'Recommended : $recommendedDoses',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.black45,
                            ),
                          ),
                          Text(
                            'Required age : $requiredAge',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }
}

Map<String, String> globalState = {};
