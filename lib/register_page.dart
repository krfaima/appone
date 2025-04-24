import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'verify_code_page.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  bool isLoading = false;

  void registerUser() async {
    setState(() => isLoading = true);

    String? errorMessage = await authService.register(
      emailController.text.trim(),
      usernameController.text.trim(),
      passwordController.text.trim(),
    );

    setState(() => isLoading = false);

    if (errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Inscription réussie ! Vérifiez votre e-mail.")),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VerifyCodePage(email: emailController.text)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("S'inscrire")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: usernameController, decoration: InputDecoration(labelText: "Nom d'utilisateur")),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: "Mot de passe"), obscureText: true),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: registerUser,
                    child: Text("S'inscrire"),
                  ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text("Déjà un compte ? Se connecter"),
            ),
            SizedBox(height: 20),

            // ✅ Ajout du bouton "Find Parking"
           
          ],
        ),
      ),
    );
  }
}
