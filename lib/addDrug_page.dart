import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:awesome_select/awesome_select.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_b/home_page.dart';
import 'package:smart_b/services/firebase&Constants.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:firebase_database/firebase_database.dart';

Map<int, List> dosesTimesValues = {};
List<String> times = ['a', 'a', 'a', 'a', 'a'];

class addDrugPage extends StatefulWidget {
  String? name;
  addDrugPage({Key? key, this.name}) : super(key: key);
  @override
  State<addDrugPage> createState() => _addDrugPageState();
}

class _addDrugPageState extends State<addDrugPage> {
  @override
  void initState() {
    if (widget.name == null) {
      bottlesNumbers.length == 4
          ? {
              checkTypes = [S2Choice<int>(value: 1, title: 'App only')]
            }
          : {
              for (int i = 1; i <= 4; i++)
                {
                  if (!bottlesNumbers.values.contains(i))
                    {
                      bottles.add(S2Choice<int>(
                          value: i,
                          title: i == 1
                              ? 'One'
                              : i == 2
                                  ? 'Two'
                                  : i == 3
                                      ? 'Three'
                                      : 'Four')),
                      bottleNumber = bottles.first.value
                    }
                }
            };
    }
    if (widget.name != null) {
      checkType = medsCheckTypes[widget.name]!;
      isAppType = checkType == 1 ? true : false;
      if (checkType == 2) {
        late S2Choice<int> temp;
        bottlesNumbers.forEach((key, value) {
          if (key == widget.name) {
            bottleNumber = value;
            temp = S2Choice<int>(
                value: value,
                title: value == 1
                    ? 'One'
                    : value == 2
                        ? 'Two'
                        : value == 3
                            ? 'Three'
                            : 'Four');
          }
        });
        for (int i = 1; i <= 4; i++) {
          i == temp.value
              ? {
                  bottles.add(temp),
                }
              : {
                  if (!bottlesNumbers.values.contains(i))
                    {
                      bottles.add(S2Choice<int>(
                          value: i,
                          title: i == 1
                              ? 'One'
                              : i == 2
                                  ? 'Two'
                                  : i == 3
                                      ? 'Three'
                                      : 'Four')),
                    }
                };
        }
      } else {
        bottlesNumbers.length == 4
            ? {
                checkTypes = [S2Choice<int>(value: 1, title: 'App only')]
              }
            : {
                for (int i = 1; i <= 4; i++)
                  {
                    if (!bottlesNumbers.values.contains(i))
                      {
                        bottles.add(S2Choice<int>(
                            value: i,
                            title: i == 1
                                ? 'One'
                                : i == 2
                                    ? 'Two'
                                    : i == 3
                                        ? 'Three'
                                        : 'Four')),
                        bottleNumber = bottles.first.value,
                      }
                  }
              };
      }
      getData(widget.name!);
      daysData.forEach((key, value) {
        if (key == widget.name) {
          days = value;
        }
      });
      dosesPerDayData.forEach((key, value) {
        if (key == widget.name) {
          dosesPerDay = value;
        }
        //timeDosesMakerData(dosesPerDay);
      });
    }
    dosesTimesValues = {};
    times = ['a', 'a', 'a', 'a', 'a'];
    super.initState();
  }

