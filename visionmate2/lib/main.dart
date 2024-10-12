import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'screens/home_page.dart'; // Import your home page
import 'screens/first_time_setup.dart'; // Import your first time setup page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AdaptiveThemeMode?>(
      future: _getSavedThemeMode(),
      builder: (context, snapshot) {
        // If theme is being fetched, display loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // If we have a saved theme or system default, proceed
        AdaptiveThemeMode initialTheme =
            snapshot.data ?? AdaptiveThemeMode.system;

        return AdaptiveTheme(
          light: ThemeData.light(),
          dark: ThemeData.dark(),
          initial: initialTheme,
          builder: (theme, darkTheme) => MaterialApp(
            title: 'VisionMate',
            theme: theme,
            darkTheme: darkTheme,
            home: FutureBuilder<bool>(
              future: _isSetupComplete(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data == true) {
                  return const HomePage(); // Go to home if setup is complete
                } else {
                  return const FirstTimeSetup(); // Otherwise, start setup
                }
              },
            ),
          ),
        );
      },
    );
  }

  Future<bool> _isSetupComplete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_setup_complete') ?? false; // Defaults to false
  }

  // Fetch the saved theme mode from storage
  Future<AdaptiveThemeMode?> _getSavedThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedTheme = prefs.getString('theme_mode');
    if (savedTheme == null) {
      return null;
    }
    return AdaptiveThemeMode.values
        .firstWhere((e) => e.toString() == savedTheme);
  }
}
