import 'package:flutter/material.dart';
import 'menu_page.dart'; // Import the MenuPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness Forge',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MenuPage(),
    );
  }
}
