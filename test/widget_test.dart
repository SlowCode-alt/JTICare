import 'package:flutter/material.dart'; // Tambahkan ini jika belum ada
import 'package:flutter_test/flutter_test.dart';
import 'package:project_akhir_donasi_android/main.dart'; // MyApp dan SplashScreen
import 'package:project_akhir_donasi_android/login.dart'; // LoginScreen
import 'package:project_akhir_donasi_android/dashboard/dashboard.dart'; // DashboardScreen
// import 'package:project_akhir_donasi_android/widget/intro_splashscreen.dart'; // Jika IntroSplashScreen masih ada dan ingin dites terpisah, tapi sepertinya sudah diganti SplashScreen

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Tambahkan ini untuk mock dotenv

void main() {
  // Mock dotenv untuk menghindari NotInitializedError saat test
  setUpAll(() async {
    // Memastikan binding siap untuk inisialisasi dotenv di test
    TestWidgetsFlutterBinding.ensureInitialized();
    // Memuat mock values untuk dotenv
    await dotenv.load(fileName: ".env");
    // Anda bisa mock env variables yang dibutuhkan oleh DetailTransaksiScreen
    // Jika tidak ada file .env di test environment, ini akan memuat secara default kosong.
    // Jika ada nilai spesifik yang dibutuhkan untuk test, bisa di-mock di sini
    // dotenv.testLoad(fileInto: {'API_BASE_URL': 'http://test.api'});
  });

  // Setup mock SharedPreferences sebelum setiap test dijalankan
  setUp(() {
    // Reset mock SharedPreferences untuk setiap test
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Navigates to DashboardScreen if token exists',
      (WidgetTester tester) async {
    // Mock TokenManager to return a non-null token
    // (Jika TokenManager menggunakan SharedPreferences, mock SharedPreferences sudah cukup)
    // Jika TokenManager memiliki implementasi lain, Anda perlu mock TokenManager juga.
    SharedPreferences.setMockInitialValues({'token': 'some_valid_token'});

    await tester
        .pumpWidget(const MyApp()); // Panggil MyApp tanpa parameter showIntro
    // Tunggu durasi SplashScreen (3 detik)
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verifikasi bahwa DashboardScreen ditampilkan
    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });

  testWidgets('Navigates to LoginScreen if no token exists',
      (WidgetTester tester) async {
    // Mock TokenManager to return null/empty token (default SharedPreferences mock)
    SharedPreferences.setMockInitialValues({}); // Pastikan tidak ada token

    await tester
        .pumpWidget(const MyApp()); // Panggil MyApp tanpa parameter showIntro
    // Tunggu durasi SplashScreen (3 detik)
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verifikasi bahwa LoginScreen ditampilkan
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(DashboardScreen), findsNothing);
  });

  // Jika Anda masih ingin menguji tampilan SplashScreen awal, bisa seperti ini:
  testWidgets('Displays SplashScreen initially', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
    expect(find.byType(DashboardScreen), findsNothing);
    // Verifikasi elemen di SplashScreen, contohnya gambar
    expect(find.byKey(const Key('splash_image')),
        findsOneWidget); // Tambahkan Key pada Image.asset di SplashScreen
  });
}
