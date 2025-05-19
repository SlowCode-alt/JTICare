import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:8000"; // Untuk Flutter Web
    } else if (Platform.isAndroid) {
      return "http://10.0.2.2:8000"; // Untuk Android emulator
    } else {
      return "http://localhost:8000"; // Untuk iOS simulator / desktop
    }
  }

  // Menambahkan URL untuk gambar
  static String get imageBaseUrl {
    return '$baseUrl/storage/profile_photos/'; // Menambahkan path gambar
  }

  static Uri buildUrl(String endpoint) {
    return Uri.parse('$baseUrl/api/$endpoint');
  }

  static Uri get updateProfileUrl {
    return buildUrl('update-profile');
  }

  static Uri get updateProfileImageUrl {
    return buildUrl('update-profile-image');
  }

  static Uri get ubahPasswordPengaturanAkunUrl {
    return buildUrl('ubahPasswordProfile');
  }

  static Uri get deleteAccountPengaturanAkunUrl {
    return buildUrl('deleteAccountProfile');
  }

  static Uri get sendEmailUrl {
    return buildUrl('hubungi-kami');
  }
}
