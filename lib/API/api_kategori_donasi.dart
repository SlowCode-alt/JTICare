import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/donasi_model.dart'; 

class KategoriDonasiApi {
  static const String apiUrl = 'http://10.0.2.2:8000/api/kategori-donasi';  // Pastikan URL sesuai dengan API Anda


  // Fungsi untuk mengambil kategori donasi dari API
  static Future<List<Donasi>> fetchKategoriDonasi() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Jika request berhasil, parsing data JSON
        final data = json.decode(response.body);
        List<dynamic> donasiData = data['data'];

        // Mengonversi data menjadi list of Donasi
        return donasiData.map((item) => Donasi.fromJson(item)).toList();
      } else {
        throw Exception('Gagal mengambil data, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
