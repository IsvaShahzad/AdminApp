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
      home: const UserHistory(email: '',),
    );
  }
}

class UserHistory extends StatefulWidget {
  const UserHistory({super.key, required this.email,});

  final String email;
  @override
  State<UserHistory> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<UserHistory> {

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
  List<dynamic> dailyTasks=[];
  getData()
  async {
    CollectionReference collection =FirebaseFirestore.instance.collection('Users');

    QuerySnapshot snapshot=await collection.get();
    // lis3.clear();
    // lis3.add("Select Task");
    // for (var element in snapshot.docs) {
    //   lis3.add(element['taskName']);
    // }

    for (var element in snapshot.docs) {
      Map<String, dynamic>? documentData = element.data() as Map<String, dynamic>?;
      if(element['email']==widget.email) {
        if (documentData != null && documentData.containsKey('activities')) {
          dailyTasks = documentData['activities'];

          // for (var task in dailyTasks) {
          //   if (task is Map<String, dynamic> && task.containsKey('taskName')) {
          //     lis3.add(task['taskName'].toString());
          //   }
          // }
        }
      }
    }
    // dailyTasks.reverse=true

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
          return const Center(child:CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.black54),));
        }
        else
        {
          return
            ListView(
              children: [
                dailyTasks.isEmpty?
                const Center(child:Text("No Activity yet")):
                Center(
                    child:
                    Column(
                      children: [
                        const Center(child:Text("Activities",style: TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 20),)),
                        ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context,index){
                      // if(snapshot.data[index]['email']!=widget.email)
                      // {
                      //   return const SizedBox(height: 0);
                      // }
                      // else
                      // {
                    if(dailyTasks.isEmpty)
                      {
                       // show();
                       return const Center(child:Text("No Activity yet"));
                      }
                    else {
                      return

                        GestureDetector(
                        onTap: () async {},
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
                                    "Activity: ${dailyTasks[index]["activity"]}",
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
                                    "Date: ${dailyTasks[index]["date"]}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),

                                  ),),
                                Container(
                                  // padding: const EdgeInsets.only(top: 220),
                                  child: Text(
                                    "Time: ${dailyTasks[index]["time"]}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),

                                  ),),

                              ],

                            ),

                          ),

                        ),)
                    ;
                      }
                    // }

                  },
                  itemCount: dailyTasks.length,
                ),
              ],)
        )


              ],
            );

        }},
        future:getData(),
      ),

    );
  }

show(){
  setState(() {
    Fluttertoast.showToast(msg: "No Activity Yet",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14,
    );
  });

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
