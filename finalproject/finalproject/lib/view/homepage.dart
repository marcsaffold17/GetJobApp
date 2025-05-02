import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';


import '../view/SWESearch_view.dart';
import '../view/DSTest.dart';
import '../view/SWETest.dart';
import '../view/video_page.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.title, this.username});

  final String? title;
  final String? username;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildHomePage() {
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

  final List<Widget> _pages = [
    Center(child: Text("Home Page")),
    SWESearchView(),
    Center(child: Text("Favorites")),
    Center(child: Text("Workout History")),
    VideoPage(),
  ];

  @override
  Widget build(BuildContext context) {

    final List<Widget> pages = [
      _buildHomePage(),
      DJobListScreen(),
      JobListScreen(),
    ];
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 243, 240),
      appBar: AppBar(
        title: const Text(""),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 244, 243, 240),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 43, 75),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: GNav(
        onTabChange: _onItemTapped,
        textStyle: const TextStyle(
          color: Color.fromARGB(255, 244, 243, 240),
          fontFamily: 'MontserratB',
        ),
        padding: const EdgeInsets.all(16),
        gap: 8,
        backgroundColor: const Color.fromARGB(255, 0, 43, 75),
        tabBackgroundColor: const Color.fromARGB(255, 17, 84, 116),
        tabBorderRadius: 12,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'Home',
            iconColor: Color.fromARGB(255, 244, 238, 227),
            iconActiveColor: Color.fromARGB(255, 244, 238, 227),
            textColor: Color.fromARGB(255, 244, 238, 227),
          ),
          GButton(
            icon: Icons.sports_handball_outlined,

            text: 'DS Jobs',
            
            iconColor: Color.fromARGB(255, 244, 238, 227),
            iconActiveColor: Color.fromARGB(255, 244, 238, 227),
            textColor: Color.fromARGB(255, 244, 238, 227),
          ),
          GButton(
            icon: Icons.star_border_outlined,
            text: "SE jobs",
            iconColor: Color.fromARGB(255, 244, 238, 227),
            iconActiveColor: Color.fromARGB(255, 244, 238, 227),
            textColor: Color.fromARGB(255, 244, 238, 227),
          ),
          GButton(
            icon: Icons.history,
            text: "Workout History",
            iconColor: Color.fromARGB(255, 244, 238, 227),
            iconActiveColor: Color.fromARGB(255, 244, 238, 227),
            textColor: Color.fromARGB(255, 244, 238, 227),
          ),
          GButton(
            icon: Icons.video_collection,
            text: "Videos",
            iconColor: Color.fromARGB(255, 244, 238, 227),
            iconActiveColor: Color.fromARGB(255, 244, 238, 227),
            textColor: Color.fromARGB(255, 244, 238, 227),
          )
        ],
      ),
    );
  }
}
