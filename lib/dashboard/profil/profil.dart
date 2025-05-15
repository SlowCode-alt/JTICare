import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../login.dart'; // Ensure the path is correct
import 'edit_profil.dart'; // Import EditProfilePage
import 'pengaturan_akun.dart';
import '../../utils/TokenManager.dart';  // Import TokenManager

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _fullName = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  // Load profile data from SharedPreferences
  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName = prefs.getString('fullname') ?? 'Nama Tidak Ditemukan';
      _email = prefs.getString('email') ?? 'Email Tidak Ditemukan';
    });
  }

  // Logout and remove token
  Future<void> _logout(BuildContext context) async {
    // Remove token using TokenManager
    await TokenManager.removeToken();

    // Clear SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Navigate to Login Screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false, // Remove all routes
    );
  }

  // Show confirmation dialog for logout
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Logout"),
        content: const Text("Apakah Anda yakin ingin keluar?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Cancel
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _logout(context); // Logout on confirm
            },
            child: const Text("Keluar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 40), // Padding to give space at the top

              // Profile Section
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue, // Blue background for profile section
                  borderRadius: BorderRadius.circular(30), // Smooth border radius
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: CircleAvatar(
                            radius: 45,
                            backgroundImage: AssetImage(
                                'assets/profile_picture.png'), // Change with real profile picture
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _fullName,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              _email,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Menu Box with Drop Shadow
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 4), // Shadow position
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildMenuBox(Icons.edit, "Edit Profil", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditProfilePage()),
                      );
                    }),
                    _buildMenuBox(Icons.settings, "Pengaturan Akun", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PengaturanAkunPage()),
                      );
                    }),
                    const Text(
                      "Lainnya",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    _buildMenuBox(Icons.question_answer, "FAQ", () {}),
                    _buildMenuBox(Icons.info_outline, "Tentang Kami", () {}),
                    _buildMenuBox(Icons.phone, "Hubungi Kami", () {}),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: InkWell(
                  onTap: () => _showLogoutConfirmation(context), // Call confirmation
                  child: Row(
                    children: const [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 10),
                      Text(
                        "Keluar",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuBox(IconData icon, String title, Function() onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
