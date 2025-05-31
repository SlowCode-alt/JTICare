import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project_akhir_donasi_android/dashboard/profil/edit_profile/edit_profil.dart';
import 'package:project_akhir_donasi_android/dashboard/profil/faq.dart';
import 'package:project_akhir_donasi_android/dashboard/profil/hubungikami.dart';
import 'package:project_akhir_donasi_android/dashboard/profil/pengaturanakun.dart';
import 'package:project_akhir_donasi_android/dashboard/profil/tentangkami.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_akhir_donasi_android/login.dart';
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
    final storedFullname = prefs.getString('fullname') ?? 'Nama Pengguna';
    final storedEmail = prefs.getString('email') ?? 'email@example.com';
    final storedImage = prefs.getString('foto_profil') ?? '';

    String finalImageUrl = '';
    if (storedImage.isNotEmpty) {
      if (storedImage.startsWith('http')) {
        // Pastikan tidak ada query sebelumnya
        final uri = Uri.parse(storedImage);
        final cleanedUrl = uri.replace(queryParameters: {}).toString();
        finalImageUrl =
            '$cleanedUrl?v=${DateTime.now().millisecondsSinceEpoch}';
      } else if (storedImage.startsWith('file://')) {
        finalImageUrl = storedImage;
      } else {
        finalImageUrl =
            '$baseImageUrl$storedImage?v=${DateTime.now().millisecondsSinceEpoch}';
      }
    }

    if (!mounted) return;
    setState(() {
      fullname = storedFullname;
      email = storedEmail;
      imageUrl = finalImageUrl; // Update the imageUrl state variable
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
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
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
              color: const Color.fromARGB(255, 74, 171, 251),
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
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () async {
                    // Tunggu hasil dari halaman edit profil
                    final result = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditProfileScreen()),
                    );

                    // Jika ada perubahan (result is true), reload data profil
                    if (result == true && mounted) {
                      setState(() =>
                          isLoading = true); // Show loading while reloading
                      await _loadUserData();
                    }
                  },
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text("Pengaturan Akun"),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PengaturanAkunPage()),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text("FAQ"),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FAQPage()),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: const Text("Hubungi Kami"),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HubungiKamiPage()),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text("Tentang Kami"),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TentangKamiPage()),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Logout"),
                  onTap: () => confirmLogout(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
