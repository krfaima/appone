// widgets/your_location_banner.dart
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:appone/services/location_service.dart'; // Assure-toi du bon chemin

class YourLocationBanner extends StatefulWidget {
  const YourLocationBanner({super.key});

  @override
  State<YourLocationBanner> createState() => _YourLocationBannerState();
}

class _YourLocationBannerState extends State<YourLocationBanner> {
  String? _address;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final position = await LocationService().determinePosition();

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final address = [
          p.street,
          p.subLocality,
          p.locality,
          p.administrativeArea,
          p.country
        ].where((e) => e != null && e.isNotEmpty).join(', ');

        setState(() {
          _address = address;
        });
      } else {
        setState(() {
          _address = "Lat: ${position.latitude}, Lon: ${position.longitude}";
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[900],
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: _loading
                ? const Text("📍 Détection en cours...",
                    style: TextStyle(color: Colors.white))
                : _error != null
                    ? Text(
                        "❌ Erreur: $_error",
                        style: const TextStyle(color: Colors.redAccent),
                      )
                    : Text(
                        _address ?? "Position inconnue",
                        style: const TextStyle(color: Colors.white),
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
