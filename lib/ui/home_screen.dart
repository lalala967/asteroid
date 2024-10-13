import 'package:cmplt_app/core/utils/colors.dart';
import 'package:cmplt_app/features/object_detection/object_detection_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showObjectDetection = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onDoubleTap: () {
                // Toggle the display of object detection above the main content
                setState(() {
                  showObjectDetection = !showObjectDetection;
                });
              },
              onLongPress: () {
                print("Hii");
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 600,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: cntrclr,
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
          // Conditionally show the object detection screen overlayed
          if (showObjectDetection)
            Positioned.fill(
              child: ObjectDetectionScreen(),
            ),
        ],
      ),
    );
  }
}
