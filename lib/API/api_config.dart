import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:project_akhir_donasi_android/dashboard/notification/no_donations_exception.dart';
import 'package:project_akhir_donasi_android/models/notifikasi_model.dart';

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:8000"; // Untuk Flutter Web
    } else if (Platform.isAndroid) {
      return "https://jticare.my.id"; // Untuk Android emulator (pastikan ini benar untuk HP asli juga)
    } else {
      return "http://localhost:8000"; // Untuk iOS simulator / desktop
    }
  }

  static String get imageBaseUrl {
    return '$baseUrl/storage/';
  }

  static Uri buildUrl(String endpoint) {
    endpoint = endpoint.replaceAll(RegExp(r'^/|/$'), '');
    return Uri.parse('$baseUrl/api/$endpoint');
  }

  static Uri get updateProfileUrl => buildUrl('update-profile');
  static Uri get updateProfileImageUrl => buildUrl('update-profile-image');
  static Uri get ubahPasswordPengaturanAkunUrl => buildUrl('update-password');
  static Uri get deleteAccountPengaturanAkunUrl => buildUrl('hapus-akun');
  static Uri get sendEmailUrl => buildUrl('hubungi-kami');
  static Uri get fetchNotifikasiUrl => buildUrl('transaksi-user');

  static Future<List<NotifikasiModel>> fetchNotifikasi(String token) async {
    final url = fetchNotifikasiUrl;

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);

        if (jsonBody is Map<String, dynamic> &&
            jsonBody.containsKey('data') &&
            jsonBody['data'] is List) {
          final List data = jsonBody['data'];
          if (data.isEmpty) {
            // Jika data kosong tapi status 200, anggap "Data tidak ditemukan"
            throw const NoDonationsFoundException('Data tidak ditemukan');
          }
          return data.map((json) => NotifikasiModel.fromJson(json)).toList();
        } else {
          throw Exception(
              'Format respons API tidak valid: "data" tidak ditemukan atau bukan list.');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Token tidak valid atau kadaluarsa.');
      } else if (response.statusCode == 404) {
        // Jika API mengembalikan 404, selalu lempar dengan pesan "Data tidak ditemukan"
        throw const NoDonationsFoundException('Data tidak ditemukan');
      } else {
        throw Exception(
            'Gagal memuat notifikasi. Status: ${response.statusCode}. Body: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
