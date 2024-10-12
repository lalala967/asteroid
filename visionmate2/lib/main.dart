import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/setup_screen.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const VisionMateApp());
}

class VisionMateApp extends StatelessWidget {
  const VisionMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VisionMate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/setup': (context) => SetupScreen(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
