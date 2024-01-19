import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(const HomeScreen());
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Screen',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const DeleteRedeem(),
    );
  }
}

class DeleteRedeem extends StatefulWidget {
  const DeleteRedeem({
    super.key,
  });

  @override
  State<DeleteRedeem> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<DeleteRedeem> {
  bool isDelete = false;
  @override
  initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }

  bool uploading = false;
  var allData;

  List<String> lis3 = [];
  String selectedShop = "Select Event";
  late List<dynamic> redeemTask;
  late List<dynamic> redeemTask2; //second list for users data

  getData() async {
    CollectionReference collection =
    FirebaseFirestore.instance.collection('Redeem Coins');


    QuerySnapshot snapshot = await collection.get();

    lis3.clear();
    lis3.add("Select Event");

    for (var element in snapshot.docs) {
      Map<String, dynamic>? documentData =
      element.data() as Map<String, dynamic>?;

      if (documentData != null && documentData.containsKey('RedeemCoins')) {
        redeemTask = documentData['RedeemCoins'];

        for (var task in redeemTask) {
          if (task is Map<String, dynamic> && task.containsKey('_event')) {
            lis3.add(task['_event'].toString());
          }
        }
      }
    }



    allData = snapshot.docs.map((doc) => doc.data()).toList();
    return allData;
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,

        body: Container(

            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20), // Add your desired spacing here
              child: FutureBuilder(
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return const Center(child:CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.black54),
                    ));
                  } else {
                    return ListView(
                      children: [
                        Stack(
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(9),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200], // Grey color
                                  borderRadius: BorderRadius.circular(9.0),
                                ),
                                child: TextField(
                                  enabled: false,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(9.0),
                                    ),
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.black12, width: 0.0),
                                      borderRadius: BorderRadius.circular(9.0),
                                    ),
                                    fillColor: Colors.grey[200], // Grey color
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 20, right: 8, bottom: 8),
                              child: DropdownSearch<String>(
                                dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search Event by Name',
                                    fillColor: Colors.grey, // Grey color
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                items: lis3,
                                compareFn: (i, s) => i == s,
                                selectedItem: selectedShop,
                                onChanged: (value) {
                                  selectedShop = value!;
                                  setState(() {});
                                },
                                popupProps: PopupPropsMultiSelection.dialog(
                                  isFilterOnline: true,
                                  showSelectedItems: true,
                                  searchFieldProps: const TextFieldProps(
                                    decoration: InputDecoration(
                                      labelText: 'Search',
                                      prefixIcon: Icon(Icons.search),
                                    ),
                                  ),
                                  showSearchBox: true,
                                  itemBuilder: _customPopupItemBuilderExample2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        uploading
                            ? Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(top: 12),
                          child: const CircularProgressIndicator(
                            valueColor:
                            AlwaysStoppedAnimation(Colors.black54),
                          ),
                        )
                            : const Text(''),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              if (selectedShop != "Select Event") {
                                if (redeemTask[index]["_event"] != selectedShop) {
                                  return const SizedBox(height: 0);
                                } else {
                                  return GestureDetector(
                                    onTap: () async {
                                      await _showDeleteDialog(redeemTask[index]["_event"]);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                      child:
                                      Card(
                                        color: Colors.grey[200], // Light grey color for the card background
                                        // shape: RoundedRectangleBorder(
                                        //   borderRadius: BorderRadius.circular(9.0),
                                        // ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Event: ${redeemTask[index]["_event"]}",
                                                style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                "Off Percentage: ${redeemTask[index]["_percentText"]}",
                                                style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 13,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                "Expiry Date: ${redeemTask[index]["_expText"]}",
                                                style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 13,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                "Brand Icon: ${redeemTask[index]["_icon"]}",
                                                style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 13,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                "For Gems: ${redeemTask[index]["_gemsText"]}",
                                                style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 13,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                "Max Amount: ${redeemTask[index]["_maxText"]}",
                                                style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                return GestureDetector(
                                  onTap: () async {
                                    await _showDeleteDialog(redeemTask[index]["_event"]);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                    child: Card(
                                      color: Colors.grey[100], // Light grey color
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Event: ${redeemTask[index]["_event"]}",
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 6),
                                            Text(
                                              "Off Percentage: ${redeemTask[index]["_percentText"]}",
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 13,
                                              ),
                                            ),
                                            SizedBox(height: 3),
                                            Text(
                                              "Expiry Date: ${redeemTask[index]["_expText"]}",
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                            SizedBox(height: 3),
                                            Text(
                                              "Brand icon: ${redeemTask[index]["_icon"]}",
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 13,
                                              ),
                                            ),
                                            SizedBox(height: 3),
                                            Text(
                                              "For Gems: ${redeemTask[index]["_gemsText"]}",
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 13,
                                              ),
                                            ),


                                            SizedBox(height: 3),
                                            Text(
                                              "Max Amount: ${redeemTask[index]["_maxText"]}",
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                            itemCount: redeemTask.length,
                          ),
                        ),
                      ],
                    );
                  }
                },
                future: getData(),
              ),
            )));
  }

  Future<void> _showDeleteDialog(String taskNameToDelete) async {
    bool isDeleting = false;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Attention'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you really want to delete $taskNameToDelete Event?'),
              ],
            ),
          ),
          actions: <Widget>[
            if (!isDeleting)
              TextButton(
                child: const Text('Delete'),
                onPressed: () async {
                  setState(() {
                    isDeleting = true;
                  });

                  uploading = true;
                  final FirebaseFirestore firestore = FirebaseFirestore.instance;
                  final CollectionReference usersCollection =
                  firestore.collection("Users");
                  final CollectionReference redeemCollection =
                  firestore.collection("Redeem Coins");

                  // Delete from "Redeem Coins" collection
                  QuerySnapshot querySnapshot = await redeemCollection.get();

                  for (QueryDocumentSnapshot documentSnapshot
                  in querySnapshot.docs) {
                    Map<String, dynamic>? userData =
                    documentSnapshot.data() as Map<String, dynamic>?;
                    if (userData!.containsKey("RedeemCoins")) {
                      List<Map<String, dynamic>> updatedRedeemTask = [];

                      for (var task in redeemTask) {
                        if (task is Map<String, dynamic> &&
                            task["_event"] != taskNameToDelete) {
                          updatedRedeemTask.add(task);
                        }
                      }
                      await documentSnapshot.reference
                          .update({"RedeemCoins": updatedRedeemTask});
                    }
                  }

                  // Delete from "Users" collection
                  QuerySnapshot usersQuery = await usersCollection.get();

                  for (QueryDocumentSnapshot doc in usersQuery.docs) {
                    Map<String, dynamic>? documentData =
                    doc.data() as Map<String, dynamic>?;

                    if (documentData != null &&
                        documentData.containsKey('RedeemCoins')) {
                      redeemTask2 = documentData['RedeemCoins'];
                    }

                    Map<String, dynamic>? userData =
                    doc.data() as Map<String, dynamic>?;
                    if (userData!.containsKey("RedeemCoins")) {
                      List<Map<String, dynamic>> updatedRedeemTask2 = [];

                      for (var task in redeemTask2) {
                        if (task is Map<String, dynamic> &&
                            task["_event"] != taskNameToDelete) {
                          updatedRedeemTask2.add(task);
                        }
                      }
                      await doc.reference
                          .update({"RedeemCoins": updatedRedeemTask2});
                    }
                  }

                  Fluttertoast.showToast(
                    msg: "Event Deleted",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black54,
                    textColor: Colors.white,
                    fontSize: 14,
                  );

                  uploading = false;

                  setState(() {
                    isDeleting = false;
                  });

                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            if (isDeleting)
              Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.black54),
                ),
              ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
