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

import 'Daily Task.dart';
import 'Delete.dart';
import 'DeleteRedeem.dart';
import 'Redeem Coins.dart';


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
      home: const Selection(page: '',),
    );
  }
}

class Selection extends StatefulWidget {
  const Selection({super.key, required this.page});
  final String page;

  @override
  State<Selection> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Selection> {

  @override
  initState()  {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [

          widget.page=="dailyTask"?
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            width:170,
            height:60,
            child:
            ElevatedButton(
              onPressed: ()  {
                Navigator.push(context,
                    MaterialPageRoute(builder:
                        (context) =>
                    const DailyTask()
                    )
                );

              },
              style: ElevatedButton.styleFrom(
                // padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)
                ),
                primary: const Color.fromRGBO(0,173,181,2),
              ),
              child: const Text(
                "Add Task",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          )
              :const SizedBox(height: 0,),
          widget.page=="dailyTask"?
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            width:170,
            height:60,
            child:
            ElevatedButton(
              onPressed: () async  {
                Navigator.push(context,
                    MaterialPageRoute(builder:
                        (context) =>
                    const Delete()
                    )
                );

              },
              style: ElevatedButton.styleFrom(
                // padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)
                ),
                primary: const Color.fromRGBO(0,173,181,2),
              ),
              child: const Text(
                "Delete Task",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          )
              :const SizedBox(height: 0,),
          widget.page=="redeemTask"?
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            width:170,
            height:60,
            child:
            ElevatedButton(
              onPressed: () async  {
                Navigator.push(context,
                    MaterialPageRoute(builder:
                        (context) =>
                    const Redeem()
                    )
                );

              },
              style: ElevatedButton.styleFrom(
                // padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)
                ),
                primary: const Color.fromRGBO(0,173,181,2),
              ),
              child: const Text(
                "Add Event",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          )
              :const SizedBox(height: 0,),
          widget.page=="redeemTask"?
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            width:170,
            height:60,
            child:
            ElevatedButton(
              onPressed: () async  {

                Navigator.push(context,
                    MaterialPageRoute(builder:
                        (context) =>
                    const DeleteRedeem()
                    )
                );
              },
              style: ElevatedButton.styleFrom(
                // padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)
                ),
                primary: const Color.fromRGBO(0,173,181,2),
              ),
              child: const Text(
                "Delete Event",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          )
              :const SizedBox(height: 0,),

        ],
      ),
      ),
    );
  }




}
