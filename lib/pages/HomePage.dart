import 'package:flutter/material.dart';
import '../api_service.dart';
import '../parking.dart';
import '../welcome_page.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Liste des Parkings")),
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
              itemCount: parkings.length,
              itemBuilder: (context, index) {
                final parking = parkings[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(parking.nom, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      'Ville: ${parking.ville}\n'
                      'Total: ${parking.nombreTotalPlaces} | Disponibles: ${parking.placesDisponibles}',
                    ),
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
