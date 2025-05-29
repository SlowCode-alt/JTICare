import 'package:flutter/material.dart';
import 'package:project_akhir_donasi_android/login.dart';
import 'package:project_akhir_donasi_android/dashboard/dashboard.dart';
import 'package:project_akhir_donasi_android/utils/TokenManager.dart'; // Import TokenManager

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final bool showIntro;
  const MyApp({super.key, required this.showIntro});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins', // Set Poppins as default font
      ),
      home: SplashScreen(), // Start with SplashScreen
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Check if token exists and navigate accordingly after a delay
    _checkToken();
  }

  // Function to check the token
  Future<void> _checkToken() async {
    final token = await TokenManager.getToken();
    // Delay to show splash screen before redirecting
    Future.delayed(const Duration(seconds: 3), () {
      if (token != null && token.isNotEmpty) {
        // If token exists, navigate to DashboardScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      } else {
        // If no token, navigate to LoginScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Customize the background color
      body: Center(
        child: Image.asset(
          'assets/logojticare.png', // Ensure the asset path is correct
          width: 200,
          height: 200,
        ),
      ),
    );
  }
} 