  Future<void> getData(String name) async {
    late Iterable<DataSnapshot> data;
    await _dbref
        .child("Drugs")
        .once()
        .then((event) => data = event.snapshot.children);
    data.forEach((element) {
      if (element.child("Name").value.toString() == widget.name) {
        myNameController.text = element.child("Name").value.toString();
        myPillsNumController.text =
            element.child("Number of pills").value.toString();
        dosesPerDay =
            int.parse(element.child("Doses per day").value.toString());
        var fireDays = element.child("Days").children;
        // print(days);
        fireDays.forEach((element) {
          int day = int.parse(element.value.toString());
          days!.add(day);
        });
      }
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    myNameController.dispose();
    myPillsNumController.dispose();
    dosesTimesValues.clear();
    drugNameCheck = false;
    numberOfPillsCheck = false;
    timeCheck = false;
    timeNullCheck = false;
    daysCheck = false;
    saveChangesCheck = false;
    isAppType = true;
    times.clear();
    super.dispose();
  }

  int dosesPerDay = 1;
  int bottleNumber = 1;
  int checkType = 1;
  late DatabaseReference _dbref = FirebaseDatabase.instance.ref();
  final myNameController = TextEditingController();
  final myPillsNumController = TextEditingController();

  bool drugNameCheck = false;
  bool numberOfPillsCheck = false;
  bool timeCheck = false;
  bool timeNullCheck = false;
  bool daysCheck = false;
  bool saveChangesCheck = false;
  bool isAppType = true;
  List<S2Choice<int>> doses = [
    S2Choice<int>(value: 1, title: '1 Doses'),
    S2Choice<int>(value: 2, title: '2 Doses'),
    S2Choice<int>(value: 3, title: '3 Doses'),
    S2Choice<int>(value: 4, title: '4 Doses'),
    S2Choice<int>(value: 5, title: '5 Doses'),
  ];
  List<S2Choice<int>> checkTypes = [
    S2Choice<int>(value: 1, title: 'App only'),
    S2Choice<int>(value: 2, title: 'App and Box'),
  ];
  List<S2Choice<int>> bottles = [];
  List<Object?>? days = [];
  List<S2Choice<int>> Days = [
    S2Choice<int>(value: 1, title: 'Sunday'),
    S2Choice<int>(value: 2, title: 'Monday'),
    S2Choice<int>(value: 3, title: 'Tuesday'),
    S2Choice<int>(value: 4, title: 'Wednesday'),
    S2Choice<int>(value: 5, title: 'Thursday'),
    S2Choice<int>(value: 6, title: 'Friday'),
    S2Choice<int>(value: 7, title: 'Saturday'),
  ];
  Future<void> dbAddDrug(
      {
        required String drugName,
      required String numOfPills,
      required int checkType,
      required int bottleNumber,
      required int dosesPerDay,
      required Map<int, List<dynamic>> dosesVal,
      List<Object?>? daysList}) async {
    if (dosesPerDay <= 0 || dosesTimesValues.isEmpty) {
      return;
    }
    _dbref.child("Drugs").once().then((value) async {
      if (!value.snapshot.hasChild("$drugName") || widget.name != null) {
        if (widget.name != null) {
          _dbref.child("Drugs").child("${widget.name}").remove();
        }
        bottlesNumbers.removeWhere((key, value) => key == drugName);
        try {
          _dbref.child("Drugs").child("$drugName").child("Name").set(drugName).whenComplete(() => _dbref
              .child("Drugs")
              .child("$drugName")
              .child("Number of pills")
              .set(int.parse(numOfPills)).whenComplete(() =>  _dbref
              .child("Drugs")
              .child("$drugName")
              .child("Check Type")
              .set(checkType).whenComplete(() => _dbref
              .child("Drugs")
              .child("$drugName")
              .child("Medicine bottle number")
              .set(bottleNumber).whenComplete(() =>  _dbref
              .child("Drugs")
              .child("$drugName")
              .child("Doses per day")
              .set(dosesPerDay).whenComplete((){
            for (int i = 1; i <= dosesPerDay; i++) {
              _dbref
                  .child("Drugs")
                  .child("$drugName")
                  .child("Doses Times")
                  .child("$i")
                  .child("Hour")
                  .set(dosesVal[i]!.elementAt(0)).whenComplete(() =>  _dbref
                  .child("Drugs")
                  .child("$drugName")
                  .child("Doses Times")
                  .child("$i")
                  .child("Minute")
                  .set(dosesVal[i]!.elementAt(1)).whenComplete(() => _dbref
                  .child("Drugs")
                  .child("$drugName")
                  .child("Doses Times")
                  .child("$i")
                  .child("period")
                  .set(dosesVal[i]!.elementAt(2)).whenComplete(() =>  _dbref
                  .child("Drugs")
                  .child("$drugName")
                  .child("Doses Times")
                  .child("$i")
                  .child("Number of pills")
                  .set(dosesVal[i]!.elementAt(3)).whenComplete(() => _dbref
                  .child("Drugs")
                  .child("$drugName")
                  .child("Doses Times")
                  .child("$i")
                  .child("State")
                  .set('Not displayed').whenComplete(() {
                    if(i==dosesPerDay){
                      int count=0;
                      for (var i in daysList!) {
                        count++;
                        _dbref
                            .child("Drugs")
                            .child("$drugName")
                            .child("Days")
                            .child(i == 1
                            ? "Sunday"
                            : i == 2
                            ? "Monday"
                            : i == 3
                            ? "Tuesday"
                            : i == 4
                            ? "Wednesday"
                            : i == 5
                            ? "Thursday"
                            : i == 6
                            ? "Friday"
                            : "Saturday")
                            .set(i).whenComplete(() {
                              if(count==daysList.length){
                                widget.name == null
                                    ? showToast('Med added')
                                    : showToast('Med edited');
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const homePage()),
                                        (e) => false);
                              }
                        });
                      }
                    }
              })))));

            }
          })))));
        } catch (e) {
          print(e);
        }
      } else {
        showToast('The medicine is already exist.');
      }
    });
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xFFEEEEEE),
        textColor: Colors.black,
        fontSize: 14.0);
  }

  Future<void> _showMyDialogExist(
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
                'OK',
                style: TextStyle(color: Color(0xFF44CBB1)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialogSaveChanges(
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
                saveChangesCheck = false;
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'No',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                saveChangesCheck = true;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            timeCheck = false;
            times.clear();
            dosesTimesValues.clear();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => homePage()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        title: Text(
          widget.name == null ? 'Add Med' : 'Edit Med',
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(24),
            child: Column(
              children: <Widget>[
                buildDrugName(),
                Visibility(
                    visible: drugNameCheck,
                    child: const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Missing field!',
                        style: TextStyle(color: Colors.red),
                      ),
                    )),
                const SizedBox(height: 15),
                buildNumberOfPills(),
                Visibility(
                    visible: numberOfPillsCheck,
                    child: const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Missing field!',
                        style: TextStyle(color: Colors.red),
                      ),
                    )),
                const SizedBox(height: 15),
                Container(
                  color: const Color(0xFFEEEEEE),
                  child: SmartSelect<int>.single(
                      modalType: S2ModalType.popupDialog,
                      modalStyle: S2ModalStyle(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      selectedValue: checkType,
                      title: 'Remind you through',
                      choiceItems: checkTypes,
                      onChange: (state) {
                        setState(() {
                          checkType = state.value!;
                          if (state.value == 1) {
                            isAppType = true;
                          } else {
                            isAppType = false;
                          }
                        });
                      }),
                ),
                const SizedBox(height: 15),
                Visibility(
                  visible: !isAppType,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    color: const Color(0xFFEEEEEE),
                    child: SmartSelect<int>.single(
                        modalType: S2ModalType.popupDialog,
                        modalStyle: S2ModalStyle(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        selectedValue: bottleNumber,
                        title: 'Medicine bottle number',
                        choiceItems: bottles,
                        onChange: (state) {
                          setState(() {
                            bottleNumber = state.value!;
                          });
                        }),
                  ),
                ),

                Container(
                  color: const Color(0xFFEEEEEE),
                  child: SmartSelect<int>.single(
                      modalType: S2ModalType.popupDialog,
                      modalStyle: S2ModalStyle(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      selectedValue: dosesPerDay,
                      title: 'Doses per day',
                      choiceItems: doses,
                      onChange: (state) {
                        setState(() {
                          dosesPerDay = state.value!;
                        });
                      }),
                ),
                const SizedBox(
                  height: 15,
                ),
                timeDosesMaker(dosesPerDay)!,
                Visibility(
                    visible: timeCheck,
                    child: const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'It\'s impossible to have two doses of the same medicine at the same time!',
                        style: TextStyle(color: Colors.red),
                      ),
                    )),
                Visibility(
                    visible: timeNullCheck,
                    child: const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Please set time!',
                        style: TextStyle(color: Colors.red),
                      ),
                    )),
                //DosesTimes(),
                const SizedBox(height: 15),
                Container(
                  color: const Color(0xFFEEEEEE),
                  child: SmartSelect.multiple(
                    modalType: S2ModalType.popupDialog,
                    modalStyle: S2ModalStyle(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    title: 'Days',
                    selectedValue: days,
                    choiceItems: Days,
                    onChange: (state) => setState(() {
                      days = state!.value;
                    }),
                  ),
                ),
                Visibility(
                    visible: daysCheck,
                    child: const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Please set at least one day!',
                        style: TextStyle(color: Colors.red),
                      ),
                    )),

                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: const Color(0xff44CBB1),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20)),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => {
                    setState(() {
                      check(timeDosesMaker(dosesPerDay)!.children.length);
                      if (widget.name != null) {
                        _showMyDialogSaveChanges(
                                title: 'Smart-B support',
                                body: 'Are you sure you want to save changes?')
                            .then((_) => {
                                  if (dosesTimesValues != {} &&
                                      !saveChangesCheck)
                                    {
                                      if (!drugNameCheck &&
                                          !numberOfPillsCheck &&
                                          !timeCheck &&
                                          !timeNullCheck &&
                                          !daysCheck)
                                        {
                                          dbAddDrug(
                                                  drugName: myNameController
                                                      .text
                                                      .trim(),
                                                  numOfPills:
                                                      myPillsNumController.text
                                                          .trim(),
                                                  checkType: checkType,
                                                  bottleNumber: isAppType
                                                      ? 0
                                                      : bottleNumber,
                                                  dosesPerDay: dosesPerDay,
                                                  dosesVal: dosesTimesValues,
                                                  daysList: days)
                                        }
                                    }
                                  else
                                    {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const homePage()),
                                          (e) => false)
                                    }
                                });
                      } else {
                        if (dosesTimesValues != {}) {
                          if (!drugNameCheck &&
                              !numberOfPillsCheck &&
                              !timeCheck &&
                              !timeNullCheck &&
                              !daysCheck &&
                              !saveChangesCheck) {
                            dbAddDrug(
                                    drugName: myNameController.text.trim(),
                                    numOfPills:
                                        myPillsNumController.text.trim(),
                                    checkType: checkType,
                                    bottleNumber: isAppType ? 0 : bottleNumber,
                                    dosesPerDay: dosesPerDay,
                                    dosesVal: dosesTimesValues,
                                    daysList: days);
                          }
                        } else {
                          print(dosesTimesValues);
                        }
                      }
                    }),
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column? timeDosesMaker(int doses) {
    Column maker;
    if (widget.name != null) {
      maker = Column(
        children: [
          dosesTimes(
            doseNumber: 1,
            dosesPerDay: doses,
            drugName: widget.name,
          )
        ],
      );
      for (int i = 1; i < doses; i++) {
        maker.children.insert(
            i,
            dosesTimes(
              doseNumber: i + 1,
              dosesPerDay: doses,
              drugName: widget.name,
            ));
      }
    } else {
      maker = Column(
        children: [
          dosesTimes(
            doseNumber: 1,
            dosesPerDay: doses,
          )
        ],
      );
      for (int i = 1; i < doses; i++) {
        maker.children.insert(
            i,
            dosesTimes(
              doseNumber: i + 1,
              dosesPerDay: doses,
            ));
      }
    }
    for (int i = doses; i < 5; i++) {
      times[i] = 'a';
      dosesTimesValues.remove(i + 1);
    }
    print(dosesTimesValues);
    // print(maker.children.length);
    // print(times);
    //print(DosesTimesValues);

    return maker;
  }

  void check(int length) {
    if (myNameController.text == '') {
      drugNameCheck = true;
    } else {
      drugNameCheck = false;
    }
    if (myPillsNumController.text == '') {
      numberOfPillsCheck = true;
    } else {
      numberOfPillsCheck = false;
    }
    if (times.isNotEmpty)
      for (int i = 0; i < times.length; i++) {
        for (int x = times.length - 1; x > i; x--) {
          if (times[i] == times[x] && times[i] != 'a' && times[x] != 'a') {
            timeCheck = true;
            break;
          } else {
            timeCheck = false;
          }
        }
        if (timeCheck) break;
      }
    if (dosesTimesValues.isEmpty) {
      timeNullCheck = true;
    } else if (dosesTimesValues.length != length && length != 1) {
      timeNullCheck = true;
    } else {
      timeNullCheck = false;
    }
    print(days.toString());
    if (days == null || days.toString() == '[]') {
      daysCheck = true;
    } else {
      daysCheck = false;
    }
  }

  Widget buildDrugName() {
    return TextFormField(
        controller: myNameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            labelText: 'Drug Name', border: OutlineInputBorder()));
  }

  Widget buildNumberOfPills() {
    return TextFormField(
      controller: myPillsNumController,
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
          labelText: 'Number Of Pills', border: OutlineInputBorder()),
    );
  }

  // Widget buildMedicineBottleNumber() {
  //   return TextFormField(
  //     controller: myBottleController,
  //     keyboardType: TextInputType.phone,
  //     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  //     decoration: const InputDecoration(
  //         labelText: 'Medicine Bottle Number', border: OutlineInputBorder()),
  //   );
  // }
}

