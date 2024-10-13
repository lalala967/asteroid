import 'package:cmplt_app/bloc/object_detect_bloc/bloc/object_det_bloc.dart';
import 'package:cmplt_app/core/utils/colors.dart';
import 'package:cmplt_app/features/object_detection/object_detection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onDoubleTap: () {
                // Trigger the toggle event in the Bloc
                bool isCurrentlyShowing =
                    context.read<ObjectDetBloc>().state is DetectObjectState;
                context
                    .read<ObjectDetBloc>()
                    .add(DetectObjectEvent(isState: !isCurrentlyShowing));
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
          // Conditionally show the object detection screen based on Bloc state
          Positioned.fill(
            child: BlocBuilder<ObjectDetBloc, ObjectDetState>(
              builder: (context, state) {
                if (state is DetectObjectState) {
                  return const ObjectDetectionScreen();
                }
                return Container(); // Empty container when the object detection screen is inactive
              },
            ),
          ),
        ],
      ),
    );
  }
}
