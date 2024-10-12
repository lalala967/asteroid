import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tensflow/home.dart';

List<CameraDescription>? camera;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  camera = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TeserFlow(),
    );
  }
}

class TeserFlow extends StatelessWidget {
  const TeserFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blind App"),
        centerTitle: true,
      ),
      body: const Home(),
    );
  }
}
