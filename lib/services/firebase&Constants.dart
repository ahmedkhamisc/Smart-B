import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_b/addDrug_page.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:smart_b/services/local_notification_service.dart';

DatabaseReference _dbref = FirebaseDatabase.instance.ref();
Map<String, List<int>> daysData = {};
Map<String, List> dosesTimeData = {};
int id = 0;
int countP = 0;
Map<String, int> dosesPerDayData = {};
Map<String, int> bottlesNumbers = {};
List<int> pillsNums = [0, 0, 0, 0];
List<int> pillsNumsConfirmed = [];
Map<String, List<int>> pillsConfirmed = {};
int count = 0;
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
    String drugType = 'drug';
    String requiredAge = 'No data';
    String recommendedDoses = 'No data';
    String description = 'No data';
    Map<String, int> numberOfPillsPublic = {};
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
      bottleNumber = element.child("Medicine bottle number").value.toString();
      drugName = element.child("Name").value.toString();
      numberOfPills = element.child("Number of pills").value.toString();
      medsCheckTypes[drugName] =
          int.parse(element.child("Check Type").value.toString());
      numberOfPillsPublic[drugName] = int.parse(numberOfPills);
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
      if (sum == 7) days = 'Daily  ';
      if (element.hasChild("Weeks")) {
        String weeks = element.child("Weeks").value.toString();
        days = days.substring(0, days.length - 2);
        days += ' / Week ';
        if (weeks.contains('1')) {
          days += '1, ';
        }
        if (weeks.contains('2')) {
          days += '2, ';
        }
        if (weeks.contains('3')) {
          days += '3, ';
        }
        if (weeks.contains('4')) {
          days += '4, ';
        }
      } else if (days != 'Daily  ') {
        days = days.substring(0, days.length - 2);
        days += ' / Weekly  ';
      }
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
          dosesTime +=
              '${element.child("Doses Times").child("$i").child("Hour").value}:${element.child("Doses Times").child("$i").child("Minute").value}${element.child("Doses Times").child("$i").child("period").value} -';
          if (element.child("Number of pills").value.toString() != '-1') {
            dosesTime +=
                '${element.child("Doses Times").child("$i").child("Number of pills").value} Pills, ';
          }
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
          dosesTime +=
              '${element.child("Doses Times").child("$i").child("Hour").value}:${element.child("Doses Times").child("$i").child("Minute").value}${element.child("Doses Times").child("$i").child("period").value} -';
          if (element.child("Number of pills").value.toString() != '-1') {
            dosesTime +=
                '${element.child("Doses Times").child("$i").child("Number of pills").value} Pills, ';
          }
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
          dosesTime +=
              '${element.child("Doses Times").child("$i").child("Hour").value}:${element.child("Doses Times").child("$i").child("Minute").value}${element.child("Doses Times").child("$i").child("period").value} -';
          if (element.child("Number of pills").value.toString() != '-1') {
            dosesTime +=
                '${element.child("Doses Times").child("$i").child("Number of pills").value} Pills, ';
          }
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
          dosesTime +=
              '${element.child("Doses Times").child("$i").child("Hour").value}:${element.child("Doses Times").child("$i").child("Minute").value}${element.child("Doses Times").child("$i").child("period").value} -';
          if (element.child("Number of pills").value.toString() != '-1') {
            dosesTime +=
                '${element.child("Doses Times").child("$i").child("Number of pills").value} Pills, ';
          }
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

        dosesTime +=
            '${element.child("Doses Times").child("1").child("Hour").value}:${element.child("Doses Times").child("1").child("Minute").value}${element.child("Doses Times").child("1").child("period").value} -';
        if (element.child("Number of pills").value.toString() != '-1') {
          dosesTime +=
              '${element.child("Doses Times").child("1").child("Number of pills").value} Pills, ';
        }
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

