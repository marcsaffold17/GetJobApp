import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../presenter/navBar_presenter.dart';

class NavigationMenuView extends StatelessWidget {
  NavigationMenuView({super.key});

  final presenter = Get.put(NavigationMenuPresenter());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: WidgetStateProperty.all(
              TextStyle(
                color: Color.fromARGB(255, 17, 84, 116),
                fontFamily: 'inter',
              ),
            ),
            indicatorColor: Color.fromARGB(190, 17, 84, 116),
          ),
          child: NavigationBar(
            height: 80,
            elevation: 0,
            shadowColor: Colors.blue,
            backgroundColor: Color.fromARGB(255, 230, 230, 226),
            selectedIndex: presenter.selectedIndex.value,
            onDestinationSelected: presenter.onItemTapped,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home, color: Color.fromARGB(255, 0, 43, 75)),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.book, color: Color.fromARGB(255, 0, 43, 75)),
                label: 'Jobs',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.favorite,
                  color: Color.fromARGB(255, 0, 43, 75),
                ),
                label: 'Favorites',
              ),
            ],
          ),
        ),
      ),
      body: Obx(() => presenter.currentScreen),
    );
  }
}
