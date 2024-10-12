import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For locking orientation

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? controller;
  late List<CameraDescription> cameras;
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    WidgetsBinding.instance.addObserver(this);
    _lockOrientation();
  }

  Future<void> _initializeCamera() async {
    // Get available cameras
    cameras = await availableCameras();

    // Initialize camera controller for the first camera (rear camera by default)
    controller = CameraController(
      cameras[0],
      ResolutionPreset.high,
    );

    await controller?.initialize();
    if (!mounted) return;

    setState(() {
      isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _unlockOrientation();
    super.dispose();
  }

  // Lock orientation to portrait and landscape modes
  void _lockOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  // Unlock orientation when leaving camera screen
  void _unlockOrientation() {
    SystemChrome.setPreferredOrientations([]);
  }

  @override
  void didChangeMetrics() {
    // Called when orientation changes
    if (controller != null && controller!.value.isInitialized) {
      setState(() {}); // Refresh the view on orientation change
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isCameraInitialized || !controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Camera')),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Center(
            child: AspectRatio(
              aspectRatio: orientation == Orientation.portrait
                  ? 1 / controller!.value.aspectRatio
                  : controller!.value.aspectRatio,
              child: CameraPreview(controller!),
            ),
          );
        },
      ),
    );
  }
}
