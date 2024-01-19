import 'package:admin_gameotivity/Users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Daily Task.dart';
import 'Delete.dart';
import 'DeleteRedeem.dart';
import 'Redeem Coins.dart';
import 'SurveyScreen.dart';

void main() {
  runApp(const HomeScreen());
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Screen',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const Selection(
        page: '',
      ),
    );
  }
}

class Selection extends StatefulWidget {
  const Selection({Key? key, required this.page});
  final String page;

  @override
  State<Selection> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Selection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: OrientationBuilder(
            builder: (context, orientation) {
              double screenWidth = MediaQuery.of(context).size.width;
              int crossAxisCount = orientation == Orientation.portrait ? 2 : 3;
              double childAspectRatio = screenWidth / (crossAxisCount * 200);

              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.only(
                      top: orientation == Orientation.portrait ? 160.0 : 80.0,
                    ),
                    sliver: SliverGrid.count(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: childAspectRatio,
                  children: [
                    buildGridTile(Icons.add, "Add Task", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DailyTask()),
                      );
                    }),
                    buildGridTile(Icons.delete, "Delete Task", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Delete()),
                      );
                    }),

                    buildGridTile(Icons.event, "Add Event", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Redeem()),
                      );
                    }),
                    buildGridTile(Icons.delete_forever, "Delete Event", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DeleteRedeem()),
                      );
                    }),
                    buildGridTile(Icons.person, "Users", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Users()),
                      );
                    }),
                    buildGridTile(Icons.poll, "Survey", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SurveyScreen()),
                      );
                    }),

                  ],

                ),
              ),
            ],
          );
        }));
  }

  Widget buildGridTile(IconData icon, String label, VoidCallback onTap) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          primary: const Color(0xFF9370DB),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48, // Adjust the size of the icon as needed
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
