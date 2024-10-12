import 'package:flutter/material.dart';
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
  int _selectedIndex = 0;

  // A list of widgets that correspond to each page
  static final List<Widget> _pages = <Widget>[
    SettingsPage(), // First tab for Camera
    // ignore: prefer_const_constructors
    CameraScreen(), // Second tab for Settings
    LocationPage(), // Third tab for Location
  ];

  // This method handles the tap on the Bottom Navigation Bar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VisionMate'), // Title of the App
        actions: [
          // Optional top right widget, e.g., light/dark mode toggle
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              // Toggle action can be added later
            },
          ),
        ],
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex), // Show the current page
      ),
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
        currentIndex: _selectedIndex, // The currently selected index
        selectedItemColor: Colors.blue, // Active icon color
        onTap: _onItemTapped, // Handle bottom navigation taps
      ),
    );
  }
}