Stream<Widget> getDailyRevData() async* {
  while (true) {
    await Future<void>.delayed(const Duration(seconds: 1));
    late Iterable<DataSnapshot> data;
    late String drugName;
    String doseTime = '';
    late int numOfPills;
    Map<String, int> numberOfPillsPublic = {};
    String userP = await _dbref
        .child("Users")
        .child("BOX1")
        .child("Person")
        .once()
        .then((value) => value.snapshot.value.toString());
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
      medsCheckTypes[drugName] =
          int.parse(element.child("Check Type").value.toString());
      dosesPerDayData[drugName] =
          int.parse(element.child("Doses per day").value.toString());
      numberOfPillsPublic[drugName] =
          int.parse(element.child("Number of pills").value.toString());
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
          DateTime.now().minute == 0) {
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
          if (key1 == key2) {
            for (var i in value) {
              late String now = DateTime.now().hour.toString();
              if (DateTime.now().hour >= 12) {
                now = '${DateTime.now().hour}:${DateTime.now().minute} PM';
              } else {
                now = '${DateTime.now().hour}:${DateTime.now().minute} AM';
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
                  } else if (i == 'alerted' && userP == 'person') {
                    numberOfPillsPublic[key1] != -1
                        ? {
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
                                )),
                          }
                        : {
                            review.children.insert(
                                review.children.length,
                                dailyReview(
                                  id: id,
                                  dosesPerDay: dosesPerDayData[key1]!,
                                  drugName: key1,
                                  doseTime: doseTime,
                                  state:
                                      'Hey there! it\'s time to take your dose',
                                  checkVis: true,
                                  timeAgo: timeAgo,
                                  doseNumber: doseNumber,
                                ))
                          };
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
                } else if (i == 'alerted' && userP == 'person') {
                  numberOfPillsPublic[key1] != -1
                      ? {
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
                              )),
                        }
                      : {
                          review.children.insert(
                              review.children.length,
                              dailyReview(
                                id: id,
                                dosesPerDay: dosesPerDayData[key1]!,
                                drugName: key1,
                                doseTime: doseTime,
                                state:
                                    'Hey there! it\'s time to take your dose',
                                checkVis: true,
                                timeAgo: timeAgo,
                                doseNumber: doseNumber,
                              ))
                        };
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
        children: const [
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
  String userP = await _dbref
      .child("Users")
      .child("BOX1")
      .child("Person")
      .once()
      .then((value) => value.snapshot.value.toString());

  String userR = await _dbref
      .child("Users")
      .child("BOX1")
      .child("Related")
      .once()
      .then((value) => value.snapshot.value.toString());
  print(userP);
  late Iterable<DataSnapshot> data;
  late String drugName;
  String doseTime = '';
  late String numberOfPillsPublicc;
  Map<String, int> numberOfPillsPublic = {};
  late int numberOfPillsDoses;
  late String state;
  Map<String, String> notifyFillBottle = {};
  Map<String, int> pillsPerDay = {};
  String weeks = '';
  Map<String, List<int>> weeksList = {};
  if (userR == 'related') {
    await _dbref
        .child("Users")
        .child("BOX1")
        .child("Last seen")
        .once()
        .then((event) {
      int now = DateTime.now().hour;
      int lastSeen = int.parse(event.snapshot.value.toString());
      int result = now > lastSeen
          ? (now - lastSeen)
          : now < lastSeen
              ? (24 - lastSeen + now)
              : 0;
      if (result >= 22) {
        _dbref
            .child("Users")
            .child("BOX1")
            .child("Last seen")
            .set(DateTime.now().hour);
        id++;
        createBasicNotification(
            id: id,
            title: 'Smart-b Support',
            body:
                'The last time your patient interacted was a while ago, call him ASAP');
      }
    });
  }
  await _dbref
      .child("Drugs")
      .once()
      .then((event) => data = event.snapshot.children);
  await _dbref
      .child("Smart-b1")
      .child("State")
      .once()
      .then((event) => state = event.snapshot.value.toString());
  for (var element in data) {
    drugName = element.child("Name").value.toString();
    numberOfPillsPublicc = element.child("Number of pills").value.toString();
    numberOfPillsPublic[drugName] =
        int.parse(element.child("Number of pills").value.toString());
    pillsConfirmed[drugName] = [int.parse(numberOfPillsPublicc)];
    medsCheckTypes[drugName] =
        int.parse(element.child("Check Type").value.toString());
    daysData[drugName] = [];
    weeksList[drugName] = [];
    notifyFillBottle[drugName] = element.child("Notify").value.toString();
    pillsPerDay[drugName] = 0;
    if (element.hasChild("Weeks")) {
      weeks = element.child("Weeks").value.toString();
      if (weeks.contains('1')) {
        weeksList[drugName] = weeksList[drugName]! + [1];
      }
      if (weeks.contains('2')) {
        weeksList[drugName] = weeksList[drugName]! + [2];
      }
      if (weeks.contains('3')) {
        weeksList[drugName] = weeksList[drugName]! + [3];
      }
      if (weeks.contains('4')) {
        weeksList[drugName] = weeksList[drugName]! + [4];
      }
    }
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

        pillsPerDay[drugName] = pillsPerDay[drugName]! +
            int.parse(element
                .child("Doses Times")
                .child("$i")
                .child("Number of pills")
                .value
                .toString());
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
        pillsPerDay[drugName] = pillsPerDay[drugName]! +
            int.parse(element
                .child("Doses Times")
                .child("$i")
                .child("Number of pills")
                .value
                .toString());
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
        pillsPerDay[drugName] = pillsPerDay[drugName]! +
            int.parse(element
                .child("Doses Times")
                .child("$i")
                .child("Number of pills")
                .value
                .toString());
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
        pillsPerDay[drugName] = pillsPerDay[drugName]! +
            int.parse(element
                .child("Doses Times")
                .child("$i")
                .child("Number of pills")
                .value
                .toString());
      }
    } else if (element.child("Doses Times").hasChild("1")) {
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
      pillsPerDay[drugName] = int.parse(element
          .child("Doses Times")
          .child("1")
          .child("Number of pills")
          .value
          .toString());
    }

    if (numberOfPillsPublic[drugName]! <= pillsPerDay[drugName]! * 3 ||
        numberOfPillsPublic[drugName]! <= pillsPerDay[drugName]! * 2 ||
        numberOfPillsPublic[drugName]! <= pillsPerDay[drugName]!) {
      if (notifyFillBottle[drugName] == 'not notified') {
        _dbref
            .child("Drugs")
            .child("$drugName")
            .child("Notify")
            .set('notified');
        ++id;
        if (numberOfPillsPublic[drugName]! > 0) {
          createBasicNotification(
              id: id,
              title: drugName,
              body:
                  'Only ${numberOfPillsPublic[drugName]} pills left, fill it please');
        } else if (numberOfPillsPublic[drugName] == 0) {
          createBasicNotification(
              id: id,
              title: drugName,
              body: 'There are no pills anymore, fill it please');
        }
      }
    }
  }
  daysData.forEach((key1, value) {
    if (dosesTimeData[key1] != null &&
        DateTime.now().hour == 0 &&
        DateTime.now().minute == 0) {
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
      _dbref
          .child("Drugs")
          .child("$drugName")
          .child("Notify")
          .set('not notified');
    }

    if (value.contains(DateTime.now().weekday) && weeksList[key1]!.isEmpty) {
      dosesTimeData.forEach((key2, value) {
        int count = 1;
        int doseNumber = 1;
        if (key1 == key2) {
          for (var i in value) {
            late String now = DateTime.now().hour.toString();
            if (DateTime.now().hour >= 12) {
              now = '${DateTime.now().hour}:${DateTime.now().minute} PM';
            } else {
              now = '${DateTime.now().hour}:${DateTime.now().minute} AM';
            }
            if (count == 1) {
              doseTime += '$i:';
            } else if (count == 2) {
              doseTime += '$i';
              doseTime += ' ';
            } else if (count == 3) {
              numberOfPillsDoses = i;
            } else if (count == 4) {
              doseTime += i.toString();
            } else if (count == 5) {
              // print(key1);
              // print(doseTime);
              // print(now);
              // print(doseNumber);
              if (doseTime == now) print('yes');
              if (doseTime == now && userP == 'person') {
                print('heree');
                if (i == 'Not displayed') {
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
                    int doseNum = doseNumber;
                    _dbref
                        .child("Drugs")
                        .child("$key1")
                        .child("Doses Times")
                        .child("$doseNumber")
                        .child("State")
                        .set('alerted')
                        .whenComplete(() {
                      numberOfPillsPublic[key1] != -1
                          ? {
                              createNotificationWithButtons(
                                  id: ++id,
                                  title: key1,
                                  body:
                                      'Hey there, it\'s time to take $numberOfPillsDoses pills',
                                  doseNum: doseNum)
                            }
                          : {
                              createNotificationWithButtons(
                                  id: ++id,
                                  title: key1,
                                  body:
                                      'Hey there, it\'s time to take your dose',
                                  doseNum: doseNum)
                            };
                    });
                  } else {
                    if (state == 'alert') {
                      int doseNum = doseNumber;
                      _dbref
                          .child("Drugs")
                          .child("$key1")
                          .child("Doses Times")
                          .child("$doseNumber")
                          .child("State")
                          .set('alerted')
                          .whenComplete(() {
                        numberOfPillsPublic[key1] != -1
                            ? {
                                createNotificationWithButtons(
                                    id: ++id,
                                    title: key1,
                                    body:
                                        'Hey there, it\'s time to take $numberOfPillsDoses pills',
                                    doseNum: doseNum)
                              }
                            : {
                                createNotificationWithButtons(
                                    id: ++id,
                                    title: key1,
                                    body:
                                        'Hey there, it\'s time to take your dose',
                                    doseNum: doseNum)
                              };
                      });
                    } else if (state == 'confirmed') {
                      confirmed(
                          name: key1, doseNum: doseNumber, state: 'Completed');
                      setLifeCycleState(state: 'time off');
                    }
                  }
                }
              } else if (i == 'Displayed' && userP == 'person') {
                if (medsCheckTypes[key1] == 1) {
                  int doseNum = doseNumber;
                  _dbref
                      .child("Drugs")
                      .child("$key1")
                      .child("Doses Times")
                      .child("$doseNumber")
                      .child("State")
                      .set('alerted')
                      .whenComplete(() {
                    createNotificationWithButtons(
                        id: ++id,
                        title: key1,
                        body:
                            'Hey there! it\'s time to take $numberOfPillsDoses pills',
                        doseNum: doseNum);
                  });
                } else {
                  if (state == 'alert') {
                    int doseNum = doseNumber;
                    _dbref
                        .child("Drugs")
                        .child("$key1")
                        .child("Doses Times")
                        .child("$doseNumber")
                        .child("State")
                        .set('alerted')
                        .whenComplete(() {
                      numberOfPillsPublic[key1] != -1
                          ? {
                              createNotificationWithButtons(
                                  id: ++id,
                                  title: key1,
                                  body:
                                      'Hey there, it\'s time to take $numberOfPillsDoses pills',
                                  doseNum: doseNum)
                            }
                          : {
                              createNotificationWithButtons(
                                  id: ++id,
                                  title: key1,
                                  body:
                                      'Hey there, it\'s time to take your dose',
                                  doseNum: doseNum)
                            };
                    });
                  } else if (state == 'confirmed') {
                    confirmed(
                        name: key1, doseNum: doseNumber, state: 'Completed');
                    setLifeCycleState(state: 'time off');
                  }
                }
              }
              doseTime = '';
              count = 0;
              doseNumber++;
            }
            ++count;
          }
        }
      });
    } else if (value.contains(DateTime.now().weekday) &&
        weeksList[key1]!.isNotEmpty) {
      for (var z in weeksList[key1]!) {
        int temp = z * 7;
        if (DateTime.now().day <= temp && DateTime.now().day >= temp - 7) {
          dosesTimeData.forEach((key2, value) {
            int count = 1;
            int doseNumber = 1;
            if (key1 == key2) {
              for (var i in value) {
                late String now = DateTime.now().hour.toString();
                if (DateTime.now().hour >= 12) {
                  now = '${DateTime.now().hour}:${DateTime.now().minute} PM';
                } else {
                  now = '${DateTime.now().hour}:${DateTime.now().minute} AM';
                }
                if (count == 1) {
                  doseTime += '$i:';
                } else if (count == 2) {
                  doseTime += '$i';
                  doseTime += ' ';
                } else if (count == 3) {
                  numberOfPillsDoses = i;
                } else if (count == 4) {
                  doseTime += i.toString();
                } else if (count == 5) {
                  if (doseTime == now) print('yes');
                  if (doseTime == now && userP == 'person') {
                    if (i == 'Not displayed') {
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
                        int doseNum = doseNumber;
                        _dbref
                            .child("Drugs")
                            .child("$key1")
                            .child("Doses Times")
                            .child("$doseNumber")
                            .child("State")
                            .set('alerted')
                            .whenComplete(() {
                          numberOfPillsPublic[key1] != -1
                              ? {
                                  createNotificationWithButtons(
                                      id: ++id,
                                      title: key1,
                                      body:
                                          'Hey there, it\'s time to take $numberOfPillsDoses pills',
                                      doseNum: doseNum)
                                }
                              : {
                                  createNotificationWithButtons(
                                      id: ++id,
                                      title: key1,
                                      body:
                                          'Hey there, it\'s time to take your dose',
                                      doseNum: doseNum)
                                };
                        });
                      } else {
                        if (state == 'alert') {
                          int doseNum = doseNumber;
                          _dbref
                              .child("Drugs")
                              .child("$key1")
                              .child("Doses Times")
                              .child("$doseNumber")
                              .child("State")
                              .set('alerted')
                              .whenComplete(() {
                            numberOfPillsPublic[key1] != -1
                                ? {
                                    createNotificationWithButtons(
                                        id: ++id,
                                        title: key1,
                                        body:
                                            'Hey there, it\'s time to take $numberOfPillsDoses pills',
                                        doseNum: doseNum)
                                  }
                                : {
                                    createNotificationWithButtons(
                                        id: ++id,
                                        title: key1,
                                        body:
                                            'Hey there, it\'s time to take your dose',
                                        doseNum: doseNum)
                                  };
                          });
                          id++;
                        } else if (state == 'confirmed') {
                          confirmed(
                              name: key1,
                              doseNum: doseNumber,
                              state: 'Completed');
                          setLifeCycleState(state: 'time off');
                        }
                      }
                    }
                  } else if (i == 'Displayed' && userP == 'person') {
                    if (medsCheckTypes[key1] == 1) {
                      int doseNum = doseNumber;
                      _dbref
                          .child("Drugs")
                          .child("$key1")
                          .child("Doses Times")
                          .child("$doseNumber")
                          .child("State")
                          .set('alerted')
                          .whenComplete(() {
                        createNotificationWithButtons(
                            id: ++id,
                            title: key1,
                            body:
                                'Hey there! it\'s time to take $numberOfPillsDoses pills',
                            doseNum: doseNum);
                      });
                      id++;
                    } else {
                      if (state == 'alert') {
                        int doseNum = doseNumber;
                        _dbref
                            .child("Drugs")
                            .child("$key1")
                            .child("Doses Times")
                            .child("$doseNumber")
                            .child("State")
                            .set('alerted')
                            .whenComplete(() {
                          numberOfPillsPublic[key1] != -1
                              ? {
                                  createNotificationWithButtons(
                                      id: ++id,
                                      title: key1,
                                      body:
                                          'Hey there, it\'s time to take $numberOfPillsDoses pills',
                                      doseNum: doseNum)
                                }
                              : {
                                  createNotificationWithButtons(
                                      id: ++id,
                                      title: key1,
                                      body:
                                          'Hey there, it\'s time to take your dose',
                                      doseNum: doseNum)
                                };
                        });
                        ++id;
                      } else if (state == 'confirmed') {
                        confirmed(
                            name: key1,
                            doseNum: doseNumber,
                            state: 'Completed');
                        setLifeCycleState(state: 'time off');
                      }
                    }
                  }
                  doseTime = '';
                  count = 0;
                  doseNumber++;
                }
                ++count;
              }
            }
          });
        }
      }
    }
  });
  if (pillsNums.contains(1) || pillsNums.contains(2) || pillsNums.contains(3)) {
    int drugsChecked = 0;
    for (var element in pillsNums) {
      element != 0 ? drugsChecked++ : {};
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("drugsChecked", drugsChecked);
    timeAll(pillsNums: pillsNums);
    pillsNums = [0, 0, 0, 0];
  }
  if (state == 'confirmed') {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("drugsChecked", 0);
  }
}

