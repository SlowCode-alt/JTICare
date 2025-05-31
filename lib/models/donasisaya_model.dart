import 'package:project_akhir_donasi_android/models/donasi_model.dart';
class DonasiSaya {
  final int id;
  final int dataDonaturId;
  final String namaDonatur;
  final String email;
  final String noWhatsapp;
  final String kategoriDonasi;
  final int kategoriDonasiId; // Add this field
  final String gambarDonasi;
  final double nominal;
  final String metodePembayaran;
  final String status;
  final String tanggalTransaksi;
  final String waktuBerlalu;

  DonasiSaya({
    required this.id,
    required this.dataDonaturId,
    required this.namaDonatur,
    required this.email,
    required this.noWhatsapp,
    required this.kategoriDonasi,
    required this.kategoriDonasiId, // Add this to constructor
    required this.gambarDonasi,
    required this.nominal,
    required this.metodePembayaran,
    required this.status,
    required this.tanggalTransaksi,
    required this.waktuBerlalu,
  });
      // Dalam donasisaya_model.dart
      Donasi toDonasi() {
        return Donasi(
          id: kategoriDonasiId,
          idUser: 0,
          judulDonasi: kategoriDonasi,
          gambar: 'https://jticare.my.id/storage/$gambarDonasi',
          deskripsi: 'Deskripsi donasi',
          targetDana: 0,
          jumlahDonatur: 0,
          donasiTerkumpul: nominal,
          deadline: null,
          tanggalBuat: tanggalTransaksi,
          status: status,
        );
      }
  factory DonasiSaya.fromJson(Map<String, dynamic> json) {
    return DonasiSaya(
      id: int.tryParse(json['id'].toString()) ?? 0,
      dataDonaturId: int.tryParse(json['data_donatur_id'].toString()) ?? 0,
      namaDonatur: json['nama_donatur']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      noWhatsapp: json['no_whatsapp']?.toString() ?? '',
      kategoriDonasi: json['kategori_donasi']?.toString() ?? 'No Category',
      kategoriDonasiId: int.tryParse(json['kategori_donasi_id']?.toString() ?? '0') ?? 0, // Add this line
      gambarDonasi: json['gambar_donasi']?.toString() ?? '',
      nominal: double.tryParse(json['nominal']?.toString() ?? '0') ?? 0,
      metodePembayaran: json['metode_pembayaran']?.toString() ?? '',
      status: json['status']?.toString() ?? 'unknown',
      tanggalTransaksi: json['tanggal_transaksi']?.toString() ?? '',
      waktuBerlalu: json['waktu_berlalu']?.toString() ?? '',
    );
  }
}