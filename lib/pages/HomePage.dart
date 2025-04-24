// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import '../api_service.dart';
// import '../Parking.dart'; // Assure-toi que le modèle contient `distance`
// import '../services/location_service.dart';
// import 'map_page.dart'; // Assure-toi d'importer MapPage
// import '../widgets/your_location_banner.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   List<Parking> parkings = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     loadParkings();
//   }

//   Future<void> loadParkings() async {
//     try {
//       final fetchedParkings = await fetchParkings();
//       final position = await LocationService.getCurrentPosition();

//       for (var parking in fetchedParkings) {
//         parking.distance = LocationService.calculateDistance(
//           position.latitude,
//           position.longitude,
//           parking.latitude,
//           parking.longitude,
//         );
//       }

//       fetchedParkings.sort((a, b) => a.distance!.compareTo(b.distance!));

//       setState(() {
//         parkings = fetchedParkings;
//         isLoading = false;
//       });
//     } catch (e) {
//       print("Erreur chargement : $e");
//       setState(() => isLoading = false);
//     }
//   }

//   Color getStatusColor(int dispo) {
//     return dispo > 0 ? Colors.green : Colors.red;
//   }

//   String getStatusLabel(int dispo) {
//     return dispo > 0 ? "Available" : "Full";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 159, 185, 230),
//         title: const Text("Find Parking Near You",
//             style: TextStyle(color: Colors.white)),
//         elevation: 0,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : parkings.isEmpty
//               ? const Center(child: Text('Aucun parking trouvé'))
//               : ListView.builder(
//                   padding: const EdgeInsets.all(12),
//                   itemCount: parkings.length,
//                   itemBuilder: (context, index) {
//                     final parking = parkings[index];
//                     return Card(
//                       elevation: 5,
//                       margin: const EdgeInsets.symmetric(vertical: 10),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16)),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           ClipRRect(
//                             borderRadius: const BorderRadius.only(
//                               topLeft: Radius.circular(16),
//                               bottomLeft: Radius.circular(16),
//                             ),
//                             child: Image.network(
//                               parking.imageUrl ?? 'https://via.placeholder.com/120',
//                               width: 120,
//                               height: 120,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) =>
//                                   Container(
//                                       color: Colors.grey,
//                                       width: 120,
//                                       height: 120),
//                             ),
//                           ),
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.all(12.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     parking.nom,
//                                     style: const TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     parking.ville,
//                                     style: const TextStyle(
//                                       color: Colors.grey,
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Row(
//                                     children: [
//                                       Icon(Icons.local_parking,
//                                           size: 18,
//                                           color: Colors.grey[600]),
//                                       const SizedBox(width: 6),
//                                       Text(
//                                         '${parking.placesDisponibles}/${parking.nombreTotalPlaces} places',
//                                         style: const TextStyle(fontSize: 14),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 6),
//                                   Text(
//                                     parking.distance != null
//                                         ? '${(parking.distance! / 1000).toStringAsFixed(2)} km'
//                                         : 'Distance inconnue',
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.blueGrey,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 6),
//                                   Align(
//                                     alignment: Alignment.centerRight,
//                                     child: Container(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 10, vertical: 4),
//                                       decoration: BoxDecoration(
//                                         color: getStatusColor(
//                                                 parking.placesDisponibles)
//                                             .withOpacity(0.2),
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                       child: Text(
//                                         getStatusLabel(parking.placesDisponibles),
//                                         style: TextStyle(
//                                           color: getStatusColor(
//                                               parking.placesDisponibles),
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 10),
//                                   // Le bouton vers la carte
//                                   ElevatedButton(
//                                     onPressed: () async {
//                                       Position position = await LocationService.getCurrentPosition();

//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (_) => MapPage(
//                                             userLat: position.latitude,
//                                             userLng: position.longitude,
//                                             parkingLat: parking.latitude,
//                                             parkingLng: parking.longitude,
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                     child: const Text("Voir sur la carte"),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }

















// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import '../api_service.dart';
// import '../Parking.dart'; // Assure-toi que le modèle contient `distance`
// import '../services/location_service.dart';
// import 'map_page.dart'; // Assure-toi d'importer MapPage
// import '../widgets/your_location_banner.dart';


// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   List<Parking> parkings = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     loadParkings();
//   }

//   Future<void> loadParkings() async {
//     try {
//       final fetchedParkings = await fetchParkings();
//       final position = await LocationService.getCurrentPosition();

//       for (var parking in fetchedParkings) {
//         parking.distance = LocationService.calculateDistance(
//           position.latitude,
//           position.longitude,
//           parking.latitude,
//           parking.longitude,
//         );
//       }

//       fetchedParkings.sort((a, b) => a.distance!.compareTo(b.distance!));

//       setState(() {
//         parkings = fetchedParkings;
//         isLoading = false;
//       });
//     } catch (e) {
//       print("Erreur chargement : $e");
//       setState(() => isLoading = false);
//     }
//   }

//   Color getStatusColor(int dispo) {
//     return dispo > 0 ? Colors.green : Colors.red;
//   }

//   String getStatusLabel(int dispo) {
//     return dispo > 0 ? "Available" : "Full";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 159, 185, 230),
//         title: const Text("Find Parking Near You",
//             style: TextStyle(color: Colors.white)),
//         elevation: 0,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : parkings.isEmpty
//               ? const Center(child: Text('Aucun parking trouvé'))
//               : Column(
//                   children: [
//                     LocationBanner(), // <-- Intégration ici
//                     Expanded(
//                       child: ListView.builder(
//                         padding: const EdgeInsets.all(12),
//                         itemCount: parkings.length,
//                         itemBuilder: (context, index) {
//                           final parking = parkings[index];
//                           return Card(
//                             elevation: 5,
//                             margin: const EdgeInsets.symmetric(vertical: 10),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(16)),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: const BorderRadius.only(
//                                     topLeft: Radius.circular(16),
//                                     bottomLeft: Radius.circular(16),
//                                   ),
//                                   child: Image.network(
//                                     parking.imageUrl ??
//                                         'https://via.placeholder.com/120',
//                                     width: 120,
//                                     height: 120,
//                                     fit: BoxFit.cover,
//                                     errorBuilder: (context, error, stackTrace) =>
//                                         Container(
//                                             color: Colors.grey,
//                                             width: 120,
//                                             height: 120),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(12.0),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           parking.nom,
//                                           style: const TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 4),
//                                         Text(
//                                           parking.ville,
//                                           style: const TextStyle(
//                                             color: Colors.grey,
//                                             fontSize: 14,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 8),
//                                         Row(
//                                           children: [
//                                             Icon(Icons.local_parking,
//                                                 size: 18,
//                                                 color: Colors.grey[600]),
//                                             const SizedBox(width: 6),
//                                             Text(
//                                               '${parking.placesDisponibles}/${parking.nombreTotalPlaces} places',
//                                               style:
//                                                   const TextStyle(fontSize: 14),
//                                             ),
//                                           ],
//                                         ),
//                                         const SizedBox(height: 6),
//                                         Text(
//                                           parking.distance != null
//                                               ? '${(parking.distance! / 1000).toStringAsFixed(2)} km'
//                                               : 'Distance inconnue',
//                                           style: const TextStyle(
//                                             fontSize: 14,
//                                             color: Colors.blueGrey,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 6),
//                                         Align(
//                                           alignment: Alignment.centerRight,
//                                           child: Container(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 10, vertical: 4),
//                                             decoration: BoxDecoration(
//                                               color: getStatusColor(
//                                                       parking.placesDisponibles)
//                                                   .withOpacity(0.2),
//                                               borderRadius:
//                                                   BorderRadius.circular(12),
//                                             ),
//                                             child: Text(
//                                               getStatusLabel(
//                                                   parking.placesDisponibles),
//                                               style: TextStyle(
//                                                 color: getStatusColor(
//                                                     parking.placesDisponibles),
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         const SizedBox(height: 10),
//                                         // Le bouton vers la carte
//                                         ElevatedButton(
//                                           onPressed: () async {
//                                             Position position =
//                                                 await LocationService
//                                                     .getCurrentPosition();

