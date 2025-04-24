
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class LocationBanner extends StatefulWidget {
  const LocationBanner({super.key});

  @override
  State<LocationBanner> createState() => _LocationBannerState();
}

class _LocationBannerState extends State<LocationBanner> {
  String? address;
  String? error;
  bool loading = true;

  final String geoapifyApiKey = '23632ce7fc16456dae9a3898df37db7e'; // Remplace par ta clé Geoapify

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    setState(() {
      loading = true;
      error = null;
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

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

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
        error = e.toString();
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            child: loading
                ? const Text("📍 Chargement de l'adresse...",
                    style: TextStyle(color: Colors.white))
                : error != null
                    ? Text("❌ $error",
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
            onPressed: _fetchLocation,
            tooltip: "Rafraîchir",
          ),
        ],
      ),
    );
  }
}





























// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:geolocator/geolocator.dart';

// class LocationBanner extends StatefulWidget {
//   const LocationBanner({super.key});

//   @override
//   State<LocationBanner> createState() => _LocationBannerState();
// }

// class _LocationBannerState extends State<LocationBanner> {
//   String? address;
//   String? error;
//   bool loading = true;

//   final String geoapifyApiKey = '23632ce7fc16456dae9a3898df37db7e';

//   final Map<String, String> wilayas = {
//     'Alger': '36.752887,3.042048',
//     'Oran': '35.697654,-0.633737',
//     'Sidi Bel Abbès': '35.189938,-0.630789'
//   };

//   @override
//   void initState() {
//     super.initState();
//     _fetchLocation();
//   }

//   Future<void> _fetchLocation() async {
//     setState(() {
//       loading = true;
//       error = null;
//       address = null;
//     });

//     try {
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied ||
//           permission == LocationPermission.deniedForever) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied ||
//             permission == LocationPermission.deniedForever) {
//           throw Exception("Permission de localisation refusée.");
//         }
//       }

//       Position pos = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       final response = await http.get(Uri.parse(
//         'https://api.geoapify.com/v1/geocode/reverse?lat=${pos.latitude}&lon=${pos.longitude}&lang=fr&apiKey=$geoapifyApiKey',
//       ));

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final properties = data['features'][0]['properties'];

//         final street = properties['street'] ?? '';
//         final suburb = properties['suburb'] ?? '';
//         final city = properties['city'] ?? properties['county'] ?? '';
//         final state = properties['state'] ?? '';
//         final country = properties['country'] ?? '';

//         final formatted = [street, suburb, city, state, country]
//             .where((e) => e.isNotEmpty)
//             .join(', ');

//         setState(() {
//           address = formatted.isNotEmpty ? formatted : "Adresse introuvable";
//         });
//       } else {
//         throw Exception("Erreur Geoapify: ${response.statusCode}");
//       }
//     } catch (e) {
//       setState(() {
//         error = e.toString();
//       });
//     } finally {
//       setState(() {
//         loading = false;
//       });
//     }
//   }

//   Future<List> getRues(String latLon) async {
//     final response = await http.get(Uri.parse(
//       'https://api.geoapify.com/v1/geocode/reverse?lat=${latLon.split(",")[0]}&lon=${latLon.split(",")[1]}&lang=fr&apiKey=$geoapifyApiKey',
//     ));

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);

//       if (data['features'] != null && data['features'].isNotEmpty) {
//         final properties = data['features'][0]['properties'];

//         final street = properties['street'] ?? '';
//         final suburb = properties['suburb'] ?? '';

//         return [street, suburb].where((e) => e.isNotEmpty).toList();
//       } else {
//         throw Exception("Aucune adresse trouvée pour ces coordonnées.");
//       }
//     } else {
//       throw Exception("Erreur lors de la récupération des rues : Code ${response.statusCode}");
//     }
//   }

//   void _chooseWilaya() async {
//     String? selectedWilaya;
//     String? selectedRue;

//     await showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(builder: (context, setDialogState) {
//           List<String>? rues = [];

//           return AlertDialog(
//             title: const Text("Sélectionnez une wilaya"),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 DropdownButton<String>(
//                   value: selectedWilaya,
//                   hint: const Text("Wilaya"),
//                   isExpanded: true,
//                   items: wilayas.keys.map((wilaya) {
//                     return DropdownMenuItem(
//                       value: wilaya,
//                       child: Text(wilaya),
//                     );
//                   }).toList(),
//                   onChanged: (value) async {
//                     setDialogState(() {
//                       selectedWilaya = value;
//                       selectedRue = null;
//                       rues = [];
//                     });

//                     try {
//                       final r = await getRues(wilayas[value]!);
//                       setDialogState(() {
//                         rues = r.cast<String>();
//                       });
//                     } catch (e) {
//                       setDialogState(() {
//                         rues = ['Erreur chargement rues'];
//                       });
//                     }
//                   },
//                 ),
//                 if (selectedWilaya != null)
//                   DropdownButton<String>(
//                     value: selectedRue,
//                     hint: const Text("Rue ou quartier"),
//                     isExpanded: true,
//                     items: rues?.map((rue) {
//                       return DropdownMenuItem(
//                         value: rue,
//                         child: Text(rue),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setDialogState(() {
//                         selectedRue = value;
//                       });
//                     },
//                   ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text("Annuler"),
//               ),
//               TextButton(
//                 onPressed: () {
//                   if (selectedWilaya != null && selectedRue != null) {
//                     setState(() {
//                       address = '$selectedRue, $selectedWilaya';
//                     });
//                     Navigator.pop(context);
//                   }
//                 },
//                 child: const Text("Valider"),
//               ),
//             ],
//           );
//         });
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(12),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: Colors.blue.shade800,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const Icon(Icons.location_on, color: Colors.white),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: loading
//                     ? const Text("📍 Chargement de l'adresse...",
//                         style: TextStyle(color: Colors.white))
//                     : error != null
//                         ? Text("❌ $error",
//                             style: const TextStyle(color: Colors.redAccent),
//                             maxLines: 3,
//                             overflow: TextOverflow.ellipsis)
//                         : Text(
//                             address ?? "Adresse non disponible",
//                             style: const TextStyle(color: Colors.white),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.refresh, color: Colors.white),
//                 onPressed: _fetchLocation,
//                 tooltip: "Rafraîchir",
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           TextButton(
//             onPressed: _chooseWilaya,
//             child: const Text("Changer de localisation manuellement",
//                 style: TextStyle(color: Colors.white)),
//           )
//         ],
//       ),
//     );
//   }
// }
