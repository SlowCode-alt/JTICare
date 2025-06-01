// import 'package:intl/intl.dart'; // Mungkin tidak perlu jika tidak dipakai langsung di model

class NotifikasiModel {
  final String orderId;
  final String judulDonasi;
  final String grossAmount; // <-- UBAH KE STRING
  final String transactionStatus;
  final String message;
  final String
      createdAtFormatted; // <-- UBAH KE STRING (untuk yang sudah diformat)
  final String imageUrl; // <-- UBAH KE STRING dan disesuaikan namanya

  NotifikasiModel({
    required this.orderId,
    required this.judulDonasi,
    required this.grossAmount,
    required this.transactionStatus,
    required this.message,
    required this.createdAtFormatted, // <-- UBAH KE createdAtFormatted
    required this.imageUrl,
  });

  factory NotifikasiModel.fromJson(Map<String, dynamic> json) {
    // Validasi dan penyesuaian untuk imageUrl (gambar_donasi)
    String imageUrl =
        json['gambar_donasi'] ?? 'https://via.placeholder.com/60?text=No+Image';
    // Jika ada kemungkinan gambar_donasi adalah null, berikan placeholder

    return NotifikasiModel(
      orderId: json['order_id'] as String,
      judulDonasi: json['judul_donasi'] as String,
      // Konversi gross_amount dari String ke int jika Anda ingin int,
      // tetapi jika hanya ditampilkan, String lebih aman
      grossAmount: json['gross_amount']
          as String, // Pastikan ini String jika API mengembalikan String
      transactionStatus: json['transaction_status'] as String,
      message: json['message'] as String,
      createdAtFormatted: json['created_at']
          as String, // Mengambil langsung string yang sudah diformat
      imageUrl: imageUrl, // Menggunakan kunci 'gambar_donasi' dari API
    );
  }
}
