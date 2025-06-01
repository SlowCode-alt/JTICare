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
  String? _authToken; // Untuk menyimpan token autentikasi

  @override
  void initState() {
    super.initState();
    _loadUserDataAndToken(); // Panggil fungsi untuk memuat data pengguna & token
  }

  // Fungsi untuk memuat email, nama, dan token dari SharedPreferences
  Future<void> _loadUserDataAndToken() async {
    final prefs = await SharedPreferences.getInstance();
    final userEmail = prefs.getString('email');
    final userFullname = prefs.getString('fullname');
    final token = prefs.getString('token'); // Ambil token

    if (mounted) {
      setState(() {
        if (userEmail != null) {
          _emailController.text = userEmail;
        }
        if (userFullname != null) {
          _namaController.text = userFullname;
        }
        _authToken = token; // Simpan token
      });
    }
  }

  void _kirimPesan() async {
    if (_formKey.currentState!.validate()) {
      if (_authToken == null || _authToken!.isEmpty) {
        _showSnackBar('Anda belum login atau token tidak ditemukan.');
        return;
      }

      setState(() {
        _isLoading = true; // Mulai loading
      });

      try {
        final response = await http.post(
          ApiConfig.sendEmailUrl,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_authToken', // Kirim token autentikasi
            'Accept': 'application/json', // Tambahkan header Accept
          },
          body: jsonEncode({
            // 'email': _emailController.text, // TIDAK PERLU DIKIRIM DARI FLUTTER
            // 'nama': _namaController.text, // TIDAK PERLU DIKIRIM DARI FLUTTER
            'pesan': _pesanController.text,
          }),
        );

        if (!mounted) return;

        // Tangani respons kosong atau non-JSON
        if (response.body.isEmpty) {
          if (response.statusCode == 200) {
            // Jika status 200 tapi body kosong, mungkin ada sesuatu yang tidak biasa tapi sukses
            _showSnackBar('Pesan berhasil dikirim (respons server kosong).');
            _pesanController.clear();
          } else {
            _showSnackBar(
                'Server mengembalikan respons kosong atau tidak valid. Status: ${response.statusCode}');
          }
          return;
        }

        // Pastikan respons adalah JSON yang valid
        Map<String, dynamic> responseData;
        try {
          responseData = json.decode(response.body);
        } catch (e) {
          _showSnackBar('Gagal mendekode respons server: $e');
          return;
        }

        if (response.statusCode == 200 && responseData['status'] == 'success') {
          _showSnackBar(responseData['message'] ?? 'Pesan berhasil dikirim');
          _pesanController.clear();
        } else {
          // Tangani error dari server (misal validasi gagal, status 'error')
          // Log respons body lengkap untuk debugging
          print('Error Response Body: ${response.body}');
          _showSnackBar(responseData['message'] ?? 'Gagal mengirim pesan');
        }
      } catch (e) {
        // Tangani FormatException atau error jaringan lainnya
        if (e is FormatException) {
          _showSnackBar('Terjadi kesalahan format data dari server. (Cek log)');
          print('FormatException: $e');
        } else if (e is http.ClientException) {
          _showSnackBar(
              'Gagal terhubung ke server. Periksa koneksi internet atau URL API.');
          print('ClientException: $e');
        } else {
          _showSnackBar('Terjadi kesalahan tidak terduga: $e');
          print('Unexpected Error: $e');
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
                        return 'Email harus diisi';
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
