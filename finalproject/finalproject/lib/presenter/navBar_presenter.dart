import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view/DSTest.dart';
import '../view/SWETest.dart';
import '../view/homepage.dart';

class NavigationMenuPresenter extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [DJobListScreen(), JobListScreen()];

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }

  Widget get currentScreen => screens[selectedIndex.value];
}
