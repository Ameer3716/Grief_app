import 'package:flutter/material.dart';
import 'screen/welcome_screen.dart'; // Make sure this path is correct

void main() {
  runApp(const SpiritualCompanionApp());
}

class SpiritualCompanionApp extends StatelessWidget {
  const SpiritualCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spiritual Companion',
      theme: ThemeData(fontFamily: 'Georgia'),
      home: const WelcomeScreen(),
    );
  }
}
