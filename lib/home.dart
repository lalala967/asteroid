import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:tflite_v2/tflite_v2.dart'; // Assuming you're using the tflite package

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output = '';

  @override
  void initState() {
    super.initState();
    loadCamera();
    loadModel();
  }

  @override
  void dispose() {
    // Dispose of cameraController and TensorFlow Lite to free resources
    cameraController?.dispose();
    Tflite.close(); // Free TensorFlow Lite resources
    super.dispose();
  }

  // Function to load available cameras
  loadCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        // Use lower resolution to reduce resource usage
        cameraController = CameraController(cameras[0], ResolutionPreset.low);
        await cameraController?.initialize();
        if (!mounted) return;

        setState(() {
          print("Camera initialized");
          cameraController!.startImageStream((imageStream) {
            cameraImage = imageStream;
            runModel();
          });
        });
      } else {
        print("No cameras found.");
      }
    } catch (e) {
     print("Error loading camera: $e");
    }
  }

  // Function to run the model on each frame
  runModel() async {
    if (cameraImage != null) {
      try {
        var predictions = await Tflite.runModelOnFrame(
          bytesList: cameraImage!.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: cameraImage!.height,
          imageWidth: cameraImage!.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          numResults: 2,
          threshold: 0.1,
          asynch: true,
        );
        setState(() {
          if (predictions != null && predictions.isNotEmpty) {
            output = predictions[0]['label']; // Get the first prediction
          }
        });
      } catch (e) {
        print("Error running model: $e");
      }
    }
  }

  // Function to load TensorFlow Lite model
  loadModel() async {
    try {
      await Tflite.loadModel(
        model: "assets/yolo.tflite",
        labels: "assets/label1.txt",
      );
      print("Model loaded successfully");
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: cameraController != null &&
                      cameraController!.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: cameraController!.value.aspectRatio,
                      child: CameraPreview(cameraController!),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ), // Show loading indicator
            ),
          ),
          Text(
            output,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
