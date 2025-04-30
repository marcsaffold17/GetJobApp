import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

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

  final List<Widget> _pages = [
    Center(child: Text("Home Page")),
    Center(child: Text("Exercise List")),
    Center(child: Text("Favorites")),
    Center(child: Text("Workout History")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: const Color.fromARGB(255, 0, 43, 75),
        iconTheme: const IconThemeData(color: Colors.white),
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
          color: Colors.white,
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
            iconColor: Colors.white,
            iconActiveColor: Colors.white,
            textColor: Colors.white,
          ),
          GButton(
            icon: Icons.sports_handball_outlined,
            text: 'Exercise List',
            iconColor: Colors.white,
            iconActiveColor: Colors.white,
            textColor: Colors.white,
          ),
          GButton(
            icon: Icons.star_border_outlined,
            text: "Favorites",
            iconColor: Colors.white,
            iconActiveColor: Colors.white,
            textColor: Colors.white,
          ),
          GButton(
            icon: Icons.history,
            text: "History",
            iconColor: Colors.white,
            iconActiveColor: Colors.white,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
