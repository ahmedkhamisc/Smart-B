import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:awesome_select/awesome_select.dart';
import 'package:smart_b/home_page.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:firebase_database/firebase_database.dart';

Map<int, List> DosesTimesValues = {};

class addDrugPage extends StatefulWidget {
  const addDrugPage({Key? key}) : super(key: key);

  @override
  State<addDrugPage> createState() => _addDrugPageState();
}

class _addDrugPageState extends State<addDrugPage> {
  @override
  void initState() {
    DosesTimesValues = {};
    super.initState();
  }

  String? DrugName;
  String? NumberOfPills;
  String? MedicineBottleNumber;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int dosesPerDay = 1;
  List<S2Choice<int>> Doses = [
    S2Choice<int>(value: 1, title: '1 Doses'),
    S2Choice<int>(value: 2, title: '2 Doses'),
    S2Choice<int>(value: 3, title: '3 Doses'),
    S2Choice<int>(value: 4, title: '4 Doses'),
    S2Choice<int>(value: 5, title: '5 Doses'),
  ];
  List<Object?>? days = [1];
  List<S2Choice<int>> Days = [
    S2Choice<int>(value: 1, title: 'Sunday'),
    S2Choice<int>(value: 2, title: 'Monday'),
    S2Choice<int>(value: 3, title: 'Tuesday'),
    S2Choice<int>(value: 4, title: 'Wednesday'),
    S2Choice<int>(value: 5, title: 'Thursday'),
    S2Choice<int>(value: 6, title: 'Friday'),
    S2Choice<int>(value: 7, title: 'Saturday'),
  ];

  Widget? TimeDosesMaker(int doses) {
    Column maker = Column(
      children: [
        DosesTimes(
          doseNumber: 1,
          numOfDoses: doses,
        )
      ],
    );
    for (int i = 1; i < doses; i++)
      maker.children.insert(
          i,
          DosesTimes(
            doseNumber: i + 1,
            numOfDoses: doses,
          ));
    return maker;
  }

