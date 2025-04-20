import 'package:flutter/material.dart';
import '../api_service.dart';
import '../Parking.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Color getStatusColor(int dispo) {
    return dispo > 0 ? Colors.green : Colors.red;
  }

  String getStatusLabel(int dispo) {
    return dispo > 0 ? "Available" : "Full";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 159, 185, 230),
        title: const Text("Find Parking Near You",
            style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: FutureBuilder<List<Parking>>(
        future: fetchParkings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun parking trouvé'));
          } else {
            final parkings = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: parkings.length,
              itemBuilder: (context, index) {
                final parking = parkings[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                        child: Image.network(
                          parking.imageUrl ?? 'https://via.placeholder.com/120',
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                  color: Colors.grey, width: 120, height: 120),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                parking.nom,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                parking.ville,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.local_parking,
                                      size: 18, color: Colors.grey[600]),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${parking.placesDisponibles}/${parking.nombreTotalPlaces} places',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: getStatusColor(
                                            parking.placesDisponibles)
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    getStatusLabel(parking.placesDisponibles),
                                    style: TextStyle(
                                      color: getStatusColor(
                                          parking.placesDisponibles),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
