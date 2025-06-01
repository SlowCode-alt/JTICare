import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_akhir_donasi_android/API/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class HubungiKamiPage extends StatefulWidget {
  const HubungiKamiPage({super.key});

  @override
  State<HubungiKamiPage> createState() => _HubungiKamiPageState();
}

class _HubungiKamiPageState extends State<HubungiKamiPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _pesanController = TextEditingController();
  bool _isLoading = false; // State loading untuk tombol kirim

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Panggil fungsi untuk memuat data pengguna (email & nama)
  }

  // Fungsi untuk memuat email dan nama dari SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userEmail = prefs.getString('email'); // Ambil email
    final userFullname = prefs.getString('fullname'); // Ambil nama lengkap

    if (mounted) {
      // Pastikan widget masih mounted sebelum setState
      setState(() {
        if (userEmail != null) {
          _emailController.text = userEmail; // Set nilai email ke controller
        }
        if (userFullname != null) {
          _namaController.text = userFullname; // Set nilai nama ke controller
        }
      });
    }
  }

  void _kirimPesan() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Mulai loading
      });

      try {
        final response = await http.post(
          ApiConfig.sendEmailUrl,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': _emailController.text,
            'nama': _namaController.text,
            'pesan': _pesanController.text,
          }),
        );

        if (!mounted)
          return; // Penting: Cek mounted sebelum setState/ScaffoldMessenger

        // Tangani respons kosong
        if (response.body.isEmpty) {
          _showSnackBar('Server mengembalikan respons kosong.');
          return;
        }

        final Map<String, dynamic> responseData =
            json.decode(response.body); // Dekode JSON

        if (response.statusCode == 200 && responseData['status'] == 'success') {
          _showSnackBar(responseData['message'] ?? 'Pesan berhasil dikirim');
          // Field email dan nama tidak perlu dikosongkan karena otomatis dari profil
          _pesanController.clear(); // Kosongkan hanya pesan
        } else {
          // Tangani error dari server (misal validasi gagal, status 'error')
          _showSnackBar(responseData['message'] ?? 'Gagal mengirim pesan');
        }
      } catch (e) {
        // Tangani FormatException atau error jaringan lainnya
        if (e is FormatException) {
          _showSnackBar('Terjadi kesalahan format data dari server. (Cek log)');
        } else {
          _showSnackBar('Terjadi kesalahan: $e');
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false; // Berhenti loading
          });
        }
      }
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _namaController.dispose();
    _pesanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hubungi Kami'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ada pertanyaan atau saran? Kirimkan pesan pada kami",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    readOnly: true, // Email hanya bisa dibaca
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email harus diisi'; // Ini mungkin tidak akan terjadi jika email selalu ada
                      }
                      if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Email tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true, // Nama hanya bisa dibaca
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama harus diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _pesanController,
                    decoration: const InputDecoration(
                      labelText: 'Pesan',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pesan harus diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : _kirimPesan, // Nonaktifkan saat loading
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Kirim', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Alamat",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "Jl. Mastrip, Krajan Timur, Sumbersari, Kec. Sumbersari, Kabupaten Jember, Jawa Timur\n68121",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              "Telepon",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "08371497297419",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              "Email",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "sabiteam23@gmail.com",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
