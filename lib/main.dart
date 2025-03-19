import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_akhir_donasi_android/login.dart';

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
        fontFamily: 'Poppins', // Set Poppins sebagai font default
      ),
      home: SplashScreen(), // Mulai dari SplashScreen dulu
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

    // delaynya
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Ubah warna sesuai kebutuhan
      body: Center(
        child: Image.asset(
          'assets/logojticare.png', // Pastikan path benar
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
