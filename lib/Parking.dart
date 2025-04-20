class Parking {
  final int id;
  final String nom;
  final String ville;
  final int nombreTotalPlaces;
  final int placesDisponibles;
  final String? imageUrl;
  final double latitude;
  final double longitude;
  double? distance; // ← Ajouté


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
      distance: (json['distance_from_user'] ?? 0).toDouble(),
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
    );
  }
}
