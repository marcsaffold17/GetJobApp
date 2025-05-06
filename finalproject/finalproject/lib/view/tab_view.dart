import '../presenter/tab_presenter.dart';
import 'package:flutter/material.dart';
import '../view/SWESearch_view.dart';
import '../view/DSTest_view.dart';

class TabViewPage extends StatefulWidget {
  const TabViewPage({super.key});

  @override
  _TabViewPageState createState() => _TabViewPageState();
}

class _TabViewPageState extends State<TabViewPage>
    with SingleTickerProviderStateMixin {
  final TabPresenter presenter = TabPresenter();

  @override
  void initState() {
    super.initState();
    presenter.init(this, 2);
  }

  @override
  void dispose() {
    presenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        toolbarHeight: 15,
        backgroundColor: Color.fromARGB(255, 0, 43, 75),
        bottom: TabBar(
          dividerColor: Colors.transparent,
          padding: EdgeInsets.only(bottom: 15),
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Color.fromARGB(200, 22, 94, 127),
          ),
          unselectedLabelColor: Color.fromARGB(200, 230, 230, 226),
          labelStyle: TextStyle(
            fontFamily: 'inter',
            color: Color.fromARGB(255, 244, 243, 240),
          ),
          controller: presenter.tabController,
          // tabs: const [Tab(text: 'SWE'), Tab(text: 'DS')]
          tabs: [
            Tab(
              child: Container(
                width: 140,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30), // Circular border
                ),
                child: Text(
                  'Software Engineering',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Tab(
              child: Container(
                width: 140,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30), // Circular border
                ),
                child: Text('Data Science', textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: presenter.tabController,
        children: [SWESearchView(), DJobListScreen()],
      ),
    );
  }
}
