class Parking {
  final int id;
  final String nom;
  final String ville;
  final int nombreTotalPlaces;
  final int placesDisponibles;

  Parking({
    required this.id,
    required this.nom,
    required this.ville,
    required this.nombreTotalPlaces,
    required this.placesDisponibles,
  });

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      id: json['id'],
      nom: json['nom'],
      ville: json['ville'],
      nombreTotalPlaces: json['nombre_total_places'],
      placesDisponibles: json['places_disponibles'],
    );
  }
}
