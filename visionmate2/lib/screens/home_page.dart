import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'camera_screen.dart';
import 'settings_page.dart';
import 'location_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Default index to Camera (center tab)
  int _selectedIndex = 1;

  // Pages for each tab
  static final List<Widget> _pages = <Widget>[
    SettingsPage(), // First tab (Settings)
    CameraScreen(), // Second tab (Camera, default)
    const LocationPage(), // Third tab (Location)
  ];

  // Handles tapping on Bottom Navigation Bar items
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove AppBar for CameraScreen
      appBar: _selectedIndex == 1
          ? null
          : AppBar(
              title:
                  const Text('VisionMate'), // Shown only for non-camera pages
              actions: [
                IconButton(
                  icon: const Icon(Icons.brightness_6),
                  onPressed: () => _showThemeDialog(context), // Theme dialog
                ),
              ],
            ),
      body: _pages[_selectedIndex], // Displays the current page
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Location',
          ),
        ],
        currentIndex: _selectedIndex, // Keeps track of the current tab
        selectedItemColor: Colors.blue, // Active icon color
        onTap: _onItemTapped, // Handles taps on the BottomNavigationBar
      ),
    );
  }

  // Function to show the theme dialog
  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Light'),
                onTap: () {
                  AdaptiveTheme.of(context).setLight();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Dark'),
                onTap: () {
                  AdaptiveTheme.of(context).setDark();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('System Default'),
                onTap: () {
                  AdaptiveTheme.of(context).setSystem();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
