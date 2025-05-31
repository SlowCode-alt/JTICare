import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_akhir_donasi_android/models/donasisaya_model.dart';

class DonaturService {
  final String baseUrl = 'https://jticare.my.id/api'; // Ganti dengan URL API kamu

  Future<Map<String, dynamic>> getDataDonatur() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print('DEBUG: Token tidak ditemukan.');
      throw Exception('Token tidak ditemukan. Harap login terlebih dahulu.');
    }

    final url = '$baseUrl/data-donatur';
    print('DEBUG: Mengirim GET request ke $url dengan token: $token');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('DEBUG: Response status: ${response.statusCode}');
    print('DEBUG: Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print('DEBUG: Data yang diterima: ${jsonData['data']}');
      return {
        'status': true,
        'data': jsonData['data'],
        'periode': jsonData['periode'],
      };
    } else {
      final errorData = json.decode(response.body);
      print('DEBUG: Error dari server: $errorData');
      return {
        'status': false,
        'message': errorData['message'] ?? 'Gagal mengambil data donatur.',
      };
    }
  } catch (e) {
    print('DEBUG: Exception terjadi: $e');
    return {
      'status': false,
      'message': 'Terjadi kesalahan: ${e.toString()}',
    };
  }
}

// In DonaturService.dart
Future<DonasiSaya> getDonasiByKategoriId(int kategoriId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/donasi-by-kategori/$kategoriId'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return DonasiSaya.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load donasi details');
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
}
}