//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (_) => MapPage(
//                                                   userLat: position.latitude,
//                                                   userLng: position.longitude,
//                                                   parkingLat: parking.latitude,
//                                                   parkingLng: parking.longitude,
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                           child: const Text("Voir sur la carte"),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//     );
//   }
// }




























// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// // import '../api_service.dart';
// import '../Parking.dart'; // Assure-toi que le modèle contient `distance`
// import '../services/location_service.dart';
// import 'map_page.dart'; // Assure-toi d'importer MapPage
// import '../widgets/your_location_banner.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   List<Parking> parkings = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     loadParkings();
//   }

//   // Récupérer les parkings depuis la base de données
//   Future<List<Parking>> fetchParkingsFromDatabase() async {
//     final response = await http.get(Uri.parse('http://127.0.0.1:8000/accounts/parkings/')); // Remplacer l'URL par votre API backend
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       return data.map((e) => Parking.fromJson(e)).toList(); // S'assurer que votre modèle Parking peut être créé à partir du JSON
//     } else {
//       throw Exception('Erreur de récupération des parkings');
//     }
//   }

//   // Obtenir les parkings proches de la position de l'utilisateur et dans la wilaya
//   Future<void> loadParkings() async {
//     try {
//       // Récupérer la position de l'utilisateur
//       final position = await LocationService.getCurrentPosition();

//       // Récupérer les parkings depuis la base de données
//       final fetchedParkings = await fetchParkingsFromDatabase();

//       // Filtrer et calculer la distance
//       for (var parking in fetchedParkings) {
//         parking.distance = LocationService.calculateDistance(
//           position.latitude,
//           position.longitude,
//           parking.latitude,
//           parking.longitude,
//         );
//       }

//       // Trier les parkings par distance croissante
//       fetchedParkings.sort((a, b) => a.distance!.compareTo(b.distance!));

//       setState(() {
//         parkings = fetchedParkings;
//         isLoading = false;
//       });
//     } catch (e) {
//       print("Erreur chargement : $e");
//       setState(() => isLoading = false);
//     }
//   }

//   Color getStatusColor(int dispo) {
//     return dispo > 0 ? Colors.green : Colors.red;
//   }

