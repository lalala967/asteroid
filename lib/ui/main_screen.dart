import 'package:flutter/material.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'package:tech_pirates/core/utils/text.dart';
import 'package:tech_pirates/ui/home.dart';
import 'package:tech_pirates/ui/setting.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blindly'),
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: const <Widget>[
          HomeScreen(),
          Setting(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BottomBar(
          selectedIndex: _selectedIndex,
          onTap: (int index) {
            _pageController.jumpToPage(index);
            setState(() => _selectedIndex = index);
          },
          items: const <BottomBarItem>[
            BottomBarItem(
              icon: Icon(
                Icons.home,
                size: 50,
              ),
              title: NavText(title: "Home"),
              activeColor: Colors.blue, // Reduced padding
            ),
            BottomBarItem(
              icon: Icon(
                Icons.settings,
                size: 50,
              ),
              title: NavText(title: "Setting"),
              activeColor: Colors.orange,

              // Reduced padding
            ),
          ],
        ),
      ),
    );
  }
}
