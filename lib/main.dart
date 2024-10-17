import 'package:flutter/material.dart';
import 'package:location/location.dart';

void main() {
  runApp(LocationApp());
}

class LocationApp extends StatefulWidget {
  @override
  _LocationAppState createState() => _LocationAppState();
}

class _LocationAppState extends State<LocationApp> {
  Location location = new Location();
  bool _serviceEnabled = false;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    // Check if the service is enabled
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Check for permission
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Get the location data
    _locationData = await location.getLocation();

    // Update the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Offline Location Detection'),
        ),
        body: Center(
          // ignore: unnecessary_null_comparison
          child: _locationData != null
              ? Text(
                  'Location: \nLatitude: ${_locationData.latitude}\nLongitude: ${_locationData.longitude}',
                  textAlign: TextAlign.center,
                )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
