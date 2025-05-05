import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../view/login_view.dart';
import '../view/theme_notifier.dart'; // update this path as necessary

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier()..setDarkMode(isDarkMode),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF002B4B),
          brightness: Brightness.light,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color.fromARGB(255, 17, 84, 116),
          selectionColor: Color.fromARGB(100, 34, 124, 157),
          selectionHandleColor: Color.fromARGB(255, 17, 84, 116),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Color.fromARGB(255, 17, 84, 116),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF002B4B),
          brightness: Brightness.dark,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color.fromARGB(255, 17, 84, 116),
          selectionColor: Color.fromARGB(100, 34, 124, 157),
          selectionHandleColor: Color.fromARGB(255, 17, 84, 116),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Color.fromARGB(255, 17, 84, 116),
        ),
      ),
      themeMode: themeNotifier.currentTheme,
      home: const MyLoginPage(title: 'Login Page'),
    );
  }
}
