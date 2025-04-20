import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../api_service.dart';
import '../Parking.dart'; // Assure-toi que le modèle contient `distance`
import '../services/location_service.dart';
import 'map_page.dart'; // Assure-toi d'importer MapPage

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Parking> parkings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadParkings();
  }

  Future<void> loadParkings() async {
    try {
      final fetchedParkings = await fetchParkings();
      final position = await LocationService.getCurrentPosition();

      for (var parking in fetchedParkings) {
        parking.distance = LocationService.calculateDistance(
          position.latitude,
          position.longitude,
          parking.latitude,
          parking.longitude,
        );
      }

      fetchedParkings.sort((a, b) => a.distance!.compareTo(b.distance!));

      setState(() {
        parkings = fetchedParkings;
        isLoading = false;
      });
    } catch (e) {
      print("Erreur chargement : $e");
      setState(() => isLoading = false);
    }
  }

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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : parkings.isEmpty
              ? const Center(child: Text('Aucun parking trouvé'))
              : ListView.builder(
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
                                      color: Colors.grey,
                                      width: 120,
                                      height: 120),
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
                                          size: 18,
                                          color: Colors.grey[600]),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${parking.placesDisponibles}/${parking.nombreTotalPlaces} places',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    parking.distance != null
                                        ? '${(parking.distance! / 1000).toStringAsFixed(2)} km'
                                        : 'Distance inconnue',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.blueGrey,
                                    ),
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
                                  ),
                                  const SizedBox(height: 10),
                                  // Le bouton vers la carte
                                  ElevatedButton(
                                    onPressed: () async {
                                      Position position = await LocationService.getCurrentPosition();

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => MapPage(
                                            userLat: position.latitude,
                                            userLng: position.longitude,
                                            parkingLat: parking.latitude,
                                            parkingLng: parking.longitude,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text("Voir sur la carte"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
