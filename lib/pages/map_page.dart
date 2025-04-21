import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

class MapPage extends StatelessWidget {
  final double userLat;
  final double userLng;
  final double parkingLat;
  final double parkingLng;

  const MapPage({
    Key? key,
    required this.userLat,
    required this.userLng,
    required this.parkingLat,
    required this.parkingLng,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userPosition = LatLng(userLat, userLng);
    final parkingPosition = LatLng(parkingLat, parkingLng);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carte du parking'),
        backgroundColor: const Color.fromARGB(255, 159, 185, 230),
      ),
      body: FlutterMap(
  options: MapOptions(
    initialCenter: userPosition,
    initialZoom: 14.0,
  ),
  children: [
    TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.example.appone',
    ),
    MarkerLayer(
      markers: [
        Marker(
          point: userPosition,
          width: 60,
          height: 60,
          child: const Icon(Icons.person_pin_circle,
              color: Colors.blue, size: 40),
        ),
        Marker(
          point: parkingPosition,
          width: 60,
          height: 60,
          child: const Icon(Icons.local_parking,
              color: Colors.red, size: 40),
        ),
      ],
    ),
    PolylineLayer(
      polylines: [
        Polyline(
          points: [userPosition, parkingPosition],
          color: Colors.blue,
          strokeWidth: 4.0,
        ),
      ],
    ),

          // Affiche le pointeur de localisation (optionnel)
          CurrentLocationLayer(),
        ],
      ),
    );
  }
}
