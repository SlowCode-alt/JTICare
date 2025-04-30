import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Controllers untuk menyimpan nilai input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();

  // Gambar profil yang bisa diganti
  AssetImage _profileImage = AssetImage('assets/profile_picture.png'); 

  @override
  void initState() {
    super.initState();
    // Inisialisasi data (untuk contoh, bisa diganti dengan data asli)
    _nameController.text = "Kariena Adelia";
    _emailController.text = "giyagyuu46@gmail.com";
    _whatsappController.text = "085807278580";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: Colors.white,
        elevation: 0, // Menghilangkan shadow
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            // Foto Profil dengan ikon kamera
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage,
                ),
                GestureDetector(
                  onTap: () {
                    // Fungsi untuk mengganti gambar profil (bisa pakai image picker atau lainnya)
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue, // Warna background ikon kamera
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Nama Lengkap
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Nama Lengkap",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // Email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // Nomor WhatsApp
            TextField(
              controller: _whatsappController,
              decoration: InputDecoration(
                labelText: "Nomor WhatsApp",
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
                backgroundColor: Colors.blue, // Ganti primary dengan backgroundColor
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
          ],
        ),
      ),
    );
  }
}
