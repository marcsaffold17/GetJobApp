import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../presenter/navBar_presenter.dart';

class NavigationMenuView extends StatelessWidget {
  NavigationMenuView({super.key});

  final presenter = Get.put(NavigationMenuPresenter());

  @override
  Widget build(BuildContext context) {
    // Check if the current theme is dark
    final darkMode = Theme.of(context).brightness == Brightness.dark;

    // Define dark and light mode color schemes
    final backgroundColor =
        darkMode
            ? const Color.fromARGB(255, 66, 64, 64)
            : Color.fromARGB(255, 230, 230, 226);
    final iconColor = darkMode ? Colors.white : Color.fromARGB(255, 0, 43, 75);
    final labelColor =
        darkMode ? Colors.white : Color.fromARGB(255, 17, 84, 116);
    final indicatorColor =
        darkMode
            ? Color.fromARGB(190, 17, 84, 116)
            : Color.fromARGB(190, 17, 84, 116);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: WidgetStateProperty.all(
              TextStyle(color: labelColor, fontFamily: 'inter'),
            ),
            indicatorColor: indicatorColor,
          ),
          child: NavigationBar(
            height: 80,
            elevation: 0,
            shadowColor: darkMode ? Colors.grey : Colors.blue,
            backgroundColor: backgroundColor,
            selectedIndex: presenter.selectedIndex.value,
            onDestinationSelected: presenter.onItemTapped,
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home, color: iconColor),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.book, color: iconColor),
                label: 'Jobs',
              ),
              NavigationDestination(
                icon: Icon(Icons.favorite, color: iconColor),
                label: 'Favorites',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.video_collection,
                  color: Color.fromARGB(255, 0, 43, 75),
                ),
                label: 'Videos',
              )
            ],
          ),
        ),
      ),
      body: Obx(() => presenter.currentScreen),
    );
  }
}
