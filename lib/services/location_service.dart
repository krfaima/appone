// import 'package:geolocator/geolocator.dart';

// class LocationService {
//   static Future<Position> getCurrentPosition() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Les services de localisation sont désactivés.');
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Permission refusée.');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error('Permission refusée définitivement.');
//     }

//     return await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//   }

//   static double calculateDistance(
//       double startLatitude,
//       double startLongitude,
//       double endLatitude,
//       double endLongitude) {
//     return Geolocator.distanceBetween(
//         startLatitude, startLongitude, endLatitude, endLongitude);
//   }

//   determinePosition() {}
// }
import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Récupère la position actuelle avec gestion des permissions
  static Future<Position?> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Service de localisation désactivé.");
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Permission localisation refusée.");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Permission localisation définitivement refusée.");
      return null;
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Calcule la distance en mètres entre deux points
  static double calculateDistance(
      double startLatitude,
      double startLongitude,
      double endLatitude,
      double endLongitude) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  determinePosition() {}
}
