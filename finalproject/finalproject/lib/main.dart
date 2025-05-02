import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../view/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color.fromARGB(255, 17, 84, 116),
          selectionColor: Color.fromARGB(100, 34, 124, 157),
          selectionHandleColor: Color.fromARGB(255, 17, 84, 116),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: const Color.fromARGB(255, 17, 84, 116),
        ),
      ),
      home: const MyLoginPage(title: 'login Page'),
    );
  }
}
