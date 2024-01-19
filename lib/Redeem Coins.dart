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
  TextEditingController eventController = TextEditingController();
  TextEditingController expiryController = TextEditingController();
  TextEditingController gemsController = TextEditingController();
  TextEditingController maxTextController = TextEditingController();
  TextEditingController percentOffController = TextEditingController();
  TextEditingController imgController = TextEditingController();
  TextEditingController couponController = TextEditingController();
  TextEditingController promoController = TextEditingController();

  late XFile file;
  String icon = "";
  bool hasImage = false;

  bool showSpinner = false;

  @override
  initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          // Background Image

          ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3),
                          child: Text(
                            'Event',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700], // Set light grey color for the icon
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          height: 36, // Set the desired height
                          child: TextField(
                            textInputAction: TextInputAction.next,
                            controller: eventController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[100], // Set fill color to grey 100
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                              hintText: 'Enter Event',
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              // Explicitly set the label text style
                              labelText: 'Event',
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.normal, // Set the desired font weight
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3),
                          child: Text(
                            'Expiry',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[
                                    700], // Set light grey color for the icon
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          height: 40, // Set the desired height
                          child: TextField(
                            textInputAction: TextInputAction.next,
                            controller: expiryController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors
                                  .grey[100], // Set fill color to grey 100
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: 0.0),
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                              hintText: 'Enter Expiry Date dd/mm/yy',
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3),
                          child: Text(
                            'Gems',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[
                                    700], // Set light grey color for the icon
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          height: 40, // Set the desired height
                          child: TextField(
                            textInputAction: TextInputAction.next,
                            controller: gemsController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors
                                  .grey[100], // Set fill color to grey 100
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: 0.0),
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                              hintText: 'Enter Gems to buy promo code',
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3),
                          child: Text(
                            'User Experience',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[
                                  700], // Set light grey color for the icon
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          height: 40, // Set the desired height
                          child: TextField(
                            textInputAction: TextInputAction.next,
                            controller: maxTextController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors
                                  .grey[100], // Set fill color to grey 100
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: 0.0),
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                              hintText: 'Enter user min XP',
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3),
                          child: Text(
                            'Promo',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[
                                    700], // Set light grey color for the icon
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          height: 40, // Set the desired height
                          child: TextField(
                            textInputAction: TextInputAction.next,
                            controller: promoController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors
                                  .grey[100], // Set fill color to grey 100
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: 0.0),
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                              hintText: 'Enter Promo code',
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3),
                          child: Text(
                            'Coupons',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[
                                  700], // Set light grey color for the icon
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          height: 40, // Set the desired height
                          child: TextField(
                            textInputAction: TextInputAction.next,
                            controller: couponController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors
                                  .grey[100], // Set fill color to grey 100
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: 0.0),
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                              hintText: 'Enter no of coupons',
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3),
                          child: Text(
                            'Sales Percent',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[
                                  700], // Set light grey color for the icon
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          height: 40, // Set the desired height
                          child: TextField(
                            textInputAction: TextInputAction.next,
                            controller: percentOffController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors
                                  .grey[100], // Set fill color to grey 100
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: 0.0),
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                              hintText: 'Enter Sales Percentage',
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.0),
                        ),
                      ),
                      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                      onPressed: () async {
                        final file = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        setState(() {
                          this.file = file!;
                          imgController.text = file.name;
                          hasImage = true;
                        });
                      },
                      child: const Text(
                        "Add Image",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final file = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            setState(() {
                              this.file = file!;
                              imgController.text = file.name;
                              hasImage = true;
                            });
                          },
                          child: TextField(
                            controller: imgController,
                            enabled: false,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: 0.0),
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                              hintText: 'Add Icon Image',
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              suffixIcon: const Icon(
                                CupertinoIcons.add,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 13,
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
                              if (percentOffController.text
                                      .toString()
                                      .isNotEmpty &&
                                  maxTextController.text
                                      .toString()
                                      .isNotEmpty &&
                                  gemsController.text.toString().isNotEmpty &&
                                  expiryController.text.toString().isNotEmpty &&
                                  eventController.text.toString().isNotEmpty) {
                                if (hasImage) {
                                  uploadInfoOnFirebase();
                                } else {
                                  // No image added, set default image
                                  final defaultImage =
                                      await getImageFileFromAssets(
                                          'transparent.png');
                                  setState(() {
                                    file = XFile(defaultImage.path);
                                    imgController.text = 'transparent.png';
                                    hasImage = true;
                                  });

                                  // Wait for the state to be updated before calling uploadInfoOnFirebase
                                  setState(() {
                                    uploadInfoOnFirebase();
                                  });
                                }
                              } else {
                                Fluttertoast.showToast(
                                  msg: "Incomplete Information",
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
        ]));
  }

  Future<File> getImageFileFromAssets(String path) async {
    if (hasImage) {
      return File(file.path);
    } else {
      // Load a default transparent image from assets
      final byteData = await rootBundle.load('assets/images/transparent.png');
      final file =
          File('${(await getTemporaryDirectory()).path}/transparent.png');
      await file.writeAsBytes(
        byteData.buffer.asUint8List(
          byteData.offsetInBytes,
          byteData.lengthInBytes,
        ),
      );
      return file;
    }
  }

  // Future<File> getImageFileFromAssets(String path) async {
  //   if (hasImage) {
  //     return File(file.path);
  //   } else {
  //     // Load a default transparent image from assets
  //     return await rootBundle.load('assets/images/transparent.png').then(
  //           (byteData) async {
  //         final file = File('${(await getTemporaryDirectory()).path}/transparent.png');
  //         await file.writeAsBytes(byteData.buffer.asUint8List(
  //           byteData.offsetInBytes,
  //           byteData.lengthInBytes,
  //         ));
  //         return file;
  //       },
  //     );
  //   }
  // }

  uploadInfoOnFirebase() async {
    setState(() {
      showSpinner = true;
    });
    String profile;
    profile = await uploadItemImage(File(file.path));
    await saveItemInfo(profile);
  }

  String iconName = DateTime.now().millisecond.toString();

  saveItemInfo(String profile) async {
    final usersCollection = FirebaseFirestore.instance.collection("Users");
    final redeemCollection =
        FirebaseFirestore.instance.collection("Redeem Coins");

    Map<String, dynamic> newRedeemCoin = {
      "_event": eventController.text.toString(),
      "_expText": expiryController.text.toString(),
      "_gemsText": gemsController.text.toString(),
      "_coupons": couponController.text.toString(),
      '_promo': promoController.text.toString(),
      "_maxText": int.parse(maxTextController.text.toString()),
      '_icon': "Icon $iconName",
      '_percentText': int.parse(percentOffController.text.toString()),
    };

    QuerySnapshot redeemQuery = await redeemCollection.get();
    for (QueryDocumentSnapshot doc in redeemQuery.docs) {
      try {
        await doc.reference.update({
          "RedeemCoins": FieldValue.arrayUnion([newRedeemCoin]), //delete
        });
        // print("Document updated successfully!");
      } catch (e) {
        print("Error updating document: $e");
      }
    }

    // Adding the redeem coin data to the "Users" collection
    QuerySnapshot usersQuery = await usersCollection.get();
    for (QueryDocumentSnapshot doc in usersQuery.docs) {
      try {
        await doc.reference.update({
          "RedeemCoins": FieldValue.arrayUnion([newRedeemCoin]), //delete
        });
        // print("Document updated successfully!");
      } catch (e) {
        print("Error updating document: $e");
      }
    }

    // Adding the redeem coin data to the "RedeemCollect
    // ion" collection
    // await redeemCollection.doc("tasks").set({
    //   "RedeemCoins": FieldValue.arrayUnion([newRedeemCoin]),
    // }, SetOptions(merge: true));
    print(
        "Redeem Task added to Redeem Task collection with document name 'redeemed' successfully!");
    setState(() {
      // Clearing controllers and updating the UI
      eventController.clear();
      expiryController.clear();
      gemsController.clear();
      maxTextController.clear();
      percentOffController.clear();
      couponController.clear();
      imgController.clear();
      promoController.clear();
      showSpinner = false;
      Fluttertoast.showToast(
        msg: "Redeem Task Added",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14,
      );
    });
  }

  Future<String> uploadItemImage(img) async {
    Reference storageReference = FirebaseStorage.instance.ref().child("images");
    UploadTask uploadTaskShop;
    uploadTaskShop = storageReference.child("Icon $iconName.png").putFile(img);
    String downloadUrlShop = await uploadTaskShop.then((res) {
      return res.ref.getDownloadURL();
    });
    return downloadUrlShop;
  }
}
