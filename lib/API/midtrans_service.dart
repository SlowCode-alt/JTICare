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
  required String userId,
}) async {
  print('\n[MidtransService] Membuat charge...');
  print('Endpoint: $baseUrl/donasi/create-charge');
  
  final token = await TokenManager.getToken();
  final currentUserId = await TokenManager.getUserId();
  
  print('Token: ${token != null ? 'tersedia' : 'null'}');
  print('User ID dari TokenManager: $currentUserId');
  print('User ID dari parameter: $userId');

  if (token == null || currentUserId == null) {
    print('Error: Token atau User ID tidak tersedia');
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

    print('Request Body:');
    print(body);

    print('Mengirim POST request...');
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body:');
    print(response.body);

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (responseData['success'] == true) {
        print('Transaksi berhasil dibuat');
        return {
          'success': true,
          'snap_token': responseData['snap_token'],
          'order_id': responseData['order_id'],
          'nominal': responseData['gross_amount'],
        };
      } else {
        print('Transaksi gagal: ${responseData['message']}');
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to create transaction',
          'error': responseData['error'] ?? 'Unknown error',
        };
      }
    } else {
      print('Response tidak sukses: ${response.statusCode}');
      return {
        'success': false,
        'message': 'HTTP Error ${response.statusCode}',
        'error': response.body,
      };
    }
  } catch (e) {
    print('Exception terjadi: $e');
    return {
      'success': false,
      'message': 'An error occurred',
      'error': e.toString(),
    };
  }
}
}
