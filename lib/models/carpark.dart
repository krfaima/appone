class Carpark {
  final int id;
  final double latitude;
  final double longitude;
  final String name;
  final String type;
  final double distanceFromUser;
  final String? address; // Optional field
  final double? price; // Optional field
  final int? availableSpots; // Optional field

  Carpark({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.type,
    required this.distanceFromUser,
    this.address,
    this.price,
    this.availableSpots,
  });

  factory Carpark.fromJson(Map<String, dynamic> json) {
    return Carpark(
      id: json['id'],
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      name: json['name'] ?? 'Unnamed Parking',
      type: json['type'] ?? 'unknown',
      distanceFromUser: (json['distance_from_user'] ?? 0).toDouble(),
      address: json['address'], // Handle null values
      price: json['price']?.toDouble(), // Handle null values
      availableSpots: json['available_spots'], // Handle null values
    );
  }
}