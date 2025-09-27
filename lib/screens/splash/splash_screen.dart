import 'package:book_finder/bottom_navigation.dart';
import 'package:book_finder/providers/auth_provider.dart';
import 'package:book_finder/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    // Give time for Firebase/AuthProvider to initialize
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.isSignedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNavigationScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset("images/Vector.png", height: 150, width: 150),
          ),
          const SizedBox(height: 20),
          const Text(
            "BOOK FINDER",
            style: TextStyle(
              fontFamily: "Cinzel",
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
