import 'package:flutter/material.dart';
import 'goals_view.dart';

import 'profile_page.dart'; // Import the profile page
import 'calendar_view.dart';
import 'alarm_view.dart';
import 'video_page.dart';

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
    final darkMode = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor =
        darkMode
            ? const Color.fromARGB(
              255,
              80,
              80,
              80,
            ) // Dark mode background color
            : const Color.fromARGB(255, 244, 243, 240); // Light mode background

    final primaryColor =
        darkMode ? Color(0xFF003366) : Color.fromARGB(255, 0, 43, 75);
    final accentColor =
        darkMode
            ? const Color.fromARGB(255, 0, 43, 75)
            : Color.fromARGB(255, 0, 43, 75); // Match profile page colors

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 75),
              Text(
                'I N L I N K',
                style: TextStyle(
                  color:
                      darkMode
                          ? const Color.fromARGB(255, 0, 43, 75)
                          : primaryColor,
                  fontFamily: 'inter',
                  fontSize: 80,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 200,
                height: 200,
                child: Image(
                  image: AssetImage("assets/images/Logo.png"),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    height: 60,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: accentColor,
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
                            builder:
                                (context) => ChecklistPage(isFromNavbar: false),
                          ),
                        );
                      },
                      child: const Text(
                        'Career Goals',
                        style: TextStyle(fontSize: 20, fontFamily: 'JetB'),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    height: 60,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 0, 43, 75),
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
                            builder: (context) => MyCalendarPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Calendar',
                        style: TextStyle(fontSize: 20, fontFamily: 'JetB'),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    height: 60,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 0, 43, 75),
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
                            builder: (context) => AlarmScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Alarm',
                        style: TextStyle(fontSize: 20, fontFamily: 'JetB'),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    height: 60,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 0, 43, 75),
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
                          MaterialPageRoute(builder: (context) => VideoPage()),
                        );
                      },
                      child: const Text(
                        'Videos',
                        style: TextStyle(fontSize: 20, fontFamily: 'JetB'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Profile button on top right of the homepage
          Positioned(
            top: 40, // Adjust this value to place it higher or lower
            right: 20, // Adjust this value to position it horizontally
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
              child: CircleAvatar(
                radius: 30,
                backgroundColor: darkMode ? Colors.grey[600] : Colors.grey[300],
                child: Icon(
                  Icons.account_circle,
                  size: 35,
                  color: darkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
