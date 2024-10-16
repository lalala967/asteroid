import 'dart:async'; // Import required for StreamSubscription
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'location.dart'; // Import your location map widget

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OSM Flutter Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MapHandler(), // Call the map handler that checks connectivity
    );
  }
}

class MapHandler extends StatefulWidget {
  const MapHandler({super.key});

  @override
  _MapHandlerState createState() => _MapHandlerState();
}

class _MapHandlerState extends State<MapHandler> {
  bool _isConnected = false;
  bool _isCheckingConnection = true; // To show a loader while checking
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initializeConnection();
    _listenToConnectionChanges();
  }

  @override
  void dispose() {
    _connectivitySubscription
        .cancel(); // Cancel the subscription to avoid memory leaks
    super.dispose();
  }

  Future<void> _initializeConnection() async {
    setState(() {
      _isCheckingConnection = true; // Start the connection check
    });

    var result = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi;
      _isCheckingConnection = false; // Connection check is done
    });
  }

  void _listenToConnectionChanges() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      setState(() {
        _isConnected = results.any((result) =>
            result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingConnection) {
      // While checking the connection status, show a loader
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_isConnected) {
      // Show a dialog if there's no internet connection
      return Scaffold(
        body: Center(
          child: AlertDialog(
            title: const Text("No Internet"),
            content:
                const Text("Please connect to the internet to load the map."),
            actions: [
              TextButton(
                onPressed: () {
                  _initializeConnection(); // Retry button to recheck the connection
                },
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    // Show the map if connected
    return const LocationMap();
  }
}
