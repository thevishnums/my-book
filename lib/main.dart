import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(MyBooksApp());
}

class MyBooksApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Book Library',
      themeMode: ThemeMode.system, // Supports both Light & Dark Theme based on settings
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.light),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: LoginScreen(),
    );
  }
}