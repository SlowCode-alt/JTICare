import 'package:flutter/material.dart';
import 'package:project_akhir_donasi_android/login.dart';
import 'package:project_akhir_donasi_android/widget/intro_splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cek apakah intro sudah pernah ditampilkan
  final prefs = await SharedPreferences.getInstance();
  final introSeen = prefs.getBool('introSeen') ?? false;

  runApp(MyApp(showIntro: !introSeen));
}

class MyApp extends StatelessWidget {
  final bool showIntro;
  const MyApp({super.key, required this.showIntro});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: showIntro ? const IntroSplashScreen() : const LoginScreen(),
    );
  }
}
