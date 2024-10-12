import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_page.dart'; // Import your home page
import 'screens/first_time_setup.dart'; // Import your first time setup page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VisionMate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
        future: _isSetupComplete(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data == true) {
            return const HomePage(); // If setup is done, go to home page
          } else {
            return const FirstTimeSetup(); // If setup is not done, go to setup page
          }
        },
      ),
    );
  }

  Future<bool> _isSetupComplete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_setup_complete') ?? false; // Defaults to false
  }
}
