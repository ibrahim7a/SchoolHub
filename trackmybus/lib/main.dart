import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const TrackMyBusApp());
}

class TrackMyBusApp extends StatelessWidget {
  const TrackMyBusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SchoolHub',
      home: const SplashScreen(),
    );
  }
}
