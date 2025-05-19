import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project_akhir_donasi_android/dashboard/profil/edit_profile/edit_profil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_akhir_donasi_android/login.dart';
import 'package:project_akhir_donasi_android/dashboard/profil/edit_profile/faq.dart';
import 'package:project_akhir_donasi_android/dashboard/profil/edit_profile/pengaturanakun.dart';
import 'package:project_akhir_donasi_android/dashboard/profil/edit_profile/tentangkami.dart';
import 'package:project_akhir_donasi_android/dashboard/profil/edit_profile/hubungikami.dart';
import 'package:project_akhir_donasi_android/api/api_config.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String fullname = '';
  String email = '';
  String imageUrl = '';
  bool isLoading = true;
  final String baseImageUrl = ApiConfig.imageBaseUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedImage = prefs.getString('foto_profil') ?? '';

    String finalImageUrl = '';
    if (storedImage.isNotEmpty) {
      if (storedImage.startsWith('http') || storedImage.startsWith('https')) {
        finalImageUrl = storedImage;
      } else if (storedImage.startsWith('file://')) {
        finalImageUrl = storedImage;
      } else {
        finalImageUrl = baseImageUrl + storedImage;
      }
    }

    if (!mounted) return;
    setState(() {
      fullname = prefs.getString('fullname') ?? 'Nama Pengguna';
      email = prefs.getString('email') ?? 'email@example.com';
      imageUrl = finalImageUrl;
      isLoading = false;
    });
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> confirmLogout(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // batal
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true), // setuju logout
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (result == true) {
      await logout(context);
    }
  }

  ImageProvider _getProfileImage() {
    if (imageUrl.startsWith('file://')) {
      return FileImage(File(imageUrl.replaceFirst('file://', '')));
    } else if (imageUrl.isNotEmpty) {
      return NetworkImage(imageUrl);
    } else {
      return const AssetImage('assets/profile_dummy.webp');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildProfileContent(),
    );
  }

  Widget _buildProfileContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(74, 171, 251, 1),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: _getProfileImage(),
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fullname,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(email,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Column(
              children: [
                _buildMenuItem(Icons.person, "Edit Profil", () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfileScreen()),
                  );
                  _loadUserData();
                }),
                const Divider(),
                _buildMenuItem(Icons.settings, "Pengaturan Akun", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PengaturanAkunPage()),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text("Lainnya", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Column(
              children: [
                _buildMenuItem(Icons.help_outline, "FAQ", () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const FAQPage()));
                }),
                const Divider(),
                _buildMenuItem(Icons.info_outline, "Tentang Kami", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TentangKamiPage()),
                  );
                }),
                const Divider(),
                _buildMenuItem(Icons.phone, "Hubungi Kami", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HubungiKamiPage()),
                  );
                }),
                const Divider(),
                _buildMenuItem(Icons.logout, "Logout", () {
                  confirmLogout(context); // tombol logout pakai konfirmasi
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
