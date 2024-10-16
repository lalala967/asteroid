// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart'; // For caching
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart'; // For listening to location changes

class LocationMap extends StatefulWidget {
  const LocationMap({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LocationMapState createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  LocationData? _currentLocation;
  bool _loading = true;
  bool _permissionDenied = false;
  bool _isDownloading = false; // Track if map tiles are being downloaded
  bool _enableCustomMarkers = false; // Track custom markers toggle
  final MapController _mapController = MapController();

  // Initialize the location service
  final Location _locationService = Location();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

    // Initialize the caching options for the map tiles
    FMTC.instance('openstreetmap').tileProvider = CachedNetworkTileProvider();
    FMTC.instance('openstreetmap').storeTileLayerOptions = TileLayerOptions(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.example.app',
    );

    // Listen to location changes
    Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _currentLocation = LocationData.fromMap({
          'latitude': position.latitude,
          'longitude': position.longitude,
        });
      });
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if location services are enabled
    serviceEnabled = await _locationService.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationService.requestService();
      if (!serviceEnabled) {
        setState(() {
          _loading = false;
        });
        return;
      }
    }

    // Check location permission
    permissionGranted = await _locationService.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationService.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        setState(() {
          _permissionDenied = true;
          _loading = false;
        });
        return;
      }
    }

    // Get the current location
    final locationData = await _locationService.getLocation();
    setState(() {
      _currentLocation = locationData;
      _loading = false;
    });
  }

  // Function to download the map tiles for offline use
  Future<void> _downloadMapTiles() async {
    setState(() {
      _isDownloading = true;
    });

    // Define the region to download (current location with some buffer)
    final bounds = LatLngBounds(
      LatLng(_currentLocation!.latitude! - 0.05,
          _currentLocation!.longitude! - 0.05),
      LatLng(_currentLocation!.latitude! + 0.05,
          _currentLocation!.longitude! + 0.05),
    );

    final store = FMTC.instance('openstreetmap');

    try {
      // Download tiles between zoom levels 10 and 16
      await StoreService().downloadTiles(
        store: store.store,
        bounds: bounds,
        minZoom: 10,
        maxZoom: 16,
        downloadForeground: true,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Map tiles downloaded successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading tiles: $e')),
      );
    }

    setState(() {
      _isDownloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_permissionDenied) {
      return Scaffold(
        appBar: AppBar(title: const Text('Permission Denied')),
        body: const Center(
          child: Text(
              'Location permission is denied. Please enable it in settings.'),
        ),
      );
    }

    if (_currentLocation == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Location Error')),
        body: const Center(
          child: Text('Unable to retrieve location data.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Location on Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _isDownloading
                ? null
                : _downloadMapTiles, // Disable button while downloading
          ),
        ],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          onTap: (tapPosition, point) {
            // Handle tap event here
          },
          minZoom: 10.0,
          maxZoom: 16.0,
          onLongPress: (tapPosition, point) {
            _showAddMarkerDialog(context, point);
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            tileProvider: FMTC.instance('openstreetmap').getTileProvider(
                  FMTCTileProviderSettings(
                    behavior: CacheBehavior.cacheOnly,
                    cachedValidDuration: const Duration(days: 7),
                    maxStoreLength: 10000,
                  ),
                ),
          ),
          // Marker Layer
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(
                  _currentLocation!.latitude!,
                  _currentLocation!.longitude!,
                ),
                builder: (ctx) => Container(
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40.0,
                  ),
                ),
              ),
            ],
          ),
          // Other Layers (like bathymetry if needed)
        ],
      ),
      floatingActionButton: Positioned(
        bottom: 60,
        left: 10,
        child: IconButton(
          onPressed: () {
            setState(() {
              _enableCustomMarkers = !_enableCustomMarkers;
            });
          },
          icon: _enableCustomMarkers
              ? const Icon(Icons.toggle_on_rounded)
              : const Icon(Icons.toggle_off_rounded),
        ),
      ),
    );
  }

  // Show dialog to add marker
  Future<void> _showAddMarkerDialog(
      BuildContext context, LatLng position) async {
    // Custom logic to add marker at the pressed position
  }
}

// Service class to handle downloading
class StoreService {
  Future<void> downloadTiles({
    required StoreDirectory store,
    required LatLngBounds bounds,
    required int minZoom,
    required int maxZoom,
    required bool downloadForeground,
  }) async {
    final metadata = await store.metadata.readAsync;
    final region = RegionService().getBaseMapRegionFromCoordinates(bounds);

    if (downloadForeground) {
      setDownloadProgress(
        store.download
            .startForeground(
              region: region!.toDownloadable(minZoom, maxZoom,
                  TileLayer(urlTemplate: metadata['sourceURL'])),
              seaTileRemoval: false,
              parallelThreads: 5,
            )
            .asBroadcastStream(),
      );
    } else {
      store.download.startBackground(
        region: region!.toDownloadable(
            minZoom, maxZoom, TileLayer(urlTemplate: metadata['sourceURL'])),
        seaTileRemoval: false,
        parallelThreads: 5,
      );
    }
  }

  void setDownloadProgress(Stream<DownloadProgress> progressStream) {
    progressStream.listen((progress) {
      // Handle download progress updates here
      print('Download progress: ${progress.progressPercentage}%');
    });
  }
}
