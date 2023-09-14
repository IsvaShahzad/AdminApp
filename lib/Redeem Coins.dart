import 'dart:async';

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      home: const Redeem(),
    );
  }
}

class Redeem extends StatefulWidget {
  const Redeem({super.key});

  @override
  State<Redeem> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Redeem> {

  TextEditingController eventController=TextEditingController();
  TextEditingController expiryController=TextEditingController();
  TextEditingController gemsController=TextEditingController();
  TextEditingController maxTextController=TextEditingController();
  TextEditingController percentOffController=TextEditingController();
  TextEditingController imgController=TextEditingController();

  late XFile file;
  String icon="";
  bool hasImage=false;


  bool showSpinner = false;
  @override
  initState()  {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

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
            Padding(
              padding: const EdgeInsets.all(9),
              child: TextField(
                controller: eventController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black12, width: 0.0),
                    borderRadius: BorderRadius.circular(20.0),),

                  labelText: 'Event',
                  hintText: 'Enter Event',
                  fillColor: Colors.white70,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon:const Icon(
                    CupertinoIcons.profile_circled ,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(9),
              child: TextField(
                controller: expiryController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black12, width: 0.0),
                    borderRadius: BorderRadius.circular(20.0),),

                  labelText: 'Expiry',
                  hintText: 'Enter Expiry Date dd/mm',
                  fillColor: Colors.white70,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: const Icon(
                    CupertinoIcons.mail ,
                    color: Colors.grey,
                  ),


                ),

              ),

            ),
            Padding(
              padding: const EdgeInsets.all(9),
              child: TextField(
                controller: gemsController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black12, width: 0.0),
                    borderRadius: BorderRadius.circular(20.0),),

                  labelText: 'Gems',
                  hintText: 'Enter Gems after discount',
                  fillColor: Colors.white70,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: const Icon(
                    CupertinoIcons.lock ,
                    color: Colors.grey,
                  ),


                ),

              ),

            ),

            Padding(
              padding: const EdgeInsets.all(9),
              child: TextField(
                controller: maxTextController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black12, width: 0.0),
                    borderRadius: BorderRadius.circular(20.0),),

                  labelText: 'Max Gems',
                  hintText: 'Enter Max Gems',
                  fillColor: Colors.white70,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: const Icon(
                    CupertinoIcons.lock_shield ,
                    color: Colors.grey,
                  ),


                ),

              ),

            ),
            Padding(
              padding: const EdgeInsets.all(9),
              child: TextField(
                controller: percentOffController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black12, width: 0.0),
                    borderRadius: BorderRadius.circular(20.0),),

                  labelText: 'Off Percent',
                  hintText: 'Enter Off Percentage',
                  fillColor: Colors.white70,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: const Icon(
                    CupertinoIcons.lock_shield ,
                    color: Colors.grey,
                  ),


                ),

              ),

            ),


            Container(
              padding: const EdgeInsets.only(top:9,left:9,right:9),
              alignment: Alignment.centerLeft,
              child:
              ElevatedButton (
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
                ),
                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                onPressed: ()async {
                  final file =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
                  setState(() { this.file = file!;
                  imgController.text=file.name;
                  hasImage=true;
                  });
                },
                child: const Text("Add Image",style: TextStyle(fontSize: 15,color: Colors.white),),
              ),),
            Padding(

              padding: const EdgeInsets.all(9),
              child: GestureDetector(
                onTap:  ()async {
                  final file =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
                  setState(() { this.file = file!;
                  imgController.text=file.name;
                  hasImage=true;
                  });
                },
                child: TextField(
                  controller:imgController,
                  enabled: false,
                  // readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black12, width: 0.0),
                      borderRadius: BorderRadius.circular(20.0),),

                    labelText: 'Image URL',
                    hintText: 'Add Icon Image',
                    fillColor: Colors.white70,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon:
                    const Icon(
                      CupertinoIcons.add ,
                      color: Colors.grey,
                    ),



                  ),

                ),),

            ),



            Container(
              padding: const EdgeInsets.only(bottom: 10),
              width:170,
              height:60,
              child:
              ElevatedButton(
                onPressed: () async  {
                  if(percentOffController.text.toString().isNotEmpty &&
                      maxTextController.text.toString().isNotEmpty &&
                      gemsController.text.toString().isNotEmpty &&
                      expiryController.text.toString().isNotEmpty &&
                      eventController.text.toString().isNotEmpty && hasImage
                  )
                  {
                      await uploadInfoOnFirebase();


                  }
                  else
                  {
                    Fluttertoast.showToast(msg: "Incomplete Information",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black54,
                      textColor: Colors.white,
                      fontSize: 14,
                    );
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


  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
  uploadInfoOnFirebase() async
  {
    setState((){
      showSpinner=true;
    });
    String profile;
    profile = await uploadItemImage(File(file.path));
    await saveItemInfo(profile);
  }
  String iconName=DateTime.now().millisecond.toString();
  saveItemInfo(String profile)
  async {
    final usersCollection=FirebaseFirestore.instance.collection("Users");
    Map<String, dynamic> newRedeemCoin = {
      "event_":eventController.text.toString(),
      "expText_":expiryController.text.toString(),
      "gemsText_":gemsController.text.toString(),
      "maxText_":int.parse(maxTextController.text.toString()),
      'icon_':"Icon $iconName",
      'percentText_':int.parse(percentOffController.text.toString()),
    };

    QuerySnapshot usersQuery = await usersCollection.get();
    for (QueryDocumentSnapshot doc in usersQuery.docs) {
      try {
        await doc.reference.update({
          "RedeemCoins": FieldValue.arrayUnion([newRedeemCoin]),
        });
        print("Document updated successfully!");
      } catch (e) {
        print("Error updating document: $e");
      }
    }

    setState(() {
      eventController.clear();
      expiryController.clear();
      gemsController.clear();
      maxTextController.clear();
      percentOffController.clear();
      imgController.clear();
      showSpinner=false;
      Fluttertoast.showToast(msg: "Redeem Task Added",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14,
      );


    });
  }
  Future<String>uploadItemImage(img)async
  {
    Reference storageReference=FirebaseStorage.instance.ref().child("images");
    UploadTask uploadTaskShop;
    uploadTaskShop=storageReference.child("Icon $iconName.png").putFile(img);
    String downloadUrlShop=await uploadTaskShop.then((res) {return res.ref.getDownloadURL();});
    return downloadUrlShop;
  }


}
