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
      home: const Delete(),
    );
  }
}

class Delete extends StatefulWidget {
  const Delete({super.key,});

  @override
  State<Delete> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Delete> {

  bool isDelete=false;
  @override
  initState()  {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }

  bool uploading=false;
  var allData;

  List<String>lis3=[];
  String selectedShop="Select Task";
  late List<dynamic> dailyTasks;
  getData()
  async {
    CollectionReference collection =FirebaseFirestore.instance.collection('Users');

    QuerySnapshot snapshot=await collection.get();
    lis3.clear();
    lis3.add("Select Task");
    // for (var element in snapshot.docs) {
    //   lis3.add(element['taskName']);
    // }

    for (var element in snapshot.docs) {
      Map<String, dynamic>? documentData = element.data() as Map<String, dynamic>?;
        if(element['email']=="z") {
          if (documentData != null && documentData.containsKey('DailyTasks')) {
            dailyTasks = documentData['DailyTasks'];

            for (var task in dailyTasks) {
              if (task is Map<String, dynamic> && task.containsKey('taskName')) {
                lis3.add(task['taskName'].toString());
              }
            }
          }
        }
    }

    allData=snapshot.docs.map((doc)=>doc.data()).toList();
    return allData;
  }

  Widget _customPopupItemBuilderExample2(BuildContext context, String item, bool isSelected) {
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
      body:
      FutureBuilder(builder: (BuildContext context, AsyncSnapshot snapshot) {
        print('snapshot data ${snapshot.data}');
        if(snapshot.data==null)
        {
          return const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.black54),);
        }
        else
        {
          return
            ListView(
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
                            borderRadius: BorderRadius.circular(20.0),),
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12, width: 0.0),
                            borderRadius: BorderRadius.circular(20.0),),

                          labelText: 'Daily Tasks',
                          // hintText: 'Select Country',
                          fillColor: Colors.white70,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),

                      ),

                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 15,left:20,right: 8,bottom: 8),
                      child:
                      DropdownSearch<String>(
                        dropdownDecoratorProps:const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(border:InputBorder.none,
                            // labelText: 'Select Country',
                            hintText: 'Search Task by Name',
                            fillColor: Colors.white70,
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),

                        items: lis3,
                        compareFn: (i, s) => i == s,
                        selectedItem: selectedShop,
                        onChanged:  (value) {
                          selectedShop=value!;
                          setState(()  {
                          });},
                        popupProps: PopupPropsMultiSelection.dialog(
                          isFilterOnline: true,
                          showSelectedItems: true,
                          searchFieldProps: const TextFieldProps(
                            decoration: InputDecoration(
                              labelText: 'Search', // Set search text
                              prefixIcon: Icon(Icons.search), // Set search icon
                            ),
                          ),                        showSearchBox: true,
                          itemBuilder: _customPopupItemBuilderExample2,
                        ),
                      ),),

                  ],

                ),
                uploading?Container(alignment: Alignment.center,padding: const EdgeInsets.only(top:12),
                    child:const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.black54),))
                    :const Text(''),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context,index){
                   if(selectedShop!="Select Task")
                    {
                      if(dailyTasks[index]["taskName"]!=selectedShop)
                      {
                        return const SizedBox(height: 0);
                      }
                      else
                      {
                        return GestureDetector(
                          onTap: () async {
                            await _showMyDialog(dailyTasks[index]["taskName"]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              shadowColor: Colors.black54,
                              elevation: 20,
                              child: Column(
                                // alignment: Alignment.topCenter,
                                children: <Widget>[
                                  // ClipRRect(
                                  //   // borderRadius: BorderRadius.circular(40.0),
                                  //   child:
                                  //   Image.network(
                                  //       snapshot.data[index]['shopUrl'],
                                  //       height: 200,
                                  //       width: 1000,
                                  //       fit: BoxFit.cover),
                                  // ),
                                  Container(
                                    // padding: const EdgeInsets.only(top: 220),
                                    child: Text(
                                      "Task: ${dailyTasks[index]["taskName"]}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),

                                    ),),
                                  Container(
                                    // padding: const EdgeInsets.only(top: 220),
                                    child: Text(
                                      "Experience: ${dailyTasks[index]["experience"]}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),

                                    ),),
                                  Container(
                                    // padding: const EdgeInsets.only(top: 220),
                                    child: Text(
                                      "Task Type: ${dailyTasks[index]["icon"]}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),

                                    ),),
                                  dailyTasks[index]["isPremium"]==true?Container(
                                    // padding: const EdgeInsets.only(top: 220),
                                    child: const Text(
                                      "Premium Task",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),

                                    ),):const SizedBox(height: 0,),
                                ],

                              ),

                            ),

                          ),);
                      }

                    }
                    else
                    {
                      return GestureDetector(
                        onTap: () async {


                          await _showMyDialog(dailyTasks[index]["taskName"]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            shadowColor: Colors.black54,
                            elevation: 20,
                            child: Column(
                              // alignment: Alignment.topCenter,
                              children: <Widget>[
                                // ClipRRect(
                                //   // borderRadius: BorderRadius.circular(40.0),
                                //   child:
                                //   Image.network(
                                //       snapshot.data[index]['shopUrl'],
                                //       height: 200,
                                //       width: 1000,
                                //       fit: BoxFit.cover),
                                // ),
                                Container(
                                  // padding: const EdgeInsets.only(top: 220),
                                  child: Text(
                                    "Task: ${dailyTasks[index]["taskName"]}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),

                                  ),),
                                Container(
                                  // padding: const EdgeInsets.only(top: 220),
                                  child: Text(
                                    "Experience: ${dailyTasks[index]["experience"]}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),

                                  ),),
                                Container(
                                  // padding: const EdgeInsets.only(top: 220),
                                  child: Text(
                                    "Task Type: ${dailyTasks[index]["icon"]}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),

                                  ),),
                                dailyTasks[index]["isPremium"]==true?Container(
                                  // padding: const EdgeInsets.only(top: 220),
                                  child: const Text(
                                    "Premium Task",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),

                                  ),):const SizedBox(height: 0,),
                              ],

                            ),

                          ),

                        ),);
                    }
                  },
                  itemCount: dailyTasks.length,
                ),


              ],
            );

        }},
        future:getData(),
      ),

    );
  }


  Future<void> _showMyDialog(String taskNameToDelete) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Attention'),
          content: SingleChildScrollView(
            child: ListBody(
              children:  <Widget>[
                Text('Do you really want to delete $taskNameToDelete Task?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                uploading=true;
                final FirebaseFirestore firestore = FirebaseFirestore.instance;
                final CollectionReference usersCollection = firestore.collection("Users");

                QuerySnapshot querySnapshot = await usersCollection.get();

                for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
                  // List<dynamic> dailyTasks = List.from(documentSnapshot["DailyTasks"]);

                  List<Map<String, dynamic>> updatedDailyTasks = [];
                  for (var task in dailyTasks) {
                    if (task is Map<String, dynamic> && task["taskName"].toString().trim() != taskNameToDelete.toString().trim()) {
                      updatedDailyTasks.add(task);
                    }
                  }

                  await documentSnapshot.reference.update({"DailyTasks": updatedDailyTasks});
                }

                // final forCategory=FirebaseFirestore.instance.collection
                //   ("Users");
                // await forCategory.doc('user1').delete();

                Fluttertoast.showToast(msg: "Task Deleted",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black54,
                  textColor: Colors.white,
                  fontSize: 14,
                );
                uploading=false;
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
        );
      },
    );
  }

}
