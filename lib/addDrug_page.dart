import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:awesome_select/awesome_select.dart';
import 'package:smart_b/home_page.dart';
import 'package:timeline_tile/timeline_tile.dart';

class addDrugPage extends StatefulWidget {
  const addDrugPage({Key? key}) : super(key: key);

  @override
  State<addDrugPage> createState() => _addDrugPageState();
}

class _addDrugPageState extends State<addDrugPage> {
  String? DrugName;
  String? NumberOfPills;
  String? MedicineBottleNumber;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int selectedValue = 1;
  List<S2Choice<int>> Doses = [
    S2Choice<int>(value: 1, title: '1 Doses'),
    S2Choice<int>(value: 2, title: '2 Doses'),
    S2Choice<int>(value: 3, title: '3 Doses'),
    S2Choice<int>(value: 4, title: '4 Doses'),
    S2Choice<int>(value: 5, title: '5 Doses'),
  ];
  List<Object?>? value = [1];
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
      children: [],
    );
    for (int i = 0; i < doses; i++) maker.children.insert(i, DosesTimes());
    return maker;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => homePage()),
            (Route<dynamic> route) => false,
          ),
        ),
        title: Text(
          "Add Drug",
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  buildDrugName(),
                  SizedBox(height: 15),
                  buildNumberOfPills(),
                  SizedBox(height: 15),
                  buildMedicineBottleNumber(),
                  SizedBox(height: 15),
                  Container(
                    color: Color(0xFFEEEEEE),
                    child: SmartSelect<int>.single(
                        modalType: S2ModalType.popupDialog,
                        modalStyle: S2ModalStyle(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        selectedValue: selectedValue,
                        title: 'Doses per day',
                        choiceItems: Doses,
                        onChange: (state) {
                          setState(() {
                            selectedValue = state.value!;
                          });
                        }),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TimeDosesMaker(selectedValue)!,

                  //DosesTimes(),
                  SizedBox(height: 15),
                  Container(
                    color: Color(0xFFEEEEEE),
                    child: SmartSelect.multiple(
                      modalType: S2ModalType.popupDialog,
                      modalStyle: S2ModalStyle(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      title: 'Days',
                      selectedValue: value,
                      choiceItems: Days,
                      onChange: (state) => setState(() => value = state!.value),
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
                    onPressed: () => {_formKey.currentState?.save()},
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDrugName() {
    return TextFormField(
        decoration: InputDecoration(
            labelText: 'Drug Name', border: OutlineInputBorder()),
        onSaved: (String? value) {
          DrugName = value;
        });
  }

  Widget buildNumberOfPills() {
    return TextFormField(
        decoration: InputDecoration(
            labelText: 'Number Of Pills', border: OutlineInputBorder()),
        onSaved: (String? value) {
          NumberOfPills = value;
        });
  }

  Widget buildMedicineBottleNumber() {
    return TextFormField(
        decoration: const InputDecoration(
            labelText: 'Medicine Bottle Number', border: OutlineInputBorder()),
        onSaved: (String? value) {
          MedicineBottleNumber = value;
        });
  }
}

class DosesTimes extends StatefulWidget {
  const DosesTimes({Key? key}) : super(key: key);

  @override
  State<DosesTimes> createState() => _DosesTimesState();
}

class _DosesTimesState extends State<DosesTimes> {
  TimeOfDay? newTime;
  int dropdownValue = 1;

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
                    children: const [
                      Text(
                        'HH:MM',
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
  }
}