//   String getStatusLabel(int dispo) {
//     return dispo > 0 ? "Available" : "Full";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 159, 185, 230),
//         title: const Text("Find Parking Near You", style: TextStyle(color: Colors.white)),
//         elevation: 0,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : parkings.isEmpty
//               ? const Center(child: Text('Aucun parking trouvé'))
//               : Column(
//                   children: [
//                     LocationBanner(), // <-- Intégration ici
//                     Expanded(
//                       child: ListView.builder(
//                         padding: const EdgeInsets.all(12),
//                         itemCount: parkings.length,
//                         itemBuilder: (context, index) {
//                           final parking = parkings[index];
//                           return Card(
//                             elevation: 5,
//                             margin: const EdgeInsets.symmetric(vertical: 10),
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
//                                   child: Image.network(
//                                     parking.imageUrl ?? 'https://via.placeholder.com/120',
//                                     width: 120,
//                                     height: 120,
//                                     fit: BoxFit.cover,
//                                     errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey, width: 120, height: 120),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(12.0),
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(parking.nom, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                                         const SizedBox(height: 4),
//                                         Text(parking.ville, style: const TextStyle(color: Colors.grey, fontSize: 14)),
//                                         const SizedBox(height: 8),
//                                         Row(
//                                           children: [
//                                             Icon(Icons.local_parking, size: 18, color: Colors.grey[600]),
//                                             const SizedBox(width: 6),
//                                             Text('${parking.placesDisponibles}/${parking.nombreTotalPlaces} places', style: const TextStyle(fontSize: 14)),
//                                           ],
//                                         ),
//                                         const SizedBox(height: 6),
//                                         Text(parking.distance != null ? '${(parking.distance! / 1000).toStringAsFixed(2)} km' : 'Distance inconnue', style: const TextStyle(fontSize: 14, color: Colors.blueGrey)),
//                                         const SizedBox(height: 6),
//                                         Align(
//                                           alignment: Alignment.centerRight,
//                                           child: Container(
//                                             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                                             decoration: BoxDecoration(color: getStatusColor(parking.placesDisponibles).withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
//                                             child: Text(
//                                               getStatusLabel(parking.placesDisponibles),
//                                               style: TextStyle(color: getStatusColor(parking.placesDisponibles), fontWeight: FontWeight.bold),
//                                             ),
//                                           ),
//                                         ),
//                                         const SizedBox(height: 10),
//                                         // Le bouton vers la carte
//                                         ElevatedButton(
//                                           onPressed: () async {
//                                             Position position = await LocationService.getCurrentPosition();

//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (_) => MapPage(
//                                                   userLat: position.latitude,
//                                                   userLng: position.longitude,
//                                                   parkingLat: parking.latitude,
//                                                   parkingLng: parking.longitude,
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                           child: const Text("Voir sur la carte"),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//     );
//   }
// }



// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:geolocator/geolocator.dart';
// import '../Parking.dart';
// import '../services/location_service.dart';
// import 'map_page.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   List<Parking> parkings = [];
//   bool isLoading = true;

//   String? address;
//   String? locationError;
//   bool locationLoading = true;
//   final String geoapifyApiKey = '23632ce7fc16456dae9a3898df37db7e'; // Remplace par ta clé Geoapify

//   @override
//   void initState() {
//     super.initState();
//     loadParkings();
//     fetchLocation();
//   }

//   // Récupérer la position de l'utilisateur
//   Future<void> fetchLocation() async {
//     setState(() {
//       locationLoading = true;
//       locationError = null;
//       address = null;
//     });

//     try {
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
//           throw Exception("Permission de localisation refusée.");
//         }
//       }

//       Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

//       final response = await http.get(Uri.parse(
//         'https://api.geoapify.com/v1/geocode/reverse?lat=${pos.latitude}&lon=${pos.longitude}&lang=fr&apiKey=$geoapifyApiKey',
//       ));

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final properties = data['features'][0]['properties'];

//         final street = properties['street'] ?? '';
//         final suburb = properties['suburb'] ?? '';
//         final city = properties['city'] ?? properties['county'] ?? '';
//         final country = properties['country'] ?? '';

//         final formatted = [street, suburb, city, country].where((e) => e.isNotEmpty).join(', ');

//         setState(() {
//           address = formatted.isNotEmpty ? formatted : "Adresse introuvable";
//         });
//       } else {
//         throw Exception("Erreur Geoapify: ${response.statusCode}");
//       }
//     } catch (e) {
//       setState(() {
//         locationError = e.toString();
//       });
//     } finally {
//       setState(() {
//         locationLoading = false;
//       });
//     }
//   }

//   Future<List<Parking>> fetchParkingsFromDatabase() async {
//     final response = await http.get(Uri.parse('http://127.0.0.1:8000/accounts/parkings/'));
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       return data.map((e) => Parking.fromJson(e)).toList();
//     } else {
//       throw Exception('Erreur de récupération des parkings');
//     }
//   }

//   Future<void> loadParkings() async {
//     try {
//       final position = await LocationService.getCurrentPosition();
//       final fetchedParkings = await fetchParkingsFromDatabase();

//       for (var parking in fetchedParkings) {
//         parking.distance = LocationService.calculateDistance(
//           position.latitude,
//           position.longitude,
//           parking.latitude,
//           parking.longitude,
//         );
//       }

//       fetchedParkings.sort((a, b) => a.distance!.compareTo(b.distance!));

//       setState(() {
//         parkings = fetchedParkings;
//         isLoading = false;
//       });
//     } catch (e) {
//       print("Erreur chargement : $e");
//       setState(() => isLoading = false);
//     }
//   }

//   Color getStatusColor(int dispo) {
//     return dispo > 0 ? Colors.green : Colors.red;
//   }

//   String getStatusLabel(int dispo) {
//     return dispo > 0 ? "Available" : "Full";
//   }

//   Widget buildLocationBanner() {
//     return Container(
//       margin: const EdgeInsets.all(12),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: Colors.blue.shade800,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.location_on, color: Colors.white),
//           const SizedBox(width: 12),
//           Expanded(
//             child: locationLoading
//                 ? const Text("📍 Chargement de l'adresse...", style: TextStyle(color: Colors.white))
//                 : locationError != null
//                     ? Text("❌ $locationError",
//                         style: const TextStyle(color: Colors.redAccent),
//                         maxLines: 3,
//                         overflow: TextOverflow.ellipsis)
//                     : Text(
//                         address ?? "Adresse non disponible",
//                         style: const TextStyle(color: Colors.white),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.refresh, color: Colors.white),
//             onPressed: fetchLocation,
//             tooltip: "Rafraîchir",
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 159, 185, 230),
//         title: const Text("Find Parking Near You", style: TextStyle(color: Colors.white)),
//         elevation: 0,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : parkings.isEmpty
//               ? const Center(child: Text('Aucun parking trouvé'))
//               : Column(
//                   children: [
//                     buildLocationBanner(),
//                     Expanded(
//                       child: ListView.builder(
//                         padding: const EdgeInsets.all(12),
//                         itemCount: parkings.length,
//                         itemBuilder: (context, index) {
//                           final parking = parkings[index];
//                           return Card(
//                             elevation: 5,
//                             margin: const EdgeInsets.symmetric(vertical: 10),
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
//                                   child: Image.network(
//                                     parking.imageUrl ?? 'https://via.placeholder.com/120',
//                                     width: 120,
//                                     height: 120,
//                                     fit: BoxFit.cover,
//                                     errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey, width: 120, height: 120),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(12.0),
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(parking.nom, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                                         const SizedBox(height: 4),
//                                         Text(parking.ville, style: const TextStyle(color: Colors.grey, fontSize: 14)),
//                                         const SizedBox(height: 8),
//                                         Row(
//                                           children: [
//                                             Icon(Icons.local_parking, size: 18, color: Colors.grey[600]),
//                                             const SizedBox(width: 6),
//                                             Text('${parking.placesDisponibles}/${parking.nombreTotalPlaces} places', style: const TextStyle(fontSize: 14)),
//                                           ],
//                                         ),
//                                         const SizedBox(height: 6),
//                                         Text(parking.distance != null ? '${(parking.distance! / 1000).toStringAsFixed(2)} km' : 'Distance inconnue', style: const TextStyle(fontSize: 14, color: Colors.blueGrey)),
//                                         const SizedBox(height: 6),
//                                         Align(
//                                           alignment: Alignment.centerRight,
//                                           child: Container(
//                                             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                                             decoration: BoxDecoration(color: getStatusColor(parking.placesDisponibles).withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
//                                             child: Text(
//                                               getStatusLabel(parking.placesDisponibles),
//                                               style: TextStyle(color: getStatusColor(parking.placesDisponibles), fontWeight: FontWeight.bold),
//                                             ),
//                                           ),
//                                         ),
//                                         const SizedBox(height: 10),
//                                         ElevatedButton(
//                                           onPressed: () async {
//                                             Position position = await LocationService.getCurrentPosition();
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (_) => MapPage(
//                                                   userLat: position.latitude,
//                                                   userLng: position.longitude,
//                                                   parkingLat: parking.latitude,
//                                                   parkingLng: parking.longitude,
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                           child: const Text("Voir sur la carte"),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//     );
//   }
// }





// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:geolocator/geolocator.dart';
// import '../Parking.dart';
// import '../services/location_service.dart';
// import 'map_page.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   List<Parking> parkings = [];
//   bool isLoading = true;

//   String? address;
//   String? locationError;
//   bool locationLoading = true;
//   final String geoapifyApiKey = '23632ce7fc16456dae9a3898df37db7e'; // Remplace par ta clé Geoapify

//   @override
//   void initState() {
//     super.initState();
//     loadParkings();
//     fetchLocation();
//   }

//   // Récupérer la position de l'utilisateur
//   Future<void> fetchLocation() async {
//     setState(() {
//       locationLoading = true;
//       locationError = null;
//       address = null;
//     });

//     try {
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
//           throw Exception("Permission de localisation refusée.");
//         }
//       }

//       Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

//       final response = await http.get(Uri.parse(
//         'https://api.geoapify.com/v1/geocode/reverse?lat=${pos.latitude}&lon=${pos.longitude}&lang=fr&apiKey=$geoapifyApiKey',
//       ));

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final properties = data['features'][0]['properties'];

//         final street = properties['street'] ?? '';
//         final suburb = properties['suburb'] ?? '';
//         final city = properties['city'] ?? properties['county'] ?? '';
//         final country = properties['country'] ?? '';

//         final formatted = [street, suburb, city, country].where((e) => e.isNotEmpty).join(', ');

//         setState(() {
//           address = formatted.isNotEmpty ? formatted : "Adresse introuvable";
//         });
//       } else {
//         throw Exception("Erreur Geoapify: ${response.statusCode}");
//       }
//     } catch (e) {
//       setState(() {
//         locationError = e.toString();
//       });
//     } finally {
//       setState(() {
//         locationLoading = false;
//       });
//     }
//   }

//   // Fetch parkings from the database
//   Future<List<Parking>> fetchParkingsFromDatabase() async {
//     final response = await http.get(Uri.parse('http://127.0.0.1:8000/accounts/parkings/'));
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       return data.map((e) => Parking.fromJson(e)).toList();
//     } else {
//       throw Exception('Erreur de récupération des parkings');
//     }
//   }

//   // Fetch parking spots from OpenStreetMap based on user's location
//   Future<void> fetchParkingsFromMap(double latitude, double longitude) async {
//     final response = await http.get(Uri.parse(
//       'https://overpass-api.de/api/interpreter?data=[out:json];node(around:2000,$latitude,$longitude)[amenity=parking];out;',
//     ));
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final List<dynamic> features = data['elements'];

//       List<Parking> fetchedParkings = [];
//       for (var feature in features) {
//         if (feature['lat'] != null && feature['lon'] != null) {
//           fetchedParkings.add(Parking(
//             id: feature['id'] ?? 0, // Provide a default or valid ID
//             nom: feature['tags']['name'] ?? 'Parking inconnu',
//             ville: feature['tags']['city'] ?? 'Ville inconnue', // Provide a default or valid city
//             latitude: feature['lat'],
//             longitude: feature['lon'],
//             nombreTotalPlaces: feature['tags']['capacity'] != null ? int.parse(feature['tags']['capacity']!) : 0, // Provide a valid total places
//             placesDisponibles: feature['tags']['capacity'] != null ? int.parse(feature['tags']['capacity']!) : 0,
//             imageUrl: 'https://via.placeholder.com/120', // Placeholder image or URL of parking image
//           ));
//         }
//       }

//       setState(() {
//         parkings.addAll(fetchedParkings); // Merge fetched parkings with database parkings
//         isLoading = false;
//       });
//     } else {
//       throw Exception("Erreur Overpass API: ${response.statusCode}");
//     }
//   }

//   Future<void> loadParkings() async {
//     try {
//       final position = await LocationService.getCurrentPosition();
//       final fetchedParkings = await fetchParkingsFromDatabase();
//       await fetchParkingsFromMap(position.latitude, position.longitude);

//       for (var parking in fetchedParkings) {
//         parking.distance = LocationService.calculateDistance(
//           position.latitude,
//           position.longitude,
//           parking.latitude,
//           parking.longitude,
//         );
//       }

//       fetchedParkings.sort((a, b) => a.distance!.compareTo(b.distance!));

//       setState(() {
//         parkings = fetchedParkings;
//         isLoading = false;
//       });
//     } catch (e) {
//       print("Erreur chargement : $e");
//       setState(() => isLoading = false);
//     }
//   }

//   Color getStatusColor(int dispo) {
//     return dispo > 0 ? Colors.green : Colors.red;
//   }

//   String getStatusLabel(int dispo) {
//     return dispo > 0 ? "Available" : "Full";
//   }

//   Widget buildLocationBanner() {
//     return Container(
//       margin: const EdgeInsets.all(12),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: Colors.blue.shade800,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.location_on, color: Colors.white),
//           const SizedBox(width: 12),
//           Expanded(
//             child: locationLoading
//                 ? const Text("📍 Chargement de l'adresse...", style: TextStyle(color: Colors.white))
//                 : locationError != null
//                     ? Text("❌ $locationError",
//                         style: const TextStyle(color: Colors.redAccent),
//                         maxLines: 3,
//                         overflow: TextOverflow.ellipsis)
//                     : Text(
//                         address ?? "Adresse non disponible",
//                         style: const TextStyle(color: Colors.white),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.refresh, color: Colors.white),
//             onPressed: fetchLocation,
//             tooltip: "Rafraîchir",
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 159, 185, 230),
//         title: const Text("Find Parking Near You", style: TextStyle(color: Colors.white)),
//         elevation: 0,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : parkings.isEmpty
//               ? const Center(child: Text('Aucun parking trouvé'))
//               : Column(
//                   children: [
//                     buildLocationBanner(),
//                     Expanded(
//                       child: ListView.builder(
//                         padding: const EdgeInsets.all(12),
//                         itemCount: parkings.length,
//                         itemBuilder: (context, index) {
//                           final parking = parkings[index];
//                           return Card(
//                             elevation: 5,
//                             margin: const EdgeInsets.symmetric(vertical: 10),
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
//                                   child: Image.network(
//                                     parking.imageUrl ?? 'https://via.placeholder.com/120',
//                                     width: 120,
//                                     height: 120,
//                                     fit: BoxFit.cover,
//                                     errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey, width: 120, height: 120),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(12.0),
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(parking.nom, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                                         const SizedBox(height: 4),
//                                         Text(parking.ville, style: const TextStyle(color: Colors.grey, fontSize: 14)),
//                                         const SizedBox(height: 8),
//                                         Row(
//                                           children: [
//                                             Icon(Icons.local_parking, size: 18, color: Colors.grey[600]),
//                                             const SizedBox(width: 6),
//                                             Text('${parking.placesDisponibles}/${parking.nombreTotalPlaces} places', style: const TextStyle(fontSize: 14)),
//                                           ],
//                                         ),
//                                         const SizedBox(height: 6),
//                                         Text(parking.distance != null ? '${(parking.distance! / 1000).toStringAsFixed(2)} km' : 'Distance inconnue', style: const TextStyle(fontSize: 14, color: Colors.blueGrey)),
//                                         const SizedBox(height: 6),
//                                         Align(
//                                           alignment: Alignment.centerRight,
//                                           child: Container(
//                                             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                                             decoration: BoxDecoration(color: getStatusColor(parking.placesDisponibles).withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
//                                             child: Text(
//                                               getStatusLabel(parking.placesDisponibles),
//                                               style: TextStyle(color: getStatusColor(parking.placesDisponibles), fontWeight: FontWeight.bold),
//                                             ),
//                                           ),
//                                         ),
//                                         const SizedBox(height: 10),
//                                         ElevatedButton(
//                                           onPressed: () async {
//                                             Position position = await LocationService.getCurrentPosition();
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (_) => MapPage(
//                                                   userLat: position.latitude,
//                                                   userLng: position.longitude,
//                                                   parkingLat: parking.latitude,
//                                                   parkingLng: parking.longitude,
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                           child: const Text("Voir sur la carte"),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//     );
//   }
// }





import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../Parking.dart';
import '../services/location_service.dart';
import 'map_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Parking> parkings = [];
  bool isLoading = true;

  String? address;
  String? locationError;
  bool locationLoading = true;
  final String geoapifyApiKey = '23632ce7fc16456dae9a3898df37db7e';

  @override
  void initState() {
    super.initState();
    loadParkings();
    fetchLocation();
  }

  Future<void> fetchLocation() async {
    setState(() {
      locationLoading = true;
      locationError = null;
      address = null;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          throw Exception("Permission de localisation refusée.");
        }
      }

      Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      final response = await http.get(Uri.parse(
        'https://api.geoapify.com/v1/geocode/reverse?lat=${pos.latitude}&lon=${pos.longitude}&lang=fr&apiKey=$geoapifyApiKey',
      ));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final properties = data['features'][0]['properties'];

        final street = properties['street'] ?? '';
        final suburb = properties['suburb'] ?? '';
        final city = properties['city'] ?? properties['county'] ?? '';
        final country = properties['country'] ?? '';

        final formatted = [street, suburb, city, country].where((e) => e.isNotEmpty).join(', ');

        setState(() {
          address = formatted.isNotEmpty ? formatted : "Adresse introuvable";
        });
      } else {
        throw Exception("Erreur Geoapify: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        locationError = e.toString();
      });
    } finally {
      setState(() {
        locationLoading = false;
      });
    }
  }

  Future<List<Parking>> fetchParkingsFromDatabase() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/accounts/parkings/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Parking.fromJson(e)).toList();
    } else {
      throw Exception('Erreur de récupération des parkings');
    }
  }

  Future<List<Parking>> fetchParkingsFromMap(double lat, double lon) async {
    final url = Uri.parse('https://overpass-api.de/api/interpreter?data=[out:json];node(around:2000,$lat,$lon)[amenity=parking];out;');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List elements = data['elements'];

      List<Parking> parkings = [];

      for (var element in elements) {
        parkings.add(Parking(
          id: element['id'] as int,
          nom: element['tags']?['name'] ?? 'Parking OSM',
          ville: 'Ville inconnue',
          placesDisponibles: 10,
          nombreTotalPlaces: 20,
          latitude: element['lat'],
          longitude: element['lon'],
          imageUrl: 'https://via.placeholder.com/120',
        ));
      }

      return parkings;
    } else {
      throw Exception("Erreur Overpass API");
    }
  }

  Future<void> loadParkings() async {
    try {
      final position = await LocationService.getCurrentPosition();
      final fetchedDbParkings = await fetchParkingsFromDatabase();
      final fetchedMapParkings = await fetchParkingsFromMap(position.latitude, position.longitude);

      final allParkings = [...fetchedDbParkings, ...fetchedMapParkings];

  
for (var parking in allParkings) {
  parking.distance = LocationService.calculateDistance(
    position.latitude,
    position.longitude,
    parking.latitude,
    parking.longitude,
  );
  
  print('Distance vers ${parking.nom}: ${parking.distance} mètres');
}

      allParkings.sort((a, b) => a.distance!.compareTo(b.distance!));

      setState(() {
        parkings = allParkings;
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

  Widget buildLocationBanner() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue.shade800,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: locationLoading
                ? const Text("📍 Chargement de l'adresse...", style: TextStyle(color: Colors.white))
                : locationError != null
                    ? Text("❌ $locationError",
                        style: const TextStyle(color: Colors.redAccent),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis)
                    : Text(
                        address ?? "Adresse non disponible",
                        style: const TextStyle(color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: fetchLocation,
            tooltip: "Rafraîchir",
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 159, 185, 230),
        title: const Text("Find Parking Near You", style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : parkings.isEmpty
              ? const Center(child: Text('Aucun parking trouvé'))
              : Column(
                  children: [
                    buildLocationBanner(),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: parkings.length,
                        itemBuilder: (context, index) {
                          final parking = parkings[index];
                          return Card(
                            elevation: 5,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
                                  child: Image.network(
                                    parking.imageUrl ?? 'https://via.placeholder.com/120',
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey, width: 120, height: 120),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(parking.nom, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 4),
                                        Text(parking.ville, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(Icons.local_parking, size: 18, color: Colors.grey[600]),
                                            const SizedBox(width: 6),
                                            Text('${parking.placesDisponibles}/${parking.nombreTotalPlaces} places', style: const TextStyle(fontSize: 14)),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(parking.distance != null ? '${(parking.distance! / 1000).toStringAsFixed(2)} km' : 'Distance inconnue', style: const TextStyle(fontSize: 14, color: Colors.blueGrey)),
                                        const SizedBox(height: 6),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(color: getStatusColor(parking.placesDisponibles).withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                                            child: Text(
                                              getStatusLabel(parking.placesDisponibles),
                                              style: TextStyle(color: getStatusColor(parking.placesDisponibles), fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
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
                    ),
                  ],
                ),
    );
  }
}
