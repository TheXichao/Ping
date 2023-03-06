import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';

class MapViewScreen extends StatefulWidget {
  @override
  _MapViewScreenState createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  Completer<GoogleMapController> _controller = Completer();
  LocationData _currentLocation =
      LocationData.fromMap({'latitude': 0.0, 'longitude': 0.0});

  static final CameraPosition _initialLocation = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 14.0,
  );

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    Location location = new Location();

    try {
      _currentLocation = await location.getLocation();
    } catch (e) {
      print(e);
      _currentLocation =
          LocationData.fromMap({'latitude': 0.0, 'longitude': 0.0});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map View'),
      ),
      body: GoogleMap(
        initialCameraPosition: _initialLocation,
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        markers: Set<Marker>.of([
          Marker(
            markerId: MarkerId('userLocation'),
            position:
                LatLng(_currentLocation?.latitude ?? 0.0, _currentLocation?.longitude ?? 0.0),
,
            infoWindow: InfoWindow(title: 'Your Location'),
          ),
        ]),
      ),
    );
  }
}


