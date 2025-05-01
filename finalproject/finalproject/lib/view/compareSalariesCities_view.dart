import 'package:flutter/material.dart';

class CompareCitiesScreen extends StatefulWidget {
  @override
  _CompareCitiesScreen createState() => _CompareCitiesScreen();
}

class _CompareCitiesScreen extends State<CompareCitiesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Compare Cities'),),
      body: Center(
        child: Text(
          "Hello World!!"
        ),
      ),
    );
  }
}