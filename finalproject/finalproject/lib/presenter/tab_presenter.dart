import 'package:flutter/material.dart';

class TabPresenter {
  late TabController tabController;

  void init(TickerProvider vsync, int tabCount) {
    tabController = TabController(length: tabCount, vsync: vsync);
  }

  void dispose() {
    tabController.dispose();
  }

  void switchToTab(int index) {
    tabController.index = index;
  }

  int get currentIndex => tabController.index;
}
