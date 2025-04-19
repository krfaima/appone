import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'login_page.dart';  // Assure-toi d'importer la page de connexion

class WelcomePage extends StatelessWidget {
  final String username;
  final AuthService authService = AuthService();

  WelcomePage({required this.username});

  void logout(BuildContext context) {
    authService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Redirection vers la page de connexion
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome $username"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: Center(
        child: Text("Bienvenue, $username !"),
      ),
    );
  }
}
