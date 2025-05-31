import 'dart:developer' as developer;
import 'package:project_akhir_donasi_android/API/api_config.dart';

class Donasi {
  final int id;
  final int idUser;
  final String judulDonasi;
  final String gambar;
  final String deskripsi;
  final double targetDana;
  final int jumlahDonatur;
  final double donasiTerkumpul;
  final String? deadline;
  final String tanggalBuat;
  final String status;
  final String? createdAt;
  final String? updatedAt;

  Donasi({
    required this.id,
    required this.idUser,
    required this.judulDonasi,
    required this.gambar,
    required this.deskripsi,
    required this.targetDana,
    required this.jumlahDonatur,
    required this.donasiTerkumpul,
    this.deadline,
    required this.tanggalBuat,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Donasi.fromJson(Map<String, dynamic> json) {
    try {
      final baseUrl = ApiConfig.baseUrl;
      final imagePath = json['gambar']?.toString() ?? '';
      final fullImageUrl =
          imagePath.isNotEmpty ? '$baseUrl/storage/$imagePath' : '';

      developer.log('Generated image URL: $fullImageUrl', name: 'API');

      return Donasi(
        id: int.tryParse(json['id'].toString()) ?? 0,
        idUser: int.tryParse(json['id_user'].toString()) ?? 0,
        judulDonasi: json['judul_donasi']?.toString() ?? 'No Title',
        gambar: fullImageUrl,
        deskripsi: json['deskripsi']?.toString() ?? 'No Description',
        targetDana:
            double.tryParse(json['target_dana']?.toString() ?? '0') ?? 0,
        jumlahDonatur: int.tryParse(json['jumlah_donatur'].toString()) ?? 0,
        donasiTerkumpul:
            double.tryParse(json['donasi_terkumpul']?.toString() ?? '0') ?? 0,
        deadline: json['deadline']?.toString() ?? json['dedline']?.toString(),
        tanggalBuat:
            json['tanggal_buat']?.toString() ?? DateTime.now().toString(),
        status: json['status']?.toString() ?? 'unknown',
        createdAt: json['created_at']?.toString(),
        updatedAt: json['updated_at']?.toString(),
      );
    } catch (e) {
      developer.log('Error parsing Donasi: $e', name: 'API', error: e);
      throw FormatException('Failed to parse Donasi: $e');
    }
  }
}
