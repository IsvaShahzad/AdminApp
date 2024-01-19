import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'UserHistory.dart';

void main() {
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
      home: const Users(),
    );
  }
}

class Users extends StatefulWidget {
  const Users({
    super.key,
  });

  @override
  State<Users> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Users> {
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
  String selectedUser = "Select User";
  late List<dynamic> dailyTasks;
  getData() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('Users');

    QuerySnapshot snapshot = await collection.get();
    lis3.clear();
    lis3.add("Select User");
    for (var element in snapshot.docs) {
      lis3.add(element['name']);
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
        // subtitle: Text(item.createdAt.toString()),
        // leading: CircleAvatar(
        //   backgroundImage: NetworkImage(item.avatar),
        // ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              print('snapshot data ${snapshot.data}');
              if (snapshot.data == null) {
                return const Center(
                    child: CircularProgressIndicator(
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
                          child: TextField(
                            enabled: false,
                            readOnly: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    0.0), // Adjust the circular value
                              ),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black12, width: 0.0),
                                borderRadius: BorderRadius.circular(
                                    0.0), // Adjust the circular value
                              ),
                              labelText: 'Users',
                              fillColor: Colors.white70,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
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
                                hintText: 'Search User by Name',
                                fillColor: Colors.white70,
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                            items: lis3,
                            compareFn: (i, s) => i == s,
                            selectedItem: selectedUser,
                            onChanged: (value) {
                              selectedUser = value!;
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
                    Container(
                      height: MediaQuery.of(context)
                          .size
                          .height, // or set a specific height

                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserHistory(
                                    email: snapshot.data[index]['email'],
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Card(
                                color: Colors.grey[
                                    200], // Light grey color for the card background
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "User: ${snapshot.data[index]['name']}",
                                        style: TextStyle(
                                          color: Colors.grey[
                                              700], // Light grey color for the text
                                          fontSize: 14, // Adjust the font size
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Email: ${snapshot.data[index]['email']}",
                                        style: TextStyle(
                                          color: Colors.grey[
                                              700], // Light grey color for the text
                                          fontSize: 12, // Adjust the font size
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Gems: ${snapshot.data[index]['gems']}",
                                        style: TextStyle(
                                          color: Colors.grey[
                                              700], // Light grey color for the text
                                          fontSize: 12, // Adjust the font size
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Level: ${snapshot.data[index]['level']}",
                                        style: TextStyle(
                                          color: Colors.grey[
                                              700], // Light grey color for the text
                                          fontSize: 12, // Adjust the font size
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: snapshot.data.length,
                      ),
                    )
                  ],
                );
              }
            },
            future: getData(),
          ),
        ));
  }

  // Future<void> _showMyDialog(String taskNameToDelete) async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Attention'),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               Text('Do you really want to delete $taskNameToDelete Task?'),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('Delete'),
  //             onPressed: () async {
  //               uploading = true;
  //               final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //               final CollectionReference usersCollection =
  //                   firestore.collection("Users");
  //
  //               QuerySnapshot querySnapshot = await usersCollection.get();
  //
  //               for (QueryDocumentSnapshot documentSnapshot
  //                   in querySnapshot.docs) {
  //                 // List<dynamic> dailyTasks = List.from(documentSnapshot["DailyTasks"]);
  //
  //                 List<Map<String, dynamic>> updatedDailyTasks = [];
  //                 for (var task in dailyTasks) {
  //                   if (task is Map<String, dynamic> &&
  //                       task["taskName"].toString().trim() !=
  //                           taskNameToDelete.toString().trim()) {
  //                     updatedDailyTasks.add(task);
  //                   }
  //                 }
  //
  //                 await documentSnapshot.reference
  //                     .update({"DailyTasks": updatedDailyTasks});
  //               }
  //
  //               // final forCategory=FirebaseFirestore.instance.collection
  //               //   ("Users");
  //               // await forCategory.doc('user1').delete();
  //
  //               Fluttertoast.showToast(
  //                 msg: "Task Deleted",
  //                 toastLength: Toast.LENGTH_SHORT,
  //                 gravity: ToastGravity.BOTTOM,
  //                 timeInSecForIosWeb: 1,
  //                 backgroundColor: Colors.black54,
  //                 textColor: Colors.white,
  //                 fontSize: 14,
  //               );
  //               uploading = false;
  //               Navigator.of(context).pop();
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: const Text('Cancel'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
