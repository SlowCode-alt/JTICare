import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:project_akhir_donasi_android/API/api_config.dart';
import 'package:project_akhir_donasi_android/models/donasi_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DonasiService {
  final String _baseUrl = ApiConfig.baseUrl;

  Future<Donasi> getDonasiById(int id) async {
    // URL yang benar sekarang: https://jticare.my.id/api/donasi/{id}
    final uri = Uri.parse('$_baseUrl/api/donasi/$id');
    developer.log('Mengambil detail donasi dari: $uri', name: 'DonasiService');

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          if (token != null)
            'Authorization':
                'Bearer $token', // Sertakan token jika diperlukan oleh API
        },
      );

      developer.log('Status code: ${response.statusCode}',
          name: 'DonasiService');
      developer.log('Response body: ${response.body}', name: 'DonasiService');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 'success' &&
            responseData['data'] != null) {
          // Perhatikan bahwa di backend, Anda mengembalikan 'status' sebagai string 'success'/'error',
          // dan field 'data' berisi objek kampanye donasi.
          return Donasi.fromJson(responseData['data']);
        } else {
          throw Exception(
              responseData['message'] ?? 'Gagal mengambil data donasi');
        }
      } else {
        String errorMessage =
            'Gagal mengambil data donasi. Status code: ${response.statusCode}';
        try {
          final errorData = json.decode(response.body);
          errorMessage = errorData['message'] ?? errorMessage;
        } catch (e) {
          // Biarkan errorMessage default jika body bukan JSON
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      developer.log('Kesalahan saat mengambil detail donasi: $e',
          name: 'DonasiService', error: e);
      rethrow;
    }
  }
}
