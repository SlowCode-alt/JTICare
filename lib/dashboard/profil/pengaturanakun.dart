import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project_akhir_donasi_android/API/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:developer'
    as developer; // Import developer package for better logging

class PengaturanAkunPage extends StatefulWidget {
  const PengaturanAkunPage({super.key});

  @override
  _PengaturanAkunPageState createState() => _PengaturanAkunPageState();
}

class _PengaturanAkunPageState extends State<PengaturanAkunPage> {
  String _email = "Memuat...";
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  // Removed _deleteConfirmController as delete account section is removed
  bool _isLoading = false; // State untuk loading umum (ubah password)

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email') ?? 'email@example.com';

    if (!mounted) return;
    setState(() {
      _email = savedEmail;
    });
  }

  Future<void> _changePassword() async {
    final newPassword = _newPasswordController.text.trim();
    final currentPassword = _currentPasswordController.text.trim();

    if (newPassword.isEmpty || currentPassword.isEmpty) {
      _showSnackBar("Semua kolom harus diisi.");
      return;
    }

    if (newPassword.length < 8) {
      _showSnackBar("Password baru minimal 8 karakter.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      if (token.isEmpty) {
        _showSnackBar('Token tidak ditemukan. Silakan login kembali.');
        setState(() => _isLoading = false);
        return;
      }

      developer.log(
          'DEBUG CHANGE PASSWORD: Mengirim POST request ke ${ApiConfig.ubahPasswordPengaturanAkunUrl}',
          name: 'PengaturanAkun');
      developer.log('DEBUG CHANGE PASSWORD: Dengan token: $token',
          name: 'PengaturanAkun');
      developer.log(
          'DEBUG CHANGE PASSWORD: Body: ${jsonEncode({
                'currentPassword': currentPassword,
                'newPassword': newPassword
              })}',
          name: 'PengaturanAkun');

      final response = await http.post(
        ApiConfig.ubahPasswordPengaturanAkunUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      developer.log(
          'DEBUG CHANGE PASSWORD: Response Status Code: ${response.statusCode}',
          name: 'PengaturanAkun');
      developer.log(
          'DEBUG CHANGE PASSWORD: Response Body (RAW): "${response.body}"',
          name: 'PengaturanAkun');

      if (response.body.isEmpty) {
        _showSnackBar('Response kosong dari server saat ubah password');
        return;
      }

      Map<String, dynamic> data;
      try {
        data = jsonDecode(response.body);
      } catch (e) {
        developer.log(
            'ERROR CHANGE PASSWORD: Gagal mendekode JSON. Body respons tidak valid: "${response.body}"',
            name: 'PengaturanAkun',
            error: e);
        _showSnackBar(
            'Terjadi kesalahan format data dari server saat ubah password. (Cek log)');
        return;
      }

      if (response.statusCode == 200 && data['status'] == 'success') {
        _showSnackBar(data['message'] ?? 'Password berhasil diubah');
        _newPasswordController.clear();
        _currentPasswordController.clear();
      } else {
        _showSnackBar(data['message'] ?? 'Gagal mengubah password');
      }
    } catch (e) {
      developer.log('ERROR CHANGE PASSWORD: Exception umum: $e',
          name: 'PengaturanAkun', error: e);
      _showSnackBar('Terjadi kesalahan: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Removed _deleteAccount method as delete account section is removed

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _currentPasswordController.dispose();
    // Removed _deleteConfirmController.dispose()
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Akun'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Email",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(_email, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              const Text("Kata Sandi",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                  "*Masukkan kata sandi anda saat ini untuk membuat kata sandi baru",
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 10),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Kata sandi baru",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Kata sandi saat ini",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                // Wrap with SizedBox to make the button full width
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _changePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Simpan Perubahan",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
