import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view/homepage_view.dart';
import '../view/tab_view.dart';
import '../view/favorites.dart';
import '../view/video_page.dart';

class NavigationMenuPresenter extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [MyHomePage(), TabViewPage(), FavoritesPage(), VideoPage()];

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }

  Widget get currentScreen => screens[selectedIndex.value];
}
