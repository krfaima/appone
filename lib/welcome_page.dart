import 'package:appone/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'login_page.dart';

class WelcomePage extends StatelessWidget {
  final String username;
  final AuthService authService = AuthService();

  WelcomePage({required this.username});

  void logout(BuildContext context) {
    authService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void goToHomePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()), // 👈 Redirection vers Home
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Bienvenue, $username !"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => goToHomePage(context),
              child: const Text("Aller à l'accueil"),
            ),
          ],
        ),
      ),
    );
  }
}