void getDailyAdvice() {
  createScheduleNotification(
      id: count,
      title: 'Good afternoon',
      body: advices[0],
      day: DateTime.now().day,
      hour: 9);
  createScheduleNotification(
      id: count,
      title: 'Good afternoon',
      body: advices[0],
      day: DateTime.now().day + 1,
      hour: 15);
  createScheduleNotification(
      id: count,
      title: 'Good afternoon',
      body: advices[0],
      day: DateTime.now().day + 2,
      hour: 21);
}

Future<void> confirmed(
    {required String name, required int doseNum, required String state}) async {
  _dbref
      .child("Users")
      .child("BOX1")
      .child("Last seen")
      .set(DateTime.now().hour);
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
          if (int.parse(numOfPillsP) > 0)
            {
              _dbref
                  .child("Drugs")
                  .child("$name")
                  .child("Number of pills")
                  .set(int.parse(numOfPillsP) - int.parse(numOfPillsD))
            }
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
  print('jjjkk');
  _dbref
      .child("Users")
      .child("BOX1")
      .child("Last seen")
      .set(DateTime.now().hour)
      .whenComplete(() {
    _dbref.child("Smart-b1").child("State").set(state).whenComplete(() {
      state == 'time off'
          ? {
              _dbref.child("Smart-b1").child("Bottle1").set('dis'),
              _dbref.child("Smart-b1").child("Bottle2").set('dis'),
              _dbref.child("Smart-b1").child("Bottle3").set('dis'),
              _dbref.child("Smart-b1").child("Bottle4").set('dis'),
            }
          : {};
    });
  });
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
  late Size size;
  @override
  Widget build(BuildContext context) {
    Text c;
    int dosesLeft = widget.dosesPerDay - widget.doseNumber;
    if (dosesLeft == 0) {
      c = const Text(
        'Good job, all doses are done',
        style: TextStyle(
            fontSize: 13.0,
            color: Color(0xFF9B9B9B),
            fontWeight: FontWeight.bold),
      );
    } else {
      c = Text(
        'Good job, $dosesLeft doses left for today ',
        style: const TextStyle(
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

    size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
          top: size.height * 0.008, bottom: size.height * 0.008),
      height: size.height * 0.1,
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
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.03),
              child: Image.asset('images/pill.png')),
          Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                widget.drugName,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: size.height * 0.006,
              ),
              Text(
                widget.doseTime,
                style: const TextStyle(
                    fontSize: 13, color: const Color(0xFF9B9B9B)),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(
                left: size.width * 0.01, right: size.width * 0.01),
            child: const Text(
              '.',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF9B9B9B)),
            ),
          ),
          Flexible(
            child: Container(
              margin: EdgeInsets.only(top: size.height * 0.008),
              child: state(),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: size.width * 0.01, right: size.width * 0.01),
            child: const Text(
              '.',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF9B9B9B)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: size.height * 0.008),
            child: widget.state.contains('Hey there')
                ? null
                : widget.state == stateC.data
                    ? stateC
                    : stateS,
          ),
          Container(
            margin: EdgeInsets.only(right: size.height * 0.008),
            child: Visibility(
                visible: widget.checkVis,
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          widget.checkVis = false;
                          AwesomeNotifications()
                              .cancelNotificationsByChannelKey(
                                  'button_channel');
                          confirmed(
                              name: widget.drugName,
                              doseNum: widget.doseNumber,
                              state: 'Completed');
                          checkConfirmed();
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
                          AwesomeNotifications()
                              .cancelNotificationsByChannelKey(
                                  'button_channel');
                          confirmed(
                              name: widget.drugName,
                              doseNum: widget.doseNumber,
                              state: 'Skipped');
                          checkConfirmed();
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
            margin: EdgeInsets.only(
                left: size.width * 0.01, right: size.width * 0.01),
            child: Text(
              timeago.format(widget.timeAgo, locale: 'en_short'),
              style: const TextStyle(fontSize: 12, color: Color(0xFF9B9B9B)),
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
                              Flexible(
                                child: Column(
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
                              Visibility(
                                visible: numberOfPills == '-1' ? false : true,
                                child: Text(
                                  'Number of pills : $numberOfPills',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Text(
                                'Schedule : $days',
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
                          Flexible(
                            child: Column(
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
                          Visibility(
                            visible: numberOfPills == '-1' ? false : true,
                            child: Text(
                              'Number of pills : $numberOfPills',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.black,
                              ),
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

Future<void> checkConfirmed() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int drugsChecked = prefs.getInt("drugsChecked")!;
  --drugsChecked;
  print('d== $drugsChecked');
  drugsChecked == 0
      ? {
          await setLifeCycleState(state: 'confirmed'),
        }
      : {};
  prefs.setInt("drugsChecked", drugsChecked);
}
