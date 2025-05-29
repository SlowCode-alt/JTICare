// lib/main.dart
import 'package:flutter/services.dart';  // Add this import
import 'package:flutter/material.dart';
import 'package:project_akhir_donasi_android/login.dart';
import 'package:project_akhir_donasi_android/dashboard/dashboard.dart';
import 'package:project_akhir_donasi_android/utils/TokenManager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart'; // <<<--- Import ini
import 'package:project_akhir_donasi_android/widget/intro_splashscreen.dart'; // <<<--- Import IntroSplashScreen Anda

void main() async {
   SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: const SplashScreen(), // Tetap mulai dari SplashScreen
    );
  }
}

// Hapus atau kosongkan SplashScreen yang lama dan gunakan logika baru di sini.
// lib/main.dart (lanjutan, ini adalah bagian SplashScreen yang dimodifikasi)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp(); // Panggil fungsi baru untuk inisialisasi aplikasi
  }

  Future<void> _initializeApp() async {
    // Beri sedikit delay untuk memastikan semua inisialisasi Flutter selesai
    await Future.delayed(const Duration(seconds: 1)); // Delay singkat

    final prefs = await SharedPreferences.getInstance();
    final introSeen =
        prefs.getBool('introSeen') ?? false; // Defaultnya false jika belum ada

    if (!mounted) return; // Pastikan widget masih ada di tree

    if (introSeen) {
      // Jika intro sudah dilihat, cek token untuk navigasi ke Dashboard/Login
      await _checkTokenAndNavigate();
    } else {
      // Jika intro belum dilihat, tampilkan IntroSplashScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const IntroSplashScreen()),
      );
    }
  }

  // Fungsi yang sudah ada untuk mengecek token dan menavigasi
  Future<void> _checkTokenAndNavigate() async {
    final token = await TokenManager.getToken();
    // Beri delay tambahan jika ingin splash screen awal (logo) tampil lebih lama
    await Future.delayed(
         const Duration(seconds: 3)); // Delay tambahan untuk logo splash
    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tampilan awal SplashScreen (logo) sebelum logika _initializeApp selesai
    return Scaffold(
      backgroundColor: Colors.blue, // Sesuaikan warna
      body: Center(
        child: Image.asset(
          'assets/logojticare.png', // Logo awal
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
