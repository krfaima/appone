// services/carpark_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../models/carpark.dart';

class CarparkService {
  // final String baseUrl = 'http://10.0.2.2:8000/api'; // Use this for Android emulator
  // final String baseUrl = 'http://127.0.0.1:8000/accounts'; // Use this for iOS simulator
  final String baseUrl = 'http://192.168.100.6:8000/accounts';

    // final String baseUrl = "http://192.168.100.12:8000/accounts/";


  Future<List<Carpark>> getNearbyCarparks(double latitude, double longitude) async {
    final response = await http.get(
      Uri.parse('$baseUrl/carparks/?lat=$latitude&lng=$longitude'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Carpark.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load car parks');
    }
  }

  Future<List<LatLng>> getRoute(
    double startLat, 
    double startLng, 
    double endLat, 
    double endLng
  ) async {
     final response = await http.get(
    Uri.parse('$baseUrl/route/?start_lat=$startLat&start_lng=$startLng&end_lat=$endLat&end_lng=$endLng'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((point) => LatLng(point[0].toDouble(), point[1].toDouble())).toList();
    } else {
      throw Exception('Failed to load route');
    }
  }
}