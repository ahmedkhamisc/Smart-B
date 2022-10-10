import 'dart:async';
import 'package:flutter/material.dart';
import 'package:awesome_select/awesome_select.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_b/home_page.dart';
import 'package:smart_b/services/firebase&Constants.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:firebase_database/firebase_database.dart';

late Map<int, List> dosesTimesValues;
late List<String> times;

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
    dosesTimesValues = {1:[9,30,'AM',1]};
    times = ['9:30 AM', 'a', 'a', 'a', 'a'];
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
        if(myPillsNumController.text=='-1'){
          myPillsNumController.clear();
        }
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
    times.clear();
    drugNameCheck = false;
    numberOfPillsCheck = false;
    timeCheck = false;
    timeNullCheck = false;
    daysCheck = false;
    saveChangesCheck = false;
    isAppType = true;
    isPillsType = true;
    weekVis=false;
    dayVis=false;
    weeksCheck=false;
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ));
    super.dispose();
  }

  int dosesPerDay = 1;
  int timeBet=0;
  int bottleNumber = 1;
  int checkType = 1;
  int medType=1;
  int schedule=1;
  final DatabaseReference _dbref = FirebaseDatabase.instance.ref();
  final myNameController = TextEditingController();
  final myPillsNumController = TextEditingController();

  bool drugNameCheck = false;
  bool numberOfPillsCheck = false;
  bool timeCheck = false;
  bool timeNullCheck = false;
  bool daysCheck = false;
  bool weeksCheck=false;
  bool saveChangesCheck = false;
  bool isAppType = true;
  bool isPillsType = true;
  bool dayVis=false;
  bool weekVis=false;
  List<S2Choice<int>> doses = [
    S2Choice<int>(value: 1, title: '1 Doses'),
    S2Choice<int>(value: 2, title: '2 Doses'),
    S2Choice<int>(value: 3, title: '3 Doses'),
    S2Choice<int>(value: 4, title: '4 Doses'),
    S2Choice<int>(value: 5, title: '5 Doses'),
  ];
  List<S2Choice<int>> timeBetweenDoses = [
    S2Choice<int>(value: 0, title: 'Custom time'),
    S2Choice<int>(value: 1, title: '1 Hour'),
    S2Choice<int>(value: 2, title: '2 Hours'),
    S2Choice<int>(value: 3, title: '3 Hours'),
    S2Choice<int>(value: 4, title: '4 Hours'),
    S2Choice<int>(value: 5, title: '5 Hours'),
    S2Choice<int>(value: 6, title: '6 Hours'),
    S2Choice<int>(value: 7, title: '7 Hours'),
    S2Choice<int>(value: 8, title: '8 Hours'),
    S2Choice<int>(value: 9, title: '9 Hours'),
    S2Choice<int>(value: 10, title: '10 Hours'),
    S2Choice<int>(value: 11, title: '11 Hours'),
    S2Choice<int>(value: 12, title: '12 Hours'),

  ];
  List<S2Choice<int>> checkTypes = [
    S2Choice<int>(value: 1, title: 'App only'),
    S2Choice<int>(value: 2, title: 'App and Box'),
  ];
  List<S2Choice<int>> type = [
    S2Choice<int>(value: 1, title: 'Pills'),
    S2Choice<int>(value: 2, title: 'Other'),
  ];
  List<S2Choice<int>> bottles = [];
  List<Object?>? days = [1,2,3,4,5,6,7];
  List<Object?>? weeks = [];
  List<S2Choice<int>> Days = [
    S2Choice<int>(value: 1, title: 'Sunday'),
    S2Choice<int>(value: 2, title: 'Monday'),
    S2Choice<int>(value: 3, title: 'Tuesday'),
    S2Choice<int>(value: 4, title: 'Wednesday'),
    S2Choice<int>(value: 5, title: 'Thursday'),
    S2Choice<int>(value: 6, title: 'Friday'),
    S2Choice<int>(value: 7, title: 'Saturday'),
  ];
  List<S2Choice<int>> Weeks = [
    S2Choice<int>(value: 1, title: 'Week 1'),
    S2Choice<int>(value: 2, title: 'Week 2'),
    S2Choice<int>(value: 3, title: 'Week 3'),
    S2Choice<int>(value: 4, title: 'Week 4'),
  ];
  List<S2Choice<int>> scheduleList = [
    S2Choice<int>(value: 1, title: 'Daily'),
    S2Choice<int>(value: 2, title: 'Weekly'),
    S2Choice<int>(value: 3, title: 'Monthly'),
  ];
  Future<void> dbAddDrug(
      {
        required String drugName,
      required String numOfPills,
      required int checkType,
      required int bottleNumber,
      required int dosesPerDay,
      required Map<int, List<dynamic>> dosesVal,
      List<Object?>? daysList,List<Object?>? weeksList}) async {
    if (dosesPerDay <= 0 || dosesTimesValues.isEmpty) {
      return;
    }
    _dbref.child("Drugs").once().then((value) async {
      if (!value.snapshot.hasChild("$drugName") || widget.name != null) {
        if (widget.name != null) {
           _dbref.child("Drugs").child("${widget.name}").remove().then((value) {
             bottlesNumbers.removeWhere((key, value) => key == drugName);
             try {
               _dbref.child("Drugs").child("$drugName").child("Name").set("$drugName").whenComplete(() => _dbref
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
                 _dbref
                     .child("Drugs")
                     .child("$drugName")
                     .child("Notify")
                     .set('not notified').whenComplete(() {
                       if(weeksList.toString()!='[]'){
                         _dbref
                             .child("Drugs")
                             .child("$drugName")
                             .child("Weeks")
                             .set(weeksList.toString()).whenComplete(() {
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
                                                   homePage()),
                                               (e) => false);
                                     }
                                   });
                                 }
                               }
                             })))));

                           }
                         });
                       }else{
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
                                                 homePage()),
                                             (e) => false);
                                   }
                                 });
                               }
                             }
                           })))));}
                       }
                 });

               })))));
             } catch (e) {
               print(e);
             }
           });
        }else{
          try {
            _dbref.child("Drugs").child("$drugName").child("Name").set("$drugName").whenComplete(() => _dbref
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
              _dbref
                  .child("Drugs")
                  .child("$drugName")
                  .child("Notify")
                  .set('not notified').whenComplete(() {
                if(weeksList.toString()!='[]'){
                  _dbref
                      .child("Drugs")
                      .child("$drugName")
                      .child("Weeks")
                      .set(weeksList.toString()).whenComplete(() {
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
                                            homePage()),
                                        (e) => false);
                              }
                            });
                          }
                        }
                      })))));

                    }
                  });
                }else{
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
                                          homePage()),
                                      (e) => false);
                            }
                          });
                        }
                      }
                    })))));}
                }
              });

            })))));
          } catch (e) {
            print(e);
          }
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
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle:
            const SystemUiOverlayStyle(
              statusBarColor: Color(0xFF44CBB1),
              statusBarIconBrightness: Brightness.dark,
            ),
        leading: IconButton(
          icon:const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                    homePage()),
                    (e) => false);
          },
        ),
        title: Text(
          widget.name == null ? 'Add Med' : 'Edit Med',
          style:  const TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: size.height*0.04,horizontal: size.width*0.05),
            child: Column(
              children: <Widget>[
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
                            isPillsType = true;
                            myPillsNumController.clear();
                            medType=1;
                          }
                        });
                      }),
                ),
                Visibility(
                    visible:isAppType,child: SizedBox(height: size.height*0.02)),
                Visibility(
                  visible: isAppType,
                  child: Container(
                    color: const Color(0xFFEEEEEE),
                    child: SmartSelect<int>.single(
                        modalType: S2ModalType.popupDialog,
                        modalStyle: S2ModalStyle(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        selectedValue: medType,
                        title: 'Medicine type',
                        choiceItems: type,
                        onChange: (state) {
                          setState(() {
                            medType = state.value!;
                            if (state.value == 1) {
                              isPillsType = true;
                              myPillsNumController.clear();
                            } else {
                              isPillsType = false;
                              myPillsNumController.text='-1';
                            }
                          });
                        }),
                  ),
                ),
                SizedBox(height: size.height*0.02),
                Visibility(
                  visible: !isAppType,
                  child: Container(
                    margin:  EdgeInsets.only(bottom: size.height*0.02),
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
                          timeBetweenDoses=[
                            S2Choice<int>(value: 0, title: 'Custom time'),
                            S2Choice<int>(value: 1, title: '1 Hour'),
                            S2Choice<int>(value: 2, title: '2 Hours'),
                            S2Choice<int>(value: 3, title: '3 Hours'),
                            S2Choice<int>(value: 4, title: '4 Hours'),
                          ];
                          int count=5;
                          while(count*dosesPerDay<=24){
                            timeBetweenDoses.insert(count,S2Choice<int>(value: count, title: '$count Hours'));
                            count++;
                          }
                          if(dosesPerDay>1&&timeBet>0){
                            for(int i=2;i<=dosesPerDay;i++){
                              int temp=dosesTimesValues[i-1]![0]+timeBet;
                              int hours=temp<=23?temp:temp-24;
                              dosesTimesValues[i]=[hours,dosesTimesValues[i-1]![1],hours>=12?'PM':'AM',dosesTimesValues[i-1]![3]];
                            }
                            print('hhh'+dosesTimesValues.toString());
                          }
                        });
                      }),
                ),
                SizedBox(height: size.height*0.02),
                Visibility(
                  visible: dosesPerDay==1?false:true,
                  child: Container(
                    color: const Color(0xFFEEEEEE),
                    child: SmartSelect<int>.single(
                        modalType: S2ModalType.popupDialog,
                        modalStyle: S2ModalStyle(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        selectedValue: timeBet,
                        title: 'Time between doses',
                        choiceItems: timeBetweenDoses,
                        onChange: (state) {
                          setState(() {
                            timeBet = state.value!;

                            if(dosesPerDay>1&&timeBet>0){
                              for(int i=2;i<=dosesPerDay;i++){
                                int temp=dosesTimesValues[i-1]![0]+timeBet;
                                int hours=temp<=23?temp:temp-24;
                                dosesTimesValues[i]=[hours,dosesTimesValues[i-1]![1],hours>=12?'PM':'AM',dosesTimesValues[i-1]![3]];
                              }
                              print('hhh'+dosesTimesValues.toString());
                            }
                          });
                        }),
                  ),
                ),
                Visibility(
                    visible: dosesPerDay==1?false:true,
                    child: SizedBox(height: size.height*0.02)),
                timeDosesMaker(doses: dosesPerDay,timeBet: timeBet)!,
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
                SizedBox(height: size.height*0.02),
                Container(
                  color: const Color(0xFFEEEEEE),
                  child: SmartSelect<int>.single(
                      modalType: S2ModalType.popupDialog,
                      modalStyle: S2ModalStyle(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      selectedValue: schedule,
                      title: 'Schedule',
                      choiceItems: scheduleList,
                      onChange: (state) {
                        setState(() {
                          int val=state.value!;
                          switch(val){
                            case 1:
                              {
                                dayVis=false;
                                weekVis=false;
                                weeksCheck=false;
                                daysCheck=false;
                                if(weeks!=[]){
                                  weeks=[];
                                }
                                days=[1,2,3,4,5,6,7];
                            }
                              break;
                            case 2:
                              {
                                if(weeks!=[]){
                                  weeks=[];
                                }
                                dayVis=true;
                                weeksCheck=false;
                              }
                              break;
                            case 3:
                              {
                                if(weeks!=[]){
                                  weeks=[];
                                }
                                weekVis=true;
                                dayVis=true;
                              }
                              break;
                          }
                        });
                      }),
                ),
                Visibility(visible:weekVis,child: SizedBox(height: size.height*0.02)),
                Visibility(
                  visible: weekVis,
                  child: Container(
                    color: const Color(0xFFEEEEEE),
                    child: SmartSelect.multiple(
                      modalType: S2ModalType.popupDialog,
                      modalStyle: S2ModalStyle(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      title: 'Weeks',
                      selectedValue: weeks,
                      choiceItems: Weeks,
                      onChange: (state) => setState(() {
                        weeks = state!.value;
                      }),
                    ),
                  ),
                ),
                Visibility(
                    visible: weeksCheck,
                    child: const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Please set at least one week!',
                        style: TextStyle(color: Colors.red),
                      ),
                    )),
                Visibility(visible:dayVis,child: SizedBox(height: size.height*0.02)),
                Visibility(
                  visible: dayVis,
                  child: Container(
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
                SizedBox(height: size.height*0.02),
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
                Visibility(visible:isPillsType,child: SizedBox(height: size.height*0.02)),
                Visibility(
                    visible: isPillsType,
                    child: buildNumberOfPills()),
                Visibility(
                    visible: numberOfPillsCheck&&isPillsType,
                    child: const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Missing field!',
                        style: TextStyle(color: Colors.red),
                      ),
                    )),
                SizedBox(height: size.height*0.035),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: const Color(0xff44CBB1),
                      padding:  EdgeInsets.symmetric(
                          horizontal: size.width * 0.15, vertical: size.height * 0.025)),
                  child:  const Text(
                    'Save',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => {
                    setState(() {
                      check(timeDosesMaker(doses: dosesPerDay,timeBet: timeBet)!.children.length);
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
                                  !daysCheck&&!weeksCheck)
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
                                      daysList: days,weeksList: weeks)
                                }
                            }
                        });
                      } else {
                        if (dosesTimesValues != {}) {
                          if (!drugNameCheck &&
                              !numberOfPillsCheck &&
                              !timeCheck &&
                              !timeNullCheck &&
                              !daysCheck &&
                              !saveChangesCheck&&!weeksCheck) {
                            dbAddDrug(
                                drugName: myNameController.text.trim(),
                                numOfPills:
                                myPillsNumController.text.trim(),
                                checkType: checkType,
                                bottleNumber: isAppType ? 0 : bottleNumber,
                                dosesPerDay: dosesPerDay,
                                dosesVal: dosesTimesValues,
                                daysList: days,weeksList: weeks);
                          }
                        } else {
                          print(dosesTimesValues);
                        }
                      }
                    }),
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  TimelineTile dosesTimes({required int hours, required int doseNumber, required int dosesPerDay,String? drugName,required bool isPillsType}){
    String timeText =dosesTimesValues.containsKey(doseNumber)?'${dosesTimesValues[doseNumber]!.elementAt(0)}:${dosesTimesValues[doseNumber]!.elementAt(1)} ${dosesTimesValues[doseNumber]!.elementAt(2)}' :'Add time';
    int dropdownValue = 1;
    return TimelineTile(
    beforeLineStyle: LineStyle(color: const Color(0xFFEEEEEE), thickness: size.width*0.01),
    afterLineStyle: LineStyle(color: const Color(0xFFEEEEEE), thickness: size.width*0.01),
    indicatorStyle: IndicatorStyle(
      width: size.width*0.03,
      color: const Color(0xFF44CBB1),
    ),
    endChild: Row(
      children: [
        TextButton(
            onPressed: () {
              showClock(hours: timeBet,doseNumber: doseNumber,dropdownValue: dropdownValue,dosesPerDay: dosesPerDay);
            },
            child: Container(
              height: size.height*0.04,
              width: size.width*0.23,
              color: const Color(0xFFEEEEEE),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        timeText,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width*0.005,
                    ),
                    Icon(
                      Icons.more_time,
                      color: Colors.grey,
                      size: size.height*size.width*0.00006,
                    )
                  ],
                ),
              ),
            )),
        SizedBox(
          width:size.width*0.1,
        ),
        Visibility(visible:isPillsType,child  : const Text('Pills:   ')),
        Visibility(
          visible: isPillsType,
          child: dropDown(doseNumber: doseNumber),
        ),
      ],
    ),
  );
}
  Future<void> showClock({required int hours,required int doseNumber,required int dropdownValue,required int dosesPerDay}) async{
  TimeOfDay? newTime= await showTimePicker(
      context: context,
      initialTime:const TimeOfDay(hour: 9, minute: 30),
    );
  String timeText='add';
    if(hours>0&&doseNumber==1){
      setState(() {
        dosesTimesValues[doseNumber] = [
          newTime!.hour,
          newTime!.minute,
          newTime!.period.toString().contains('am') ? 'AM' : 'PM',
          dropdownValue
        ];
        timeText = '${dosesTimesValues[doseNumber]!.elementAt(0)}:${dosesTimesValues[doseNumber]!.elementAt(1)} ${dosesTimesValues[doseNumber]!.elementAt(2)}';
        for(int i=2;i<=dosesPerDay;i++){
          int temp=dosesTimesValues[i-1]![0]+hours;
          int hourss=temp<=23?temp:temp-24;
          dosesTimesValues[i]=[hourss,dosesTimesValues[i-1]![1],hourss>=12?'PM':'AM',dosesTimesValues[i-1]![3]];
        }
      });
    }else{
      setState(() {
        dosesTimesValues[doseNumber] = [
          newTime!.hour,
          newTime!.minute,
          newTime!.period.toString().contains('am') ? 'AM' : 'PM',
          dropdownValue
        ];
        timeText = '${dosesTimesValues[doseNumber]!.elementAt(0)}:${dosesTimesValues[doseNumber]!.elementAt(1)} ${dosesTimesValues[doseNumber]!.elementAt(2)}' ;
        times[doseNumber - 1] = timeText;
        print(times);
        //print(DosesTimesValues.length);
        for (int i = dosesPerDay; i < 5; i++) {
          times[i] = 'a';
          dosesTimesValues.remove(i + 1);
        }
      });

    }

  }

  Column? timeDosesMaker({required int doses,required int timeBet}) {
    Column maker;
    if (widget.name != null) {
      maker = Column(
        children: [
          dosesTimes(
            hours: timeBet,
            isPillsType: isPillsType,
            doseNumber: 1,
            dosesPerDay: doses,
            drugName: widget.name
          )
        ],
      );
      for (int i = 1; i < doses; i++) {
        maker.children.insert(
            i,
            dosesTimes(
              hours: timeBet,
              isPillsType: isPillsType,
              doseNumber: i + 1,
              dosesPerDay: doses,
                drugName: widget.name
            ));
      }
    } else {
      maker = Column(
        children: [
          dosesTimes(
            hours: timeBet,
            isPillsType: isPillsType,
            doseNumber: 1,
            dosesPerDay: doses,
          )
        ],
      );
      for (int i = 1; i < doses; i++) {
        maker.children.insert(
            i,
            dosesTimes(
              hours: timeBet,
              isPillsType: isPillsType,
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
    } else if(myPillsNumController.text =='-1'){
      numberOfPillsCheck = false;
      isPillsType=false;
    }else{
      numberOfPillsCheck = false;
    }
    if (times.isNotEmpty) {
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

    if(weeks==null||weeks.toString()=='[]'&&weekVis&&dayVis){
      weeksCheck=true;
    }
    else{
      weeksCheck=false;
    }
  }

  Widget buildDrugName() {
    return TextFormField(
        controller: myNameController,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
            labelText: 'Drug Name', border: OutlineInputBorder()));
  }

  Widget buildNumberOfPills() {
    return TextFormField(
      controller: myPillsNumController,
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: const InputDecoration(
          labelText: 'Number Of Pills', border: OutlineInputBorder()),
    );
  }
}
class dropDown extends StatefulWidget {
  dropDown({Key? key,required this.doseNumber}) : super(key: key);
  int doseNumber;
  @override
  State<dropDown> createState() => _dropDownState();
}

class _dropDownState extends State<dropDown> {
  int dropdownValue=1;
  @override
  Widget build(BuildContext context) {
    print(dropdownValue);
    return DropdownButton<int>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      onChanged: (int? newValue) {
        setState(() {
          dropdownValue = newValue!;
          dosesTimesValues[widget.doseNumber]![3]=newValue;
          print(dosesTimesValues);

        });
      },
      items: <int>[1, 2, 3, 4, 5]
          .map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }
}


