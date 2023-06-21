import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapViewPage extends StatefulWidget {
  @override
  _MapViewPageState createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapViewPage> {
  GoogleMapController? _mapController;
  Location _location = Location();
  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    final status = await _location.requestPermission();
    setState(() {
      _permissionGranted = status == PermissionStatus.granted;
    });
  }

  // Future<void> _centerMapOnUser() async {
  //   if (_mapController != null && _permissionGranted) {
  //     final locationData = await _location.getLocation();
  //     _mapController!.animateCamera(
  //       CameraUpdate.newLatLng(LatLng(locationData.latitude!, locationData.longitude!)),
  //     );
  //   }
  // }
  Future<void> _centerMapOnUser() async {
    if (_mapController != null && _permissionGranted) {
      final locationData = await _location.getLocation();
      final target = LatLng(locationData.latitude!, locationData.longitude!);
      final zoomLevel = 18.0;

      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(target, zoomLevel),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Master-Dipankar'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              setState(() {
                _mapController = controller;
              });
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(0, 0),
              zoom: 16,
            ),
            myLocationEnabled: true,
          ),
          Container(
            width: 100,
            height: 100,
            child: FloatingActionButton(
              onPressed: _centerMapOnUser,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Almighty ',
                    style: TextStyle(fontSize: 12),
                  ),
                  Icon(Icons.gps_fixed, size: 12),
                  Text(
                    ' Push',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
