// import 'package:flutter/material.dart';
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
                    initialCenter: LatLng(userLat, userLng), 
                    initialZoom: 15.0,
                  
                  ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.appone',
          ),
       MarkerLayer(
  markers: [
    Marker(
      point: parkingPosition,
      width: 60,
      height: 60,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red, // Background color for the marker
            shape: BoxShape.circle, // Make it circular
          ),
          padding: const EdgeInsets.all(8),
          child: const Icon(
            Icons.local_parking,
            color: Colors.white, // Icon color
            size: 30, // Adjust size
          ),
        ),
      ),
    ),
    Marker(
      point: userPosition,
      width: 60,
      height: 60,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue, // Background color for the marker
            shape: BoxShape.circle, // Circular marker
          ),
          padding: const EdgeInsets.all(8),
          child: const Icon(
            Icons.person_pin_circle,
            color: Colors.white, // Icon color
            size: 30, // Adjust size
          ),
        ),
      ),
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
          CurrentLocationLayer(
            positionStream: const LocationMarkerDataStreamFactory()
                .fromLocationStream(),
            style: LocationMarkerStyle(
              marker: const DefaultLocationMarker(),
              markerSize: const Size(40, 40),
              accuracyCircleColor: Colors.blue.withOpacity(0.15),
            ),
          ),
        ],
      ),
    );
  }
}

extension on LocationMarkerDataStreamFactory {
  fromLocationStream() {}
}

class MapPosition {
}
