import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'HomePage.dart'; // Assure-toi d'importer

class MapPage extends StatefulWidget {
  final double userLat;
  final double userLng;
  final double parkingLat;
  final double parkingLng;

  const MapPage({
    Key? key,
    required this.userLat,
    required this.userLng,
    required this.parkingLat,
    required this.parkingLng,
  }) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapController controller;

  @override
  void initState() {
    super.initState();
    controller = MapController(
      initMapWithUserPosition: null,
      initPosition: GeoPoint(
        latitude: widget.userLat,
        longitude: widget.userLng,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initAndDrawRoad(); // ✅ bien
    });
  }

  Future<void> _initAndDrawRoad() async {
    try {
      controller.init();
      debugPrint("Map initialized");

      await controller.zoomToBoundingBox(
        BoundingBox(
          north: widget.userLat > widget.parkingLat
              ? widget.userLat
              : widget.parkingLat,
          south: widget.userLat < widget.parkingLat
              ? widget.userLat
              : widget.parkingLat,
          east: widget.userLng > widget.parkingLng
              ? widget.userLng
              : widget.parkingLng,
          west: widget.userLng < widget.parkingLng
              ? widget.userLng
              : widget.parkingLng,
        ),
        paddinInPixel: 50, // ✅ correction ici
      );
      debugPrint("Zoom OK");

      await drawRoadToParking();
      debugPrint("Route dessinée");
    } catch (e) {
      debugPrint("Erreur dans initAndDrawRoad: $e");
    }
  }

  Future<void> drawRoadToParking() async {
    await controller.drawRoad(
      GeoPoint(latitude: widget.userLat, longitude: widget.userLng),
      GeoPoint(latitude: widget.parkingLat, longitude: widget.parkingLng),
      roadType: RoadType.car,
      roadOption: const RoadOption(
        roadWidth: 10,
        roadColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Parking Map")),
      body: OSMFlutter(
        controller: controller,
        osmOption: OSMOption(
          zoomOption: ZoomOption(
            initZoom: 14,
            minZoomLevel: 8,
            maxZoomLevel: 18,
            stepZoom: 1.0,
          ),
          userLocationMarker: UserLocationMaker(
            personMarker: MarkerIcon(
              icon: Icon(Icons.person_pin_circle, color: Colors.blue, size: 60),
            ),
            directionArrowMarker: MarkerIcon(
              icon: Icon(Icons.navigation, color: Colors.blue, size: 60),
            ),
          ),
          roadConfiguration: RoadOption(
            roadColor: Colors.blue,
            roadWidth: 5,
          ),
          staticPoints: [
            StaticPositionGeoPoint(
              "parking",
              MarkerIcon(
                icon: Icon(Icons.location_on, color: Colors.red, size: 48),
              ),
              [
                GeoPoint(
                    latitude: widget.parkingLat, longitude: widget.parkingLng)
              ],
            ),
          ],
          userTrackingOption: const UserTrackingOption(
            enableTracking: false,
            unFollowUser: false,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
