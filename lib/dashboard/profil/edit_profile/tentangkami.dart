import 'package:flutter/material.dart';

class TentangKamiPage extends StatelessWidget {
  const TentangKamiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Kami'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Deskripsi Singkat',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'JTI Care adalah aplikasi donasi yang dikembangkan untuk membantu warga Jurusan Teknologi Informasi (JTI) yang sedang mengalami kesulitan, baik dalam bentuk kebutuhan ekonomi, bencana, maupun keadaan darurat lainnya.',
              style: TextStyle(fontSize: 16),
            ),
            const Divider(height: 32, thickness: 1),
            const Text(
              'Visi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Menjadi platform donasi internal yang cepat, transparan, dan terpercaya di lingkungan Jurusan Teknologi Informasi.',
              style: TextStyle(fontSize: 16),
            ),
            const Divider(height: 32, thickness: 1),
            const Text(
              'Misi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. Menyediakan sistem penggalangan dana yang mudah diakses dan terpercaya.\n'
              '2. Menyebarluaskan informasi kebutuhan donasi secara cepat kepada seluruh warga JTI.\n'
              '3. Meningkatkan transparansi dan akuntabilitas dalam pengelolaan dana donasi.',
              style: TextStyle(fontSize: 16),
            ),
            const Divider(height: 32, thickness: 1),
            const Text(
              'Fitur Utama',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. Donasi online\n'
              '2. Riwayat donasi\n'
              '3. Berita dan update kasus',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
