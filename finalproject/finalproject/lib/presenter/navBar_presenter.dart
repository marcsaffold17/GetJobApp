import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view/DSTest_view.dart';
import '../view/homepage_view.dart';
import '../view/SWESearch_view.dart';
import '../view/tab_view.dart';
import '../view/favorites.dart';

class NavigationMenuPresenter extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [MyHomePage(), TabViewPage(), FavoritesPage()];

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }

  Widget get currentScreen => screens[selectedIndex.value];
}
