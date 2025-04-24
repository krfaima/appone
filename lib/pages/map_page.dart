// // import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

// class MapPage extends StatelessWidget {
//   final double userLat;
//   final double userLng;
//   final double parkingLat;
//   final double parkingLng;

//   const MapPage({
//     Key? key,
//     required this.userLat,
//     required this.userLng,
//     required this.parkingLat,
//     required this.parkingLng,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final userPosition = LatLng(userLat, userLng);
//     final parkingPosition = LatLng(parkingLat, parkingLng);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Carte du parking'),
//         backgroundColor: const Color.fromARGB(255, 159, 185, 230),
//       ),
//       body: FlutterMap(
//         options: MapOptions(
//                     initialCenter: LatLng(userLat, userLng), 
//                     initialZoom: 15.0,
                  
//                   ),
//         children: [
//           TileLayer(
//             urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//             userAgentPackageName: 'com.example.appone',
//           ),
//        MarkerLayer(
//   markers: [
//     Marker(
//       point: parkingPosition,
//       width: 60,
//       height: 60,
//       child: Align(
//         alignment: Alignment.center,
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.red, // Background color for the marker
//             shape: BoxShape.circle, // Make it circular
//           ),
//           padding: const EdgeInsets.all(8),
//           child: const Icon(
//             Icons.local_parking,
//             color: Colors.white, // Icon color
//             size: 30, // Adjust size
//           ),
//         ),
//       ),
//     ),
//     Marker(
//       point: userPosition,
//       width: 60,
//       height: 60,
//       child: Align(
//         alignment: Alignment.center,
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.blue, // Background color for the marker
//             shape: BoxShape.circle, // Circular marker
//           ),
//           padding: const EdgeInsets.all(8),
//           child: const Icon(
//             Icons.person_pin_circle,
//             color: Colors.white, // Icon color
//             size: 30, // Adjust size
//           ),
//         ),
//       ),
//     ),
//   ],
// ),



//           PolylineLayer(
//             polylines: [
//               Polyline(
//                 points: [userPosition, parkingPosition],
//                 color: Colors.blue,
//                 strokeWidth: 4.0,
//               ),
//             ],
//           ),
//           CurrentLocationLayer(
//             positionStream: const LocationMarkerDataStreamFactory()
//                 .fromLocationStream(),
//             style: LocationMarkerStyle(
//               marker: const DefaultLocationMarker(),
//               markerSize: const Size(40, 40),
//               accuracyCircleColor: Colors.blue.withOpacity(0.15),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// extension on LocationMarkerDataStreamFactory {
//   fromLocationStream() {}
// }

// class MapPosition {
// }
// map_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
// import 'package:geolocator/geolocator.dart';

// class MapPage extends StatelessWidget {
//   final double userLat;
//   final double userLng;
//   final double parkingLat;
//   final double parkingLng;

