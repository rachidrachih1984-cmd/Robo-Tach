import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(const RoboTachApp());

class RoboTachApp extends StatelessWidget {
  const RoboTachApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Robo-Tach',
    theme: ThemeData(brightness: Brightness.dark, useMaterial3: true, colorSchemeSeed: Colors.cyan, scaffoldBackgroundColor: const Color(0xFF07111F)),
    home: const HomeScreen(),
  );
}
