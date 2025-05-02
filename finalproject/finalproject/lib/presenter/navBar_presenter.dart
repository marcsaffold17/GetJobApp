import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view/DSTest_view.dart';
import '../view/SWETest_view.dart';
import '../view/homepage_view.dart';

class NavigationMenuPresenter extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [MyHomePage(), DJobListScreen(), JobListScreen()];

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }

  Widget get currentScreen => screens[selectedIndex.value];
}
