import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
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
              TextStyle(color: Color.fromRGBO(118, 73, 142, 1)),
            ),
            indicatorColor: Color.fromRGBO(118, 73, 142, 0.2),
          ),
          child: NavigationBar(
            height: 80,
            elevation: 0,
            shadowColor: Colors.blue,
            backgroundColor: Color.fromRGBO(230, 230, 226, 1),
            selectedIndex: presenter.selectedIndex.value,
            onDestinationSelected: presenter.onItemTapped,
            destinations: const [
              NavigationDestination(
                icon: Icon(
                  LineIcons.home,
                  color: Color.fromRGBO(118, 73, 142, 1),
                ),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(
                  LineIcons.book,
                  color: Color.fromRGBO(118, 73, 142, 1),
                ),
                label: 'Graphs',
              ),
              NavigationDestination(
                icon: Icon(
                  LineIcons.user,
                  color: Color.fromRGBO(118, 73, 142, 1),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
      body: Obx(() => presenter.currentScreen),
    );
  }
}
