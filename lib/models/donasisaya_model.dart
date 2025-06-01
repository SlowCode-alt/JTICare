import 'package:project_akhir_donasi_android/models/donasi_model.dart';

class DonasiSaya {
  final int id;
  final int dataDonaturId;
  final String namaDonatur;
  final String email;
  final String noWhatsapp;
  final String kategoriDonasi;
  final int kategoriDonasiId; // Tambahkan field ini
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
    required this.kategoriDonasiId, // Tambahkan ini ke konstruktor
    required this.gambarDonasi,
    required this.nominal,
    required this.metodePembayaran,
    required this.status,
    required this.tanggalTransaksi,
    required this.waktuBerlalu,
  });

  // Metode toDonasi ini tidak akan digunakan lagi untuk "Donasi Lagi"
  // Karena kita akan mengambil data Donasi yang lengkap dari API
  Donasi toDonasi() {
    return Donasi(
      id: kategoriDonasiId, // Menggunakan kategoriDonasiId sebagai ID donasi kampanye
      idUser: 0, // Ini mungkin perlu disesuaikan jika ada ID user di DonasiSaya
      judulDonasi: kategoriDonasi,
      gambar: 'https://jticare.my.id/storage/$gambarDonasi',
      deskripsi:
          'Deskripsi donasi', // Deskripsi default, bisa kosong atau sesuaikan
      targetDana: 0, // Default, akan diganti dari API
      jumlahDonatur: 0, // Default, akan diganti dari API
      donasiTerkumpul: nominal, // Ini hanya donasi individual
      deadline: null, // Default
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
      kategoriDonasi:
          json['kategori_donasi']?.toString() ?? 'Tidak Ada Kategori',
      kategoriDonasiId:
          int.tryParse(json['kategori_donasi_id']?.toString() ?? '0') ??
              0, // Pastikan ini ada dan diparsing
      gambarDonasi: json['gambar_donasi']?.toString() ?? '',
      nominal: double.tryParse(json['nominal']?.toString() ?? '0') ?? 0,
      metodePembayaran: json['metode_pembayaran']?.toString() ?? '',
      status: json['status']?.toString() ?? 'tidak diketahui',
      tanggalTransaksi: json['tanggal_transaksi']?.toString() ?? '',
      waktuBerlalu: json['waktu_berlalu']?.toString() ?? '',
    );
  }
}
