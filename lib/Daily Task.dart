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

  TextEditingController experienceController=TextEditingController();
  TextEditingController taskNameController=TextEditingController();
  TextEditingController hoursController=TextEditingController();

  bool showSpinner = false;
  @override
  initState()  {
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

  List<String>list=['Play Task','Cash Task'];

  List<String>list2=['Convert Gems','Perform Transaction','Collect NFT Trait','Buy NFT Trait'];
  String selectedType="Select Task Type";
  String selectedTask="Select Task";

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
      ),
    );
  }

  bool isChecked = false;
  bool isPlay=false;
  bool isCash=false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView(
        children:[ Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50,),

            showSpinner?Container(alignment: Alignment.center,padding: const EdgeInsets.only(top:12),
                child:const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.black54),))
                :const Text(''),
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(9),
                  child: TextField(
                    enabled: false,
                    readOnly: true,
                    // obscureText: true,
                    // controller: shopNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black12, width: 0.0),
                        borderRadius: BorderRadius.circular(20.0),),

                      labelText: 'Task Type',
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
                        hintText: 'Select Task Type',
                        fillColor: Colors.white70,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),

                    items: list,
                    compareFn: (i, s) => i == s,
                    selectedItem: selectedType,
                    onChanged:  (value) {
                      selectedType=value!;
                      setState(()  {
                        if(selectedType=='Play Task')
                          {
                            isCash=false;
                            isPlay=true;
                          }
                        else if(selectedType=='Cash Task')
                        {
                          isPlay=false;
                          isCash=true;
                        }
                      });},
                    popupProps: PopupPropsMultiSelection.dialog(
                      isFilterOnline: true,
                      showSelectedItems: true,
                      searchFieldProps: const TextFieldProps(
                        decoration: InputDecoration(
                          labelText: 'Task Type', // Set search text
                          prefixIcon: Icon(Icons.search), // Set search icon
                        ),
                      ),                        showSearchBox: true,
                      itemBuilder: _customPopupItemBuilderExample2,
                    ),
                  ),),

              ],

            ),

            isCash?
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(9),
                  child: TextField(
                    enabled: false,
                    readOnly: true,
                    // obscureText: true,
                    // controller: shopNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black12, width: 0.0),
                        borderRadius: BorderRadius.circular(20.0),),

                      labelText: 'Task Name',
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
                        hintText: 'Select Task Name',
                        fillColor: Colors.white70,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),

                    items: list2,
                    compareFn: (i, s) => i == s,
                    selectedItem: selectedTask,
                    onChanged:  (value) {
                      selectedTask=value!;
                      setState(()  {
                      });},
                    popupProps: PopupPropsMultiSelection.dialog(
                      isFilterOnline: true,
                      showSelectedItems: true,
                      searchFieldProps: const TextFieldProps(
                        decoration: InputDecoration(
                          labelText: 'Task Type', // Set search text
                          prefixIcon: Icon(Icons.search), // Set search icon
                        ),
                      ),                        showSearchBox: true,
                      itemBuilder: _customPopupItemBuilderExample2,
                    ),
                  ),),

              ],

            )
                :const SizedBox(height: 0,),
            isPlay?
            Padding(
              padding: const EdgeInsets.all(9),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: hoursController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black12, width: 0.0),
                    borderRadius: BorderRadius.circular(20.0),),

                  labelText: 'Hours',
                  hintText: 'Enter Play Hours',
                  fillColor: Colors.white70,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon:const Icon(
                    CupertinoIcons.profile_circled ,
                    color: Colors.grey,
                  ),
                ),
              ),
            )
                :const SizedBox(height: 0,),
            isPlay?
            Padding(
              padding: const EdgeInsets.all(9),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: experienceController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black12, width: 0.0),
                    borderRadius: BorderRadius.circular(20.0),),

                  labelText: 'Experience',
                  hintText: 'Enter Experience Gain',
                  fillColor: Colors.white70,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: const Icon(
                    CupertinoIcons.mail ,
                    color: Colors.grey,
                  ),


                ),

              ),

            )
                :const SizedBox(height: 0,),
            isCash?
            Padding(
              padding: const EdgeInsets.all(9),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: experienceController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black12, width: 0.0),
                    borderRadius: BorderRadius.circular(20.0),),

                  labelText: 'Experience',
                  hintText: 'Enter Experience Gain',
                  fillColor: Colors.white70,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: const Icon(
                    CupertinoIcons.mail ,
                    color: Colors.grey,
                  ),


                ),

              ),

            )
                :const SizedBox(height: 0,),


            isPlay?
            Padding(
              padding: const EdgeInsets.all(9),
              child:
              Row(
                // mainAxisAlignment:MainAxisAlignment.end,
                children:[
                  Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });}),
                  const Text('Is Premium',
                    style: TextStyle(color: Colors.black54, fontSize: 11),
                  ),
                ],),
            )
                :const SizedBox(height: 0,),
            isCash?
            Padding(
              padding: const EdgeInsets.all(9),
              child:
              Row(
                // mainAxisAlignment:MainAxisAlignment.end,
                children:[
                  Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });}),
                  const Text('Is Premium',
                    style: TextStyle(color: Colors.black54, fontSize: 11),
                  ),
                ],),
            )
                :const SizedBox(height: 0,),


            Container(
              padding: const EdgeInsets.only(bottom: 10),
              width:170,
              height:60,
              child:
              ElevatedButton(
                onPressed: () async  {

                  if(selectedType!="Select Task Type")
                    {
                      if(selectedType=="Play Task")
                        {
                          if(experienceController.text.toString().isNotEmpty &&
                              hoursController.text.toString().isNotEmpty)
                            {
                              await saveItemInfo('play');
                            }
                        }
                      else if(selectedType=="Cash Task")
                        {
                          if(experienceController.text.toString().isNotEmpty
                              &&selectedTask!="Select Task")
                            {
                              await saveItemInfo('cash');
                            }
                        }
                      else
                        {
                          Fluttertoast.showToast(msg: 'Incomplete Information',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black54,
                            textColor: Colors.white,
                            fontSize: 14,
                          );
                        }
                    }
                },
                style: ElevatedButton.styleFrom(
                  // padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)
                  ),
                  primary: const Color.fromRGBO(0,173,181,2),
                ),
                child: const Text(
                  "Add",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),

          ],
        ),],
      ),
    );
  }


  saveItemInfo(String type)
  async {
    final usersCollection=FirebaseFirestore.instance.collection("Users");
    if(type=="cash")
      {
        Map<String, dynamic> newDailyTask = {
          "taskName": selectedTask,
          "experience": experienceController.text.toString(),
          "isPremium": isChecked,
          "isProgress": false,
          "isCompleted": false,
          "icon": "cash",
          "hours": 0,
          "taskProgress": 0,
        };

        QuerySnapshot usersQuery = await usersCollection.get();
        for (QueryDocumentSnapshot doc in usersQuery.docs) {
          try {
            await doc.reference.update({
              "DailyTasks": FieldValue.arrayUnion([newDailyTask]),
            });
            print("Document updated successfully!");
          } catch (e) {
            print("Error updating document: $e");
          }
        }
      }
    else
      {
        Map<String, dynamic> newDailyTask = {
          "taskName":"Play for ${hoursController.text.toString()} hours",
          "experience":experienceController.text.toString(),
          "isPremium":isChecked,
          "isProgress":true,
          'isCompleted':false,
          'icon':"play",
          'hours':int.parse(hoursController.text.toString()),
          'taskProgress':0,
        };

        QuerySnapshot usersQuery = await usersCollection.get();
        for (QueryDocumentSnapshot doc in usersQuery.docs) {
          try {
            await doc.reference.update({
              "DailyTasks": FieldValue.arrayUnion([newDailyTask]),
            });
            print("Document updated successfully!");
          } catch (e) {
            print("Error updating document: $e");
          }
        }


      }
    setState(() {

      hoursController.clear();
      experienceController.clear();
      isChecked=false;
      showSpinner=false;
      isCash=false;
      isPlay=false;
      selectedType="Select Task Type";
      selectedTask="Select Task";
      Fluttertoast.showToast(msg: "Daily Task Added",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14,
      );


    });
  }


}
