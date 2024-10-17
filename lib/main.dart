import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:flutter_tts/flutter_tts.dart';

// Global variable for camera access
late List<CameraDescription> camerass;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  camerass = await availableCameras(); // Initialize the available cameras

  runApp(const MaterialApp(
    home: YoloVideo(),
  ));
}

class YoloVideo extends StatefulWidget {
  const YoloVideo({Key? key}) : super(key: key);

  @override
  State<YoloVideo> createState() => _YoloVideoState();
}

class _YoloVideoState extends State<YoloVideo> {
  // Declare needed variables
  late CameraController controller;
  late FlutterVision vision;
  late List<Map<String, dynamic>> yoloResults;
  CameraImage? cameraImage;
  bool isLoaded = false;
  bool isDetecting = false;
  double confidenceThreshold = 0.5;

  // Variables for speech and tracking
  FlutterTts tts = FlutterTts();
  String previousResult = "";
  DateTime previousSpeechTime = DateTime.now();
  Duration repeatDuration = const Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    camerass = await availableCameras(); // Fetch available cameras
    vision = FlutterVision(); // Initialize FlutterVision
    controller = CameraController(
      camerass[0],
      ResolutionPreset.Ultrahigh, // Use Ultrahigh resolution
      enableAudio: false, // Disable audio
    );

    await controller.initialize();
    await loadYoloModel();

    setState(() {
      isLoaded = true;
      isDetecting = false;
      yoloResults = [];
    });
  }

  @override
  void dispose() async {
    super.dispose();
    controller.dispose();
    await vision.closeYoloModel();
  }

  // Loading YOLO model with error handling
  Future<void> loadYoloModel() async {
    try {
      await vision.loadYoloModel(
        labels: 'assets/labels.txt', // Updated labels file
        modelPath: 'assets/yolov8n.tflite', // Updated model file
        modelVersion: "yolov8", // You can keep this or change as needed
        numThreads: 1,
        useGpu: false, // Change to false if GPU issues arise
      );
      setState(() {
        isLoaded = true;
      });
    } catch (e) {
      print("Error loading YOLO model: $e");
      setState(() {
        isLoaded = false; // Update the state if the model fails to load
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    if (!isLoaded) {
      return const Scaffold(
        body: Center(
          child: Text("Model not loaded, waiting for it"),
        ),
      );
    }
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(controller),
          ),
          ...displayBoxesAroundRecognizedObjects(size),
          Positioned(
            bottom: 75,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 5,
                  color: Colors.white,
                  style: BorderStyle.solid,
                ),
              ),
              child: isDetecting
                  ? IconButton(
                      onPressed: () async {
                        stopDetection();
                      },
                      icon: const Icon(
                        Icons.stop,
                        color: Colors.red,
                      ),
                      iconSize: 50,
                    )
                  : IconButton(
                      onPressed: () async {
                        await startDetection();
                      },
                      icon: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      ),
                      iconSize: 50,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // Real-time object detection function
  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    final result = await vision.yoloOnFrame(
      bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
      imageHeight: cameraImage.height,
      imageWidth: cameraImage.width,
      iouThreshold: 0.4,
      confThreshold: 0.4,
      classThreshold: 0.5,
    );

    if (result.isNotEmpty) {
      setState(() {
        yoloResults = result;
      });
    }
  }

// Start video stream and detection
  Future<void> startDetection() async {
    setState(() {
      isDetecting = true;
    });

    if (controller.value.isStreamingImages) {
      return;
    }

    int frameCount = 0; // Initialize frameCount here
    const int processEveryNthFrame = 3; // Process every 3rd frame

    await controller.startImageStream((image) async {
      if (isDetecting) {
        cameraImage = image;
        frameCount++; // Increment frameCount

        // Process every 3rd frame
        if (frameCount % processEveryNthFrame == 0) {
          yoloOnFrame(image);
        }
      }
    });
  }

  // Stop detection
  Future<void> stopDetection() async {
    setState(() {
      isDetecting = false;
      yoloResults.clear();
    });
  }

  // Display bounding boxes around detected objects
  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];

    double factorX = screen.width / (cameraImage?.height ?? 1);
    double factorY = screen.height / (cameraImage?.width ?? 1);
    Color colorPick = const Color.fromARGB(255, 50, 233, 30);

    return yoloResults.map((result) {
      double objectX = result["box"][0] * factorX;
      double objectY = result["box"][1] * factorY;
      double objectWidth = (result["box"][2] - result["box"][0]) * factorX;
      double objectHeight = (result["box"][3] - result["box"][1]) * factorY;

      // Speech function to announce detected objects
      void speak() {
        String currentResult = result['tag'].toString();
        DateTime currentTime = DateTime.now();

        if (currentResult != previousResult ||
            currentTime.difference(previousSpeechTime) >= repeatDuration) {
          tts.speak(currentResult);
          previousResult = currentResult;
          previousSpeechTime = currentTime;
        }
      }

      speak();

      return Positioned(
        left: objectX,
        top: objectY,
        width: objectWidth,
        height: objectHeight,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
            "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(2)}%",
            style: TextStyle(
              background: Paint()..color = colorPick,
              color: const Color.fromARGB(255, 115, 0, 255),
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }
}
