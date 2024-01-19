import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(const HomeScreen());
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
      home: const Delete(),
    );
  }
}

class Delete extends StatefulWidget {
  const Delete({Key? key}) : super(key: key);

  @override
  State<Delete> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Delete> {
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
  String selectedShop = "Select Task";
  late List<dynamic> dailyTasks;

  getData() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('Daily Tasks');

    QuerySnapshot snapshot = await collection.get();
    lis3.clear();
    lis3.add("Select Task");

    for (var element in snapshot.docs) {
      Map<String, dynamic>? documentData =
          element.data() as Map<String, dynamic>?;
      if (documentData != null && documentData.containsKey('DailyTasks')) {
        dailyTasks = documentData['DailyTasks'];

        for (var task in dailyTasks) {
          if (task is Map<String, dynamic> && task.containsKey('taskName')) {
            lis3.add(task['taskName'].toString());
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

          child: FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              print('snapshot data ${snapshot.data}');
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.black54),
                  ),
                );
              } else {
                return ListView(
                  children: [
                    Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12, bottom: 0, top: 60),
                              child: Text('Daily Task',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
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
                          padding: const EdgeInsets.only(
                              top: 95, left: 20, right: 8, bottom: 8),
                          child: DropdownSearch<String>(
                            dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search Task by Name',
                                fillColor: Colors.white70,
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
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child:ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (selectedShop != "Select Task") {
                            if (dailyTasks[index]["taskName"] != selectedShop) {
                              return const SizedBox(height: 0);
                            } else {
                              return GestureDetector(
                                onTap: () async {
                                  await _showMyDialog(dailyTasks[index]["taskName"]);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                                  child: Card(
                                    color: Colors.grey[100], // Light grey color

                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0), // Square corners
                                    ),
                                    child: Container(
                                      height: 100, // Increased height
                                      padding: const EdgeInsets.all(10),

                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            dailyTasks[index]["taskName"],
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 9),
                                          Text(
                                            "Experience: ${dailyTasks[index]["experience"]}",
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            "Task Type: ${dailyTasks[index]["icon"]}",
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14,
                                            ),
                                          ),
                                          if (dailyTasks[index]["_isPremium"] == true)
                                            Text(
                                              "Premium Task",
                                              style: const TextStyle(
                                                color: Colors.purple,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
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
                                await _showMyDialog(dailyTasks[index]["taskName"]);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                                child: Card(
                                  color: Colors.grey[100], // Light grey color

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0), // Square corners
                                  ),
                                  child: Container(
                                    height: 100, // Increased height
                                    padding: const EdgeInsets.all(10),

                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          dailyTasks[index]["taskName"],
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 9),
                                        Text(
                                          "Experience: ${dailyTasks[index]["experience"]}",
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          "Task Type: ${dailyTasks[index]["icon"]}",
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12,
                                          ),
                                        ),
                                        if (dailyTasks[index]["_isPremium"] == true)
                                          Text(
                                            "Premium Task",
                                            style: const TextStyle(
                                              color: Colors.purple,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
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
                        itemCount: dailyTasks.length,
                      ),
                    ),
                  ],
                );
              }
            },
            future: getData(),
          ),
        ));
  }

  Future<void> _showMyDialog(String taskNameToDelete) async {
    bool isDeleting = false;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Stack(
          children: [
            AlertDialog(
              title: const Text('Attention'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Do you really want to delete $taskNameToDelete Task?'),
                  ],
                ),
              ),
              actions: <Widget>[
                isDeleting
                    ? CircularProgressIndicator(
                )
                    : TextButton(
                  child: const Text('Delete'),
                  onPressed: () async {
                    setState(() {
                      isDeleting = true;
                    });
                    uploading = true;
                    final FirebaseFirestore firestore =
                        FirebaseFirestore.instance;
                    final CollectionReference usersCollection =
                    firestore.collection("Users");
                    final CollectionReference dailyCollection =
                    firestore.collection("Daily Tasks");

                    // Fetch the current "task" document
                    DocumentSnapshot taskDocument =
                    await dailyCollection.doc("tasks").get();

                    // Get the current "dailyTaskList" array
                    final Map<String, dynamic>? taskData =
                    taskDocument.data() as Map<String, dynamic>?;

                    List<dynamic> dailyTaskList =
                        (taskData?["DailyTasks"] as List<dynamic>?) ?? [];

                    // Remove the task with the specified name from the array
                    dailyTaskList.removeWhere((task) =>
                    task is Map<String, dynamic> &&
                        task["taskName"].toString().trim() ==
                            taskNameToDelete.toString().trim());

                    // Update the "task" document with the modified "dailyTaskList"
                    await dailyCollection
                        .doc("tasks")
                        .set({"DailyTasks": dailyTaskList});

                    QuerySnapshot querySnapshot =
                    await usersCollection.get();

                    for (QueryDocumentSnapshot documentSnapshot
                    in querySnapshot.docs) {
                      await documentSnapshot.reference
                          .update({"DailyTasks": dailyTaskList});
                    }

                    setState(() {
                      // Remove the task from the local dailyTasks list to update the UI
                      dailyTasks.removeWhere((task) =>
                      task is Map<String, dynamic> &&
                          task["taskName"].toString().trim() ==
                              taskNameToDelete.toString().trim());
                    });

                    Fluttertoast.showToast(
                      msg: "Task Deleted",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black54,
                      textColor: Colors.white,
                      fontSize: 14,
                    );
                    uploading = false;

                    // Reset isDeleting after the operation is complete
                    setState(() {
                      isDeleting = false;
                    });

                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
