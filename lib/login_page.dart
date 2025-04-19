import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'register_page.dart';
import 'welcome_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  bool isLoading = false;

  void loginUser() async {
    setState(() {
      isLoading = true;
    });

    String? errorMessage = await authService.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    setState(() {
      isLoading = false;
    });

    if (errorMessage == null) { // 🔹 Succès si `null`
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(" Login successful!")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomePage(username: emailController.text),
        ),
      );
    } else { // 🔹 Affiche le message d'erreur en cas d'échec
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(" $errorMessage")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: isLoading ? null : loginUser, // 🔹 Désactive si `isLoading`
                    child: Text("Login"),
                  ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text("If you don't have an account, create one here"),
            ),
          ],
        ),
      ),
    );
  }
}
