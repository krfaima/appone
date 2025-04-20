import 'dart:convert';
import 'package:http/http.dart' as http;
import 'parking.dart'; // le fichier modèle

Future<List<Parking>> fetchParkings() async {
  // final response = await http.get(Uri.parse('http://192.168.100.6:8000/api/parkings/')); // utilise l’IP selon ton environnement
  // final response = await http.get(Uri.parse('http://127.0.0.1:8000/accounts/parkings')); // utilise l’IP selon ton environnement
final response = await http.get(Uri.parse('http://127.0.0.1:8000/accounts/parkings/'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Parking.fromJson(json)).toList();
  } else {
    throw Exception('Erreur de chargement des parkings');
  }
}
