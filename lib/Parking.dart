// class Parking {
//   final int id;
//   final String nom;
//   final String ville;
//   final int nombreTotalPlaces;
//   final int placesDisponibles;
//   final String? imageUrl;
//   final double latitude;
//   final double longitude;
//   double? distance; // ← Ajouté


//   Parking({
//     required this.id,
//     required this.nom,
//     required this.ville,
//     required this.nombreTotalPlaces,
//     required this.placesDisponibles,
//     this.imageUrl,
//     required this.latitude,
//     required this.longitude,
//     this.distance,
//   });

//   factory Parking.fromJson(Map<String, dynamic> json) {
//     return Parking(
//       id: json['id'],
//       nom: json['nom'],
//       ville: json['ville'],
//       nombreTotalPlaces: json['nombre_total_places'],
//       placesDisponibles: json['places_disponibles'],
//       imageUrl: json['image_url'],
//       distance: (json['distance_from_user'] ?? 0).toDouble(),
//       latitude: (json['latitude'] ?? 0).toDouble(),
//       longitude: (json['longitude'] ?? 0).toDouble(),
//     );
//   }
// }
// Parking.dart
class Parking {
  final int id;
  final String nom;
  final String ville;
  final int nombreTotalPlaces;
  final int placesDisponibles;
  final String? imageUrl;
  final double latitude;
  final double longitude;
  double? distance; // Distance from user's location

  Parking({
    required this.id,
    required this.nom,
    required this.ville,
    required this.nombreTotalPlaces,
    required this.placesDisponibles,
    this.imageUrl,
    required this.latitude,
    required this.longitude,
    this.distance,
  });

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      id: json['id'],
      nom: json['nom'],
      ville: json['ville'],
      nombreTotalPlaces: json['nombre_total_places'],
      placesDisponibles: json['places_disponibles'],
      imageUrl: json['image_url'],
      // Make sure these fields exist in your database or provide default values
latitude: double.parse(json['latitude'].toString()),
longitude: double.parse(json['longitude'].toString()),
      // Distance will be calculated after fetching
      distance: json['distance_from_user']?.toDouble(),
    );
  }

  // Convert Parking object to JSON for sending to API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'ville': ville,
      'nombre_total_places': nombreTotalPlaces,
      'places_disponibles': placesDisponibles,
      'image_url': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'distance_from_user': distance,
    };
  }

  // Create a copy of this Parking with updated fields
  Parking copyWith({
    int? id,
    String? nom,
    String? ville,
    int? nombreTotalPlaces,
    int? placesDisponibles,
    String? imageUrl,
    double? latitude,
    double? longitude,
    double? distance,
  }) {
    return Parking(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      ville: ville ?? this.ville,
      nombreTotalPlaces: nombreTotalPlaces ?? this.nombreTotalPlaces,
      placesDisponibles: placesDisponibles ?? this.placesDisponibles,
      imageUrl: imageUrl ?? this.imageUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distance: distance ?? this.distance,
    );
  }
}