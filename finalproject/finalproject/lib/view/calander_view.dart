import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'DSTest_view.dart';
import 'navBar_view.dart';
import 'goals_view.dart';

class MyCalanderPage extends StatefulWidget {
  const MyCalanderPage({super.key, this.title, this.username});

  final String? title;
  final String? username;

  @override
  _MyCalanderPage createState() => _MyCalanderPage();
}

class _MyCalanderPage extends State<MyCalanderPage> {
  @override
  Widget build(BuildContext context) {
    // const darkBlue = Color(0xFF003366); // Example dark blue
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: const Color.fromARGB(255, 244, 243, 240),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
