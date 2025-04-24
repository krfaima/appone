

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  static Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw Exception(
          'Le service de localisation est désactivé. Veuillez l’activer.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permission de localisation refusée.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Les permissions de localisation sont définitivement refusées.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // static double calculateDistance(
  //     double lat1, double lon1, double lat2, double lon2) {
  //   return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  // }
  static double calculateDistance(
  double lat1, double lon1, double lat2, double lon2,
) {
  if (lat1 == 0 || lon1 == 0 || lat2 == 0 || lon2 == 0) {
    return double.infinity;
  }
  return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
}

  // 🔁 Suivre les mouvements en temps réel
  static Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 50, // En mètres — ne pas notifier à chaque petit mouvement
      ),
    );
  }

 

  determinePosition() {}
}