//   const MapPage({
//     Key? key,
//     required this.userLat,
//     required this.userLng,
//     required this.parkingLat,
//     required this.parkingLng,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final userPosition = LatLng(userLat, userLng);
//     final parkingPosition = LatLng(parkingLat, parkingLng);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Carte du parking'),
//         backgroundColor: const Color.fromARGB(255, 159, 185, 230),
//       ),
//       body: FlutterMap(
//         options: MapOptions(
//           initialCenter: LatLng((userLat + parkingLat) / 2, (userLng + parkingLng) / 2), 
//           initialZoom: 14.0,
//         ),
//         children: [
//           TileLayer(
//             urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//             userAgentPackageName: 'com.example.appone',
//           ),
//           MarkerLayer(
//             markers: [
//               Marker(
//                 point: parkingPosition,
//                 width: 60,
//                 height: 60,
//                 child: Align(
//                   alignment: Alignment.center,
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       color: Colors.red,
//                       shape: BoxShape.circle,
//                     ),
//                     padding: const EdgeInsets.all(8),
//                     child: const Icon(
//                       Icons.local_parking,
//                       color: Colors.white,
//                       size: 30,
//                     ),
//                   ),
//                 ),
//               ),
//               Marker(
//                 point: userPosition,
//                 width: 60,
//                 height: 60,
//                 child: Align(
//                   alignment: Alignment.center,
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       color: Colors.blue,
//                       shape: BoxShape.circle,
//                     ),
//                     padding: const EdgeInsets.all(8),
//                     child: const Icon(
//                       Icons.person_pin_circle,
//                       color: Colors.white,
//                       size: 30,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           PolylineLayer(
//             polylines: [
//               Polyline(
//                 points: [userPosition, parkingPosition],
//                 color: Colors.blue,
//                 strokeWidth: 4.0,
//               ),
//             ],
//           ),
//           CurrentLocationLayer(
//             positionStream: const LocationMarkerDataStreamFactory().buildStream(
//               accuracy: true,
//               headingGetLocation: () async {
//                 return await Geolocator.getCurrentPosition();
//               },
//             ),
//             style: LocationMarkerStyle(
//               marker: const DefaultLocationMarker(),
//               markerSize: const Size(40, 40),
//               accuracyCircleColor: Colors.blue.withOpacity(0.15),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// extension on LocationMarkerDataStreamFactory {
//   buildStream({required bool accuracy, required Future<Position> Function() headingGetLocation}) {}
// }
// map_page.dart
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
    // Create LatLng objects safely
    final userPosition = LatLng(userLat, userLng);
    final parkingPosition = LatLng(parkingLat, parkingLng);
    
    // Calculate center point and zoom level for the map
    final centerLat = (userLat + parkingLat) / 2;
    final centerLng = (userLng + parkingLng) / 2;
    
    // Calculate appropriate zoom level based on distance
    final distLat = (userLat - parkingLat).abs();
    final distLng = (userLng - parkingLng).abs();
    final maxDist = distLat > distLng ? distLat : distLng;
    final zoom = maxDist > 0.1 ? 10.0 : maxDist > 0.05 ? 12.0 : maxDist > 0.01 ? 14.0 : 15.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carte du parking'),
        backgroundColor: const Color.fromARGB(255, 159, 185, 230),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(centerLat, centerLng),
          initialZoom: 10,
        ),
        children: [
          // Base map layer
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.appone',
          ),
          
          // Markers layer
          MarkerLayer(
            markers: [
              // Parking marker
              Marker(
                point: parkingPosition,
                width: 50,
                height: 50,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.local_parking,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 1,
                          ),
                        ],
                      ),
                      child: const Text(
                        'Parking',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // User marker
              Marker(
                point: userPosition,
                width: 50,
                height: 50,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.person_pin_circle,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          
          // Line connecting user to parking
          PolylineLayer(
            polylines: [
              Polyline(
                points: [userPosition, parkingPosition],
                color: Colors.blue,
                strokeWidth: 4.0,
                // isDotted: true, // Removed as it is not a valid parameter
              ),
            ],
          ),
          
          // Current location layer
          CurrentLocationLayer(
            style: LocationMarkerStyle(
              marker: const DefaultLocationMarker(
                color: Colors.blue,
                child: Icon(
                  Icons.my_location,
                  color: Colors.white,
                  size: 14,
                ),
              ),
              markerSize: const Size(24, 24),
              accuracyCircleColor: Colors.blue.withOpacity(0.15),
              headingSectorColor: Colors.blue.withOpacity(0.4),
            ),
          ),
        ],
      ),
      // Add a fab to recenter map
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.white,
        onPressed: () {
          // Navigate to current page again to refresh
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(
              builder: (_) => MapPage(
                userLat: userLat,
                userLng: userLng,
                parkingLat: parkingLat,
                parkingLng: parkingLng,
              ),
            ),
          );
        },
        child: const Icon(Icons.my_location, color: Colors.blue),
      ),
    );
  }
}