class dosesTimes extends StatefulWidget {
  int doseNumber;
  int dosesPerDay;
  String? drugName;
  dosesTimes(
      {required this.doseNumber, required this.dosesPerDay, this.drugName});
  @override
  State<dosesTimes> createState() => _dosesTimesState();
}

class _dosesTimesState extends State<dosesTimes> {
  TimeOfDay? newTime;
  int dropdownValue = 1;
  String timeText = 'Add time';
  @override
  void initState() {
    if (widget.drugName != 'Add time') {
      print('dosesTimesData $dosesTimeData');
      print(widget.doseNumber);
      dosesTimeData.forEach((key, value) {
        if (key == widget.drugName) {
          print(value);
          int startVal = widget.doseNumber * 4 - 4 + 1;
          int count1 = 1;
          int count2 = 1;
          String period = 'AM';
          List doseVal = [];
          //print(value);
          for (var x in value) {
            if (startVal == count1) {
              if (count2 == 1) {
                doseVal = doseVal + [x];
                timeText = '$x:';
                period = int.parse(x.toString()) >= 12 ? 'PM' : 'AM';
              } else if (count2 == 2) {
                doseVal = doseVal + [x] + [period];
                timeText += '$x $period';
              } else if (count2 == 3) {
                doseVal = doseVal + [x];
              } else if (count2 == 4) {
                period = 'AM';
                dosesTimesValues[widget.doseNumber] = doseVal;
                doseVal = [];
                print('herr $dosesTimesValues');
                break;
              }
              ++count2;
            } else {
              ++count1;
            }
          }
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      beforeLineStyle: LineStyle(color: Color(0xFFEEEEEE), thickness: 3),
      afterLineStyle: LineStyle(color: Color(0xFFEEEEEE), thickness: 3),
      indicatorStyle: IndicatorStyle(
        width: 10,
        color: Color(0xFF44CBB1),
      ),
      endChild: Row(
        children: [
          TextButton(
              onPressed: () {
                showClock();
              },
              child: Container(
                height: 25,
                width: 80,
                color: const Color(0xFFEEEEEE),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        timeText,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.more_time,
                        color: Colors.grey,
                        size: 15,
                      )
                    ],
                  ),
                ),
              )),
          const SizedBox(
            width: 30,
          ),
          const Text('Pills:   '),
          DropdownButton<int>(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_drop_down),
            elevation: 16,
            style: const TextStyle(color: Colors.black),
            onChanged: (int? newValue) {
              setState(() {
                dropdownValue = newValue!;
                if (newTime != null) {
                  dosesTimesValues[widget.doseNumber] = [
                    newTime!.hour,
                    newTime!.minute,
                    newTime!.period.toString().contains('am') ? 'AM' : 'PM',
                    dropdownValue
                  ];
                }
                if (newTime != null) {
                  timeText =
                      '${newTime!.hour}:${newTime!.minute} ${dosesTimesValues[widget.doseNumber]!.elementAt(2)}';
                }
                //  print(DosesTimesValues);
              });
            },
            items: <int>[1, 2, 3, 4, 5, 6, 7, 8]
                .map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void showClock() async {
    newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 7, minute: 15),
    );

    setState(() {
      dosesTimesValues[widget.doseNumber] = [
        newTime!.hour,
        newTime!.minute,
        newTime!.period.toString().contains('am') ? 'AM' : 'PM',
        dropdownValue
      ];
      timeText = '${newTime!.hour}:${newTime!.minute} ' +
          dosesTimesValues[widget.doseNumber]!.elementAt(2);
      times[widget.doseNumber - 1] = timeText;
      //print(DosesTimesValues.length);
      for (int i = widget.dosesPerDay; i < 5; i++) {
        times[i] = 'a';
        dosesTimesValues.remove(i + 1);
      }
    });
  }
}
