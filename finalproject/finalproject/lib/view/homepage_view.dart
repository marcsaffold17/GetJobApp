import 'package:flutter/material.dart';
import 'goals_view.dart';
import 'calendar_view.dart';

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
    const darkBlue = Color(0xFF003366); // Example dark blue

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 243, 240),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 75),
              Text(
                'I N L I N K',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 43, 75),
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
              SizedBox(height: 50),
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
              SizedBox(height: 50),
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
                        'Calander',
                        style: TextStyle(fontSize: 20, fontFamily: 'JetB'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
