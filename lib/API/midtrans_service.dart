import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/TokenManager.dart';

class MidtransService {
  final String baseUrl;

  MidtransService({required this.baseUrl});

  Future<Map<String, dynamic>> createCharge({
    required int nominal,
    required String nama,
    required String email,
    required String telepon,
    required int kategoriDonasiId,
     required String userId, // Tambahkan ini
  }) async {
    final token = await TokenManager.getToken();
    final userId = await TokenManager.getUserId();

    if (token == null || userId == null) {
      return {
        'success': false,
        'message': 'User not authenticated',
        'error': 'Missing token or user ID',
      };
    }

    final url = Uri.parse('$baseUrl/donasi/create-charge');

    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = jsonEncode({
        'nominal': nominal,
        'nama': nama,
        'email': email,
        'telepon': telepon,
        'kategori_donasi_id': kategoriDonasiId,
        'user_id': userId,
      });

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        return {
          'success': true,
          'snap_token': responseData['snap_token'],
          'order_id': responseData['order_id'],
          'nominal': responseData['gross_amount'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to create transaction',
          'error': responseData['error'] ?? 'Unknown error',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred',
        'error': e.toString(),
      };
    }
  }
}
