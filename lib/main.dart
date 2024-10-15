import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';

// Controller for loading the YOLO model
class LoaderController {
  static Future<void> loadModel() async {
    await Tflite.loadModel(
      model: "assets/model/yolo.tflite", // YOLO model path
      labels: "assets/model/labels.txt", // Labels (optional)
      isAsset: true,
      useGpuDelegate: false,
    );
  }
}

class LiveView extends StatefulWidget {
  const LiveView({super.key});

  @override
  _LiveViewState createState() => _LiveViewState();
}

class _LiveViewState extends State<LiveView> {
  late CameraController _cameraController;
  bool isDetecting = false;
  List<dynamic>? _recognitions;
  late List<CameraDescription> cameras;

  @override
  void initState() {
    super.initState();
    _initCamera();
    _loadModel();
  }

  // Load YOLO model
  Future<void> _loadModel() async {
    await LoaderController.loadModel();
    setState(() {});
  }

  // Initialize the camera for live feed
  Future<void> _initCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    await _cameraController.initialize();
    _cameraController.startImageStream((CameraImage img) {
      if (!isDetecting) {
        isDetecting = true;
        _runModelOnFrame(img);
      }
    });
    setState(() {});
  }

  // Run YOLO inference on each frame
  Future<void> _runModelOnFrame(CameraImage image) async {
    var recognitions = await Tflite.detectObjectOnFrame(
      bytesList: image.planes.map((plane) => plane.bytes).toList(),
      model: "YOLO",
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 0,
      imageStd: 255.0,
      numResultsPerClass: 1,
      threshold: 0.3, // Confidence threshold
    );

    setState(() {
      _recognitions = recognitions;
      isDetecting = false;
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    Tflite.close();
    super.dispose();
  }

  // Draw bounding boxes for recognized objects
  List<Widget> _buildBoundingBoxes(Size screen) {
    if (_recognitions == null) return [];

    double factorX = screen.width;
    double factorY = screen.height;

    return _recognitions!.map((re) {
      var x = re["rect"]["x"] * factorX;
      var y = re["rect"]["y"] * factorY;
      var w = re["rect"]["w"] * factorX;
      var h = re["rect"]["h"] * factorY;

      return Positioned(
        left: x,
        top: y,
        width: w,
        height: h,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.red,
              width: 3,
            ),
          ),
          child: Text(
            "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
            style: const TextStyle(
              color: Colors.white,
              backgroundColor: Colors.red,
              fontSize: 12,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraController.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('YOLO Live Object Detection'),
      ),
      body: Stack(
        children: [
          CameraPreview(_cameraController),
          ..._buildBoundingBoxes(MediaQuery.of(context).size),
        ],
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LoaderController.loadModel();
  runApp(const MaterialApp(home: LiveView()));
}
