import 'dart:developer' as developer;

class Donasi {
  final int id;
  final int idUser;
  final String judulDonasi;
  final String gambar;
  final String deskripsi;
  final double targetDana;
  final int jumlahDonatur;
  final double donasiTerkumpul;
  final String deadline;
  final String tanggalBuat;
  final String status;
  final String createdAt;
  final String updatedAt;

  Donasi({
    required this.id,
    required this.idUser,
    required this.judulDonasi,
    required this.gambar,
    required this.deskripsi,
    required this.targetDana,
    required this.jumlahDonatur,
    required this.donasiTerkumpul,
    required this.deadline,
    required this.tanggalBuat,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // Modify the fromJson factory to append the image path with the base URL
  factory Donasi.fromJson(Map<String, dynamic> json) {
    // Create the full image path
    String fullImageUrl = 'http://10.0.2.2:8000/storage/${json['gambar']}';

    // Log the full image URL
    developer.log('Generated image URL: $fullImageUrl', name: 'API');

    return Donasi(
      id: json['id'],
      idUser: json['id_user'],
      judulDonasi: json['judul_donasi'],
      gambar: fullImageUrl,  // Use the generated full image URL
      deskripsi: json['deskripsi'],
      targetDana: double.parse(json['target_dana']),
      jumlahDonatur: json['jumlah_donatur'],
      donasiTerkumpul: double.parse(json['donasi_terkumpul']),
      deadline: json['dedline'] ?? '',  // Handle null
      tanggalBuat: json['tanggal_buat'] ?? '',  // Handle null
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',  // Handle null
      updatedAt: json['updated_at'] ?? '',  // Handle null
    );
  }
}
