import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../view/DSTest.dart';
import '../view/SWETest.dart';
import 'navBar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.title, this.username});

  final String? title;
  final String? username;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return NavigationMenuView();
//   }
// }

class _MyHomePageState extends State<MyHomePage> {
  // int _selectedIndex = 0;

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  // final List<Widget> _pages = [
  //   Center(child: Text("Home Page")),
  //   Center(child: Text("Exercise List")),
  //   Center(child: Text("Favorites")),
  //   Center(child: Text("Workout History")),
  // ];

  @override
  Widget build(BuildContext context) {
    return NavigationMenuView();
  }
}

// Widget _buildHomePage() {
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 244, 243, 240),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [],
//         ),
//       ),
//     );
//   }
// }
