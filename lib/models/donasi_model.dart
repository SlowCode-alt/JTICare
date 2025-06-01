import 'dart:developer' as developer;
import 'package:project_akhir_donasi_android/API/api_config.dart'; // <<< ADD THIS IMPORT STATEMENT

class Donasi {
  final int id;
  // Make idUser nullable. Your KategoriDonasiApiController::show doesn't return it.
  final int? idUser;
  final String judulDonasi;
  final String gambar;
  final String deskripsi;
  final double targetDana;
  final int jumlahDonatur;
  final double donasiTerkumpul;
  final String? deadline;
  final String tanggalBuat;
  final String status;
  // Make createdAt and updatedAt nullable. Your KategoriDonasiApiController::show doesn't return them in 'data'.
  final String? createdAt;
  final String? updatedAt;

  Donasi({
    required this.id,
    this.idUser, // Not required anymore
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
    developer.log('DEBUG (DonasiModel): Menerima JSON untuk parsing: $json',
        name: 'DonasiModel');

    // Your KategoriDonasiApiController::show returns a full URL like "https://jticare.my.id/storage/images/abc.jpg"
    // So, we can directly use the 'gambar' value from the JSON.
    final String fullImageUrl = json['gambar']?.toString() ?? '';

    return Donasi(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      // idUser is not present in KategoriDonasiApiController::show response, so it will be null.
      // Removed the unnecessary `?? 0` if `idUser` is `null`able.
      idUser: int.tryParse(json['id_user']?.toString() ?? ''),
      judulDonasi: json['judul_donasi']?.toString() ?? 'Tanpa Judul',
      gambar: fullImageUrl, // Use the full URL directly
      deskripsi: json['deskripsi']?.toString() ?? 'Tanpa Deskripsi',
      targetDana: double.tryParse(json['target_dana']?.toString() ?? '0') ?? 0,
      jumlahDonatur:
          int.tryParse(json['jumlah_donatur']?.toString() ?? '0') ?? 0,
      donasiTerkumpul:
          double.tryParse(json['donasi_terkumpul']?.toString() ?? '0') ?? 0,
      // Use 'deadline' as primary, fallback to 'dedline' (typo) if 'deadline' is null.
      deadline: json['deadline']?.toString() ?? json['dedline']?.toString(),
      tanggalBuat:
          json['tanggal_buat']?.toString() ?? DateTime.now().toString(),
      status: json['status']?.toString() ?? 'tidak diketahui',
      // These fields are not explicitly returned by KategoriDonasiApiController::show in the 'data' object.
      // They will remain null if not present in the JSON.
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}
