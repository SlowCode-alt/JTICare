import 'package:flutter_test/flutter_test.dart';
import 'package:project_akhir_donasi_android/main.dart';
import 'package:project_akhir_donasi_android/login.dart';
import 'package:project_akhir_donasi_android/widget/intro_splashscreen.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Setup mock SharedPreferences sebelum test dijalankan
  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'introSeen': false, // Bisa diubah true/false sesuai test
    });
  });

  testWidgets('Show IntroSplashScreen when introSeen == false',
      (WidgetTester tester) async {
    // Bisa panggil langsung MyApp dengan parameter karena SharedPreferences sudah dimock
    await tester.pumpWidget(const MyApp(showIntro: true));

    expect(find.byType(IntroSplashScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });

  testWidgets('Show LoginScreen when introSeen == true',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(showIntro: false));

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(IntroSplashScreen), findsNothing);
  });
}