  late DatabaseReference _dbref = FirebaseDatabase.instance.ref();
  dbAddDrug(String DrugName, String NumOfPills, String bottleNumber,
      int dosesPerDay) {
    _dbref.child("Drugs").child("$DrugName").child("Name").set(DrugName);
    _dbref
        .child("Drugs")
        .child("$DrugName")
        .child("Number of pills")
        .set(int.parse(NumOfPills));
    _dbref
        .child("Drugs")
        .child("$DrugName")
        .child("Medicine bottle number")
        .set(int.parse(bottleNumber));
    _dbref
        .child("Drugs")
        .child("$DrugName")
        .child("Doses per day")
        .set(dosesPerDay);
    for (int i = 1; i <= dosesPerDay; i++) {
      _dbref
          .child("Drugs")
          .child('$DrugName')
          .child("Doses Times")
          .child("$i")
          .child("Hour")
          .set(DosesTimesValues[i]!.elementAt(0));
      _dbref
          .child("Drugs")
          .child("$DrugName")
          .child("Doses Times")
          .child("$i")
          .child("Minute")
          .set(DosesTimesValues[i]!.elementAt(1));
      _dbref
          .child("Drugs")
          .child("$DrugName")
          .child("Doses Times")
          .child("$i")
          .child("period")
          .set(DosesTimesValues[i]!.elementAt(2));
      _dbref
          .child("Drugs")
          .child("$DrugName")
          .child("Doses Times")
          .child("$i")
          .child("Number of pills")
          .set(DosesTimesValues[i]!.elementAt(3));
      _dbref
          .child("Drugs")
          .child("$DrugName")
          .child("Doses Times")
          .child("$i")
          .child("State")
          .set('Not displayed');
    }
    for (var i in days!)
      _dbref
          .child("Drugs")
          .child('$DrugName')
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
          .set(i);
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
            DosesTimesValues.clear();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => homePage()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        title: Text(
          "Add Drug",
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  buildDrugName(),
                  Visibility(
                      visible: drugNameCheck,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Missing field!',
                          style: TextStyle(color: Colors.red),
                        ),
                      )),
                  SizedBox(height: 15),
                  buildNumberOfPills(),
                  Visibility(
                      visible: numberOfPillsCheck,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Missing field!',
                          style: TextStyle(color: Colors.red),
                        ),
                      )),

                  SizedBox(height: 15),
                  buildMedicineBottleNumber(),
                  Visibility(
                      visible: bottleCheck,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Missing field!',
                          style: TextStyle(color: Colors.red),
                        ),
                      )),

                  SizedBox(height: 15),
                  Container(
                    color: Color(0xFFEEEEEE),
                    child: SmartSelect<int>.single(
                        modalType: S2ModalType.popupDialog,
                        modalStyle: S2ModalStyle(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        selectedValue: dosesPerDay,
                        title: 'Doses per day',
                        choiceItems: Doses,
                        onChange: (state) {
                          setState(() {
                            dosesPerDay = state.value!;
                          });
                        }),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TimeDosesMaker(dosesPerDay)!,
                  Visibility(
                      visible: timeCheck,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'It\'s impossible to have two doses of the same medicine at the same time!',
                          style: TextStyle(color: Colors.red),
                        ),
                      )),
                  Visibility(
                      visible: timeNullCheck,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Please set time!',
                          style: TextStyle(color: Colors.red),
                        ),
                      )),
                  //DosesTimes(),
                  const SizedBox(height: 15),
                  Container(
                    color: Color(0xFFEEEEEE),
                    child: SmartSelect.multiple(
                      modalType: S2ModalType.popupDialog,
                      modalStyle: S2ModalStyle(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      title: 'Days',
                      selectedValue: days,
                      choiceItems: Days,
                      onChange: (state) => setState(() => days = state!.value),
                    ),
                  ),

                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xff44CBB1),
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
                    child: Text(
                      'Save',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => {
                      setState(() {
                        _formKey.currentState?.save();
                        check();
                        print(dosesPerDay);
                        if (!drugNameCheck &&
                            !numberOfPillsCheck &&
                            !bottleCheck &&
                            !timeCheck &&
                            !timeNullCheck) {
                          dbAddDrug(DrugName!, NumberOfPills!,
                              MedicineBottleNumber!, dosesPerDay);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => homePage()),
                              (e) => false);
                        }
                      }),
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool drugNameCheck = false;
  bool numberOfPillsCheck = false;
  bool bottleCheck = false;
  bool timeCheck = false;
  bool timeNullCheck = false;

  void check() {
    if (DrugName == '')
      drugNameCheck = true;
    else
      drugNameCheck = false;
    if (NumberOfPills == '')
      numberOfPillsCheck = true;
    else
      numberOfPillsCheck = false;
    if (MedicineBottleNumber == '')
      bottleCheck = true;
    else
      bottleCheck = false;
    if (times.isNotEmpty)
      for (int i = 0; i < times.length; i++) {
        for (int x = times.length - 1; x > i; x--)
          if (times[i] == times[x] && times[i] != 'a' && times[x] != 'a') {
            timeCheck = true;
            break;
          } else
            timeCheck = false;
        if (timeCheck) break;
      }
    if (DosesTimesValues.isEmpty)
      timeNullCheck = true;
    else
      timeNullCheck = false;
  }

  Widget buildDrugName() {
    return TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            labelText: 'Drug Name', border: OutlineInputBorder()),
        onSaved: (String? value) {
          DrugName = value;
        });
  }

  Widget buildNumberOfPills() {
    return TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: 'Number Of Pills', border: OutlineInputBorder()),
        onSaved: (String? value) {
          NumberOfPills = value.toString();
        });
  }

  Widget buildMedicineBottleNumber() {
    return TextFormField(
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
            labelText: 'Medicine Bottle Number', border: OutlineInputBorder()),
        onSaved: (String? value) {
          MedicineBottleNumber = value.toString();
        });
  }
}

class DosesTimes extends StatefulWidget {
  int doseNumber;
  int numOfDoses;
  DosesTimes({required this.doseNumber, required this.numOfDoses});
  @override
  State<DosesTimes> createState() => _DosesTimesState(doseNumber: doseNumber);
}

class _DosesTimesState extends State<DosesTimes> {
  TimeOfDay? newTime = TimeOfDay(hour: 7, minute: 15);
  int dropdownValue = 1;
  int doseNumber;
  String timeText = 'Add time';
  _DosesTimesState({required this.doseNumber});
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
                DosesTimesValues[doseNumber] = [
                  newTime!.hour,
                  newTime!.minute,
                  newTime!.period.toString().contains('am') ? 'AM' : 'PM',
                  dropdownValue
                ];
                timeText = newTime!.hour.toString() +
                    ':' +
                    newTime!.minute.toString() +
                    ' ' +
                    DosesTimesValues[doseNumber]!.elementAt(2);
              });
            },
            items: <int>[1, 2, 3].map<DropdownMenuItem<int>>((int value) {
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
      DosesTimesValues[doseNumber] = [
        newTime!.hour,
        newTime!.minute,
        newTime!.period.toString().contains('am') ? 'AM' : 'PM',
        dropdownValue
      ];
      timeText = newTime!.hour.toString() +
          ':' +
          newTime!.minute.toString() +
          ' ' +
          DosesTimesValues[doseNumber]!.elementAt(2);
      times[doseNumber - 1] = timeText;
      print(DosesTimesValues.length);
      for (int i = widget.numOfDoses; i < 5; i++) {
        times[i] = 'a';
        DosesTimesValues.remove(i + 1);
      }

      print(times);
      print(DosesTimesValues);
    });
  }
}

List<String> times = ['a', 'a', 'a', 'a', 'a'];
