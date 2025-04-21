import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import '../models/carpark.dart';
import '../services/location_service.dart';
import '../services/carpark_service.dart';
import '../widgets/carpark_info_card.dart';
import 'package:flutter_map/flutter_map.dart';

class FindParkingPage extends StatefulWidget {
  const FindParkingPage({Key? key}) : super(key: key);

  @override
  _FindParkingPageState createState() => _FindParkingPageState();
}

class _FindParkingPageState extends State<FindParkingPage> {
  final MapController _mapController = MapController();
  final LocationService _locationService = LocationService();
  final CarparkService _carparkService = CarparkService();

  LatLng? _currentLocation;
  List<Carpark> _nearbyCarparks = [];
  Carpark? _selectedCarpark;
  bool _isLoading = true;
  bool _isDarkMode = false;
  List<LatLng> _routePoints = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Position position = await _locationService.determinePosition();
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      // Ensure the map is rendered before moving the controller
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_currentLocation != null) {
          _mapController.move(_currentLocation!, 15.0);
        }
      });

      _fetchNearbyCarparks();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    }
  }

  Future<void> _fetchNearbyCarparks() async {
    if (_currentLocation == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(
          'http://127.0.0.1:8000/accounts/nearby-carparks/?lat=${_currentLocation!.latitude}&lng=${_currentLocation!.longitude}'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // print(data); // Debug log to inspect the API response
        print('API Response: $data');
        setState(() {
          _nearbyCarparks = data.map((json) => Carpark.fromJson(json)).toList();
          print(_nearbyCarparks); // Debug log to inspect the parsed car parks
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load carparks');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching carparks: $e')),
      );
    }
  }

  Future<void> _selectCarpark(Carpark carpark) async {
    if (carpark == null) return; // Add null check

    setState(() {
      _selectedCarpark = carpark;
      _isLoading = true;
    });

    try {
      final route = await _carparkService.getRoute(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
        carpark.latitude,
        carpark.longitude,
      );

      setState(() {
        _routePoints = route;
        _isLoading = false;
      });

      _mapController.move(
        LatLng(carpark.latitude, carpark.longitude),
        15.0,
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting route: $e')),
      );
    }
  }

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Parking'),
        actions: [
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: _toggleDarkMode,
          ),
        ],
      ),
      body: _isLoading && _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentLocation ?? LatLng(0, 0),
                    initialZoom: 15.0,
                  ),
                  children: [
                    TileLayer(
                      tileProvider: NetworkTileProvider(),
                      urlTemplate: _isDarkMode
                          ? 'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png'
                          : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    // Current location marker
                    if (_currentLocation != null)
                 MarkerLayer(
  markers: [
    Marker(
      point: _currentLocation!,
      width: 40,
      height: 40,
      child: const Icon(
        Icons.my_location,
        color: Colors.blue,
        size: 30,
      ),
    ),
  ],
),

                    // Carpark markers
                   MarkerLayer(
  markers: _nearbyCarparks.map((carpark) {
    return Marker(
      width: 40.0,
      height: 40.0,
      point: LatLng(carpark.latitude, carpark.longitude),
      child: GestureDetector(
        onTap: () => _selectCarpark(carpark),
        child: Icon(
          Icons.local_parking,
          color: _selectedCarpark == carpark ? Colors.green : Colors.red,
          size: 30.0,
        ),
      ),
    );
  }).toList(),
),
                    if (_routePoints.isNotEmpty)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: _routePoints,
                            strokeWidth: 4.0,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                  ],
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  right: 10,
                  child: Card(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for a location',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.my_location),
                          onPressed: _getCurrentLocation,
                        ),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15),
                      ),
                      onSubmitted: (value) {
                        // TODO: Implement search functionality
                      },
                    ),
                  ),
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.3,
                  minChildSize: 0.1,
                  maxChildSize: 0.6,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: _isDarkMode ? Colors.grey[900] : Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              width: 40,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Nearby Car Parks',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    _isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                          Expanded(
                            child: _isLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : _nearbyCarparks.isEmpty
                                    ? Center(
                                        child: Text(
                                          'No car parks found nearby',
                                          style: TextStyle(
                                            color: _isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      )
                                    : ListView.builder(
                                        controller: scrollController,
                                        itemCount: _nearbyCarparks.length,
                                        itemBuilder: (context, index) {
                                          final carpark =
                                              _nearbyCarparks[index];
                                          return CarparkInfoCard(
                                            carpark: carpark,
                                            isSelected:
                                                carpark == _selectedCarpark,
                                            isDarkMode: _isDarkMode,
                                            onTap: () =>
                                                _selectCarpark(carpark),
                                          );
                                        },
                                      ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                if (_isLoading && _currentLocation != null)
                  const Positioned.fill(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
      floatingActionButton: _selectedCarpark != null
          ? FloatingActionButton.extended(
              onPressed: () {
                final url =
                    'https://www.google.com/maps/dir/?api=1&destination=${_selectedCarpark!.latitude},${_selectedCarpark!.longitude}&travelmode=driving';
                launchUrl(Uri.parse(url));
              },
              label: const Text('Navigate'),
              icon: const Icon(Icons.navigation),
            )
          : null,
    );
  }
}
