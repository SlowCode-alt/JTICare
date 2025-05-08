import 'package:flutter/material.dart';

class PengaturanAkunPage extends StatefulWidget {
  const PengaturanAkunPage({super.key});

  @override
  _PengaturanAkunPageState createState() => _PengaturanAkunPageState();
}

class _PengaturanAkunPageState extends State<PengaturanAkunPage> {
  // Controllers untuk menyimpan nilai input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inisialisasi data (untuk contoh, bisa diganti dengan data asli)
    _emailController.text = "giyagyuu46@gmail.com";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Akun'),
        backgroundColor: Colors.white,
        elevation: 0, // Menghilangkan shadow
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Email
            const Text(
              "Email",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Akun email anda\n${_emailController.text}",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Fungsi untuk mengubah email
                  },
                  child: const Text(
                    "Ganti",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Kata Sandi
            const Text(
              "Kata Sandi",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "*Masukkan kata sandi anda saat ini untuk membuat kata sandi baru",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Kata sandi baru",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Kata sandi saat ini",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Simpan Perubahan
            ElevatedButton(
              onPressed: () {
                // Fungsi untuk menyimpan perubahan
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Perubahan disimpan!")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Simpan Perubahan",
                style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // Hapus akun
            const Divider(),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Fungsi untuk menghapus akun
              },
              child: const Text(
                "Saya ingin menghapus akun",
                style: TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
