import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'DSTest_view.dart';
import 'SWETest_view.dart';
import 'navBar_view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.title, this.username});

  final String? title;
  final String? username;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 243, 240),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [],
        ),
      ),
    );
  }
}

// Widget _buildHomePage() {
//   Widget build(BuildContext context) {
    // return Scaffold(
    //   backgroundColor: const Color.fromARGB(255, 244, 243, 240),
    //   body: Padding(
    //     padding: const EdgeInsets.all(16.0),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [],
    //     ),
    //   ),
//     );
//   }
// }
// }
