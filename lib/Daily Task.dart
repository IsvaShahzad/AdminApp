import 'dart:async';

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const HomeScreen());
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Screen',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const DailyTask(),
    );
  }
}

class DailyTask extends StatefulWidget {
  const DailyTask({super.key});

  @override
  State<DailyTask> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<DailyTask> {
  TextEditingController experienceController = TextEditingController();
  TextEditingController taskNameController = TextEditingController();
  TextEditingController hoursController = TextEditingController();
  TextEditingController secondsController = TextEditingController();

  bool showSpinner = false;

  @override
  initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.black54;
    }
    return Colors.grey;
  }

  List<String> list = ['Play Task', 'Cash Task'];

  List<String> list2 = [
    'Convert Gems',
    'Perform Transaction',
    'Collect NFT Trait',
    'Buy NFT Trait'
  ];
  String selectedType = "Select Task Type";
  String selectedTask = "Select Task";

  Widget _customPopupItemBuilderExample2(
      BuildContext context, String item, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item),
      ),
    );
  }
  
  bool isChecked = false;
  bool isPlay = false;
  bool isCash = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12,top: 60),
                            child: Text(
                              'Task Type',
                              style: TextStyle(
                                color: Colors.grey[700], // Set light grey color for the icon
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(9),
                            child: TextField(
                              enabled: false,
                              readOnly: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(9.0),
                                ),
                                filled: true,
                                fillColor: Colors.grey[100], // Light grey color
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                     width: 1.0),
                                  borderRadius: BorderRadius.circular(9.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05,
                          vertical: MediaQuery.of(context).size.height * 0.1,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                        SizedBox(height: 24),  // Adjust spacing between label and DropdownSearch
                        DropdownSearch<String>(
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Select Task Type',
                              fillColor: Colors.white70,
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                          items: list,
                          compareFn: (i, s) => i == s,
                          selectedItem: selectedType,
                          onChanged: (value) {
                            selectedType = value!;
                            setState(() {
                              if (selectedType == 'Play Task') {
                                isCash = false;
                                isPlay = true;
                              } else if (selectedType == 'Cash Task') {
                                isPlay = false;
                                isCash = true;
                              }
                            });
                          },
                          popupProps: PopupPropsMultiSelection.dialog(
                            isFilterOnline: true,
                            showSelectedItems: true,
                            searchFieldProps: const TextFieldProps(
                              decoration: InputDecoration(
                                labelText: 'Task Type', // Set search text
                                prefixIcon:
                                    Icon(Icons.search), // Set search icon
                              ),
                            ),
                            showSearchBox: true,
                            itemBuilder: _customPopupItemBuilderExample2,
                          ),
                        ),
                      ]),
        )],
                  ),
                  isCash
                      ?
                  Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12, bottom: 0, top: 10),
                            child: Text(
                              'Task Name',
                              style: TextStyle(
                                color: Colors.grey[700], // Set light grey color for the icon
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(9),
                            child: TextField(
                              enabled: false,
                              readOnly: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(9.0),
                                ),
                                filled: true,
                                fillColor: Colors.grey[100], // Light grey color
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(9.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            top: 45, left: 20, right: 8, bottom: 8),
                        child: DropdownSearch<String>(
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              border: InputBorder.none,
                              // labelText: 'Select Country',
                              hintText: 'Select Task Name',
                              fillColor: Colors.white70,
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                          items: list2,
                          compareFn: (i, s) => i == s,
                          selectedItem: selectedTask,
                          onChanged: (value) {
                            selectedTask = value!;
                            setState(() {});
                          },
                          popupProps: PopupPropsMultiSelection.dialog(
                            isFilterOnline: true,
                            showSelectedItems: true,
                            searchFieldProps: const TextFieldProps(
                              decoration: InputDecoration(
                                labelText: 'Task Name', // Set search text
                                prefixIcon:
                                Icon(Icons.search), // Set search icon
                              ),
                            ),
                            showSearchBox: true,
                            itemBuilder: _customPopupItemBuilderExample2,
                          ),
                        ),
                      ),
                    ],
                  )
                      : SizedBox(
                          height: 0,
                        ),
                  isPlay
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              child: Text(
                                'Enter Play Hours',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,// Set light grey color for the icon


                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(9),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: hoursController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(9.0),
                                  ),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.black12,
                                      width: 0.0,
                                    ),
                                    borderRadius: BorderRadius.circular(9.0),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal:
                                          10), // Adjust the padding as needed
                                  hintText: 'Enter Play Hours',
                                  fillColor: Colors.grey[100],
                                  // suffixIcon: const Icon(
                                  //   CupertinoIcons.profile_circled,
                                  //   color: Colors.grey,
                                  // ),
                                ),
                              ),
                            )
                          ],
                        )
                      : SizedBox(
                          height: 15,
                        ),
                  isPlay
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              child: Text(

                                'Experience',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,// Set light grey color for the icon

                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(9),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: experienceController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(9.0),
                                  ),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.black12,
                                      width: 0.0,
                                    ),
                                    borderRadius: BorderRadius.circular(9.0),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal:
                                          12), // Adjust the padding as needed
                                  hintText: 'Enter Experience Gain',
                                  fillColor: Colors.grey[100],
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  // suffixIcon: const Icon(
                                  //   CupertinoIcons.p,
                                  //   color: Colors.grey,
                                  // ),
                                ),
                              ),
                            )
                          ],
                        )
                      : const SizedBox(
                          height: 0,
                        ),
                  isCash
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              child: Text(
                                'Experience',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,// Set light grey color for the icon

                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(9),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: experienceController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(9.0),
                                  ),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.black12,
                                      width: 0.0,
                                    ),
                                    borderRadius: BorderRadius.circular(9.0),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal:
                                          12), // Adjust the padding as needed
                                  hintText: 'Enter Experience Gain',
                                  fillColor: Colors.grey[100],
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  // suffixIcon: const Icon(
                                  //   CupertinoIcons.p,
                                  //   color: Colors.grey,
                                  // ),
                                ),
                              ),
                            )
                          ],
                        )
                      : const SizedBox(
                          height: 0,
                        ),
                  isPlay
                      ? Padding(
                          padding: const EdgeInsets.all(9),
                          child: Row(
                            // mainAxisAlignment:MainAxisAlignment.end,
                            children: [
                              Checkbox(
                                  checkColor: Colors.white,
                                  fillColor: MaterialStateProperty.resolveWith(
                                      getColor),
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked = value!;
                                    });
                                  }),
                              const Text(
                                'Is Premium',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 11),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(
                          height: 0,
                        ),
                  isCash
                      ? Padding(
                          padding: const EdgeInsets.all(9),
                          child: Row(
                            // mainAxisAlignment:MainAxisAlignment.end,
                            children: [
                              Checkbox(
                                  checkColor: Colors.white,
                                  fillColor: MaterialStateProperty.resolveWith(
                                      getColor),
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked = value!;
                                    });
                                  }),
                              const Text(
                                'Is Premium',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 11),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(
                          height: 25,
                        ),

                  showSpinner
                      ? SingleChildScrollView(
                    child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 2),
                        child: const CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation(Colors.black54),
                        )),
                  )
                      : Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    width: 170,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (selectedType != "Select Task Type") {
                          setState(() {
                            showSpinner = true; // Show the spinner
                          });

                          if (selectedType == "Play Task") {
                            if (experienceController.text.toString().isNotEmpty &&
                                hoursController.text.toString().isNotEmpty) {
                              await Future.delayed(Duration(seconds: 2)); // Simulate a delay
                              await saveItemInfo('play');
                            }
                          } else if (selectedType == "Cash Task") {
                            if (experienceController.text.toString().isNotEmpty &&
                                selectedTask != "Select Task") {
                              await Future.delayed(Duration(seconds: 2)); // Simulate a delay
                              await saveItemInfo('cash');
                            }
                          } else {
                            Fluttertoast.showToast(
                              msg: 'Incomplete Information',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black54,
                              textColor: Colors.white,
                              fontSize: 14,
                            );
                          }

                          setState(() {
                            showSpinner = false; // Hide the spinner
                          });
                        }
                      },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.0)),
                              primary: Color(0xFF9370DB),
                            ),
                            child: const Text(
                              "Add",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                ],
              ),
            ],
          ),
        ));
  }

  saveItemInfo(String type) async {
    final dailyCollection =
        FirebaseFirestore.instance.collection("Daily Tasks");
    final usersCollection = FirebaseFirestore.instance.collection("Users");

    Map<String, dynamic> dailyTaskData = {};

    try {
      if (type == "cash") {
        dailyTaskData = {
          "taskName": selectedTask,
          "experience": experienceController.text.toString(),
          "_isPremium": isChecked,
          "_isProgress": false,
          "_isCompleted": false,
          "icon": "cash",
          "hours": 0,
          "seconds": 0,
          "taskProgress": 0,
        };
      } else {
        dailyTaskData = {
          "taskName": "Play for ${hoursController.text.toString()} hours",
          "experience": experienceController.text.toString(),
          "_isPremium": isChecked,
          "_isProgress": true,
          '_isCompleted': false,
          'icon': "play",
          'hours': int.parse(hoursController.text.toString()),
          'taskProgress': 0,
          'seconds': 0,
        };
      }

      // Adding the daily task data to the "Daily Task" collection with document name "tasks"
      await dailyCollection.doc("tasks").set({
        "DailyTasks": FieldValue.arrayUnion([dailyTaskData]),
      }, SetOptions(merge: true));
      print(
          "Daily Task added to Daily Task collection with document name 'tasks' successfully!");

      // Add this setState block
      setState(() {
        hoursController.clear();
        experienceController.clear();
        isChecked = false;
        showSpinner = false;
        isCash = false;
        isPlay = false;
        selectedType = "Select Task Type";
        selectedTask = "Select Task";
        Fluttertoast.showToast(
          msg: "Daily Task Added",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 14,
        );
      });
    } catch (e) {
      print("Error adding Daily Task to Daily Task collection: $e");
    }

    // await usersCollection.doc("tasks").set({
    //   "DailyTasks": FieldValue.arrayUnion([dailyTaskData]),
    // }, SetOptions(merge: true));

    CollectionReference collection =
        FirebaseFirestore.instance.collection('Users');

    QuerySnapshot snapshot = await collection.get();
    for (var element in snapshot.docs) {
      await usersCollection.doc(element['email']).set({
        "DailyTasks": FieldValue.arrayUnion([dailyTaskData]),
      }, SetOptions(merge: true));
    }

    // QuerySnapshot usersQuery = await usersCollection.get();
    // for (QueryDocumentSnapshot doc in usersQuery.docs) {
    //   for (QueryDocumentSnapshot doc in usersQuery.docs) {

    // try {
    //   await doc.reference.update({
    //     "DailyTasks": FieldValue.arrayUnion([dailyTaskData]), //delete
    //   });
    //   print("Document updated successfully!");
    // } catch (e) {
    //experinc
    //   print("Error updating document: $e");
    // }
    // }
    // }
  }
}
