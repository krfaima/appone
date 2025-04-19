import 'package:flutter/material.dart';
import 'dart:async';
import 'register_page.dart';
import 'pages/find_parking_page.dart'; // 👈 Import the Find Parking page


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/register': (context) => RegisterPage(),
        '/find_parking': (context) => const FindParkingPage(), // 👈 Add the route
      },
    );
  }
}

// ✅ Splash Screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 6), () {
      Navigator.of(context).pushReplacementNamed('/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo1.png', width: 200, height: 200),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// ✅ Onboarding Screen
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _pages = const [
    OnboardingPage(
      image: 'assets/image1.png',
      text: 'Find Parking Spot Around You Easily.',
    ),
    OnboardingPage(
      image: 'assets/image2.png',
      text: 'Book and Pay Parking Quickly and Smartly.',
    ),
    OnboardingPage(
      image: 'assets/image3.png',
      text: 'Extend Parking Time As You Need.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: _pages,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pages.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: _currentPage == index ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? Colors.blue : Colors.grey,
                ),
              );
            }),
          ),
          const SizedBox(height: 20),

          // ✅ Bouton "Skip"
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/register');
            },
            child: const Text("Skip", style: TextStyle(color: Colors.blue)),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage == _pages.length - 1) {
                  Navigator.of(context).pushReplacementNamed('/register');
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                }
              },
              child: Text(
                _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ✅ Widget réutilisable pour les pages d'onboarding
class OnboardingPage extends StatelessWidget {
  final String image;
  final String text;

  const OnboardingPage({super.key, required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, width: double.infinity),
          const SizedBox(height: 40),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}