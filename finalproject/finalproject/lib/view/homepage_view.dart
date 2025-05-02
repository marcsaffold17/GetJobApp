import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'DSTest_view.dart';
import 'navBar_view.dart';
import 'goals_view.dart';

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
    // Replace with your actual dark blue color if it's defined elsewhere
    const darkBlue = Color(0xFF003366); // Example dark blue

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 243, 240),
      body: Stack(
        children: [
          Positioned(
            bottom: 32,
            left: 16,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: darkBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChecklistPage(isFromNavbar: false),
                  ),
                );
              },
              child: const Text(
                'Go to Checklist',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
