import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_akhir_donasi_android/API/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();

  File? _selectedImage;
  String? _imageUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    _nameController.text = prefs.getString('fullname') ?? '';
    _emailController.text = prefs.getString('email') ?? '';
    _whatsappController.text = prefs.getString('whatsapp') ?? '';

    String? storedImage = prefs.getString('foto_profil');
    if (storedImage != null && storedImage.isNotEmpty) {
      if (!storedImage.startsWith('http')) {
        _imageUrl = ApiConfig.imageBaseUrl + storedImage;
      } else {
        _imageUrl = storedImage;
      }
    } else {
      _imageUrl = null;
    }

    setState(() => isLoading = false);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_nameController.text.trim().length < 5) {
      _showMessage('Nama lengkap minimal 5 karakter', isError: true);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      _showMessage('Token tidak ditemukan, silakan login ulang', isError: true);
      return;
    }

    try {
      var uri = ApiConfig.updateProfileUrl;
      var request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['nama_lengkap'] = _nameController.text;
      request.fields['no_whatsapp'] = _whatsappController.text;

      if (_selectedImage != null) {
        var imageFile = await http.MultipartFile.fromPath(
          'foto_profil',
          _selectedImage!.path,
          filename: path.basename(_selectedImage!.path),
        );
        request.files.add(imageFile);
      }

      var response = await request.send();
      final respStr = await response.stream.bytesToString();

      print('Status Code: ${response.statusCode}');
      print('Response: $respStr');

      if (response.statusCode == 200) {
        final respData = jsonDecode(respStr);
        final userData = respData['user'];

        // Ambil foto profil dari response, tambahkan baseUrl jika perlu
        String? serverImage = userData['foto_profil'];
        if (serverImage != null && serverImage.isNotEmpty) {
          if (!serverImage.startsWith('http')) {
            serverImage = ApiConfig.imageBaseUrl + serverImage;
          }
        }

        await prefs.setString('fullname', _nameController.text);
        await prefs.setString('whatsapp', _whatsappController.text);
        if (serverImage != null) {
          await prefs.setString('foto_profil', serverImage);
          _imageUrl = serverImage;
        }

        _showMessage('Perubahan berhasil disimpan');
        if (mounted) Navigator.pop(context);
      } else {
        _showMessage('Gagal menyimpan perubahan', isError: true);
      }
    } catch (e) {
      print('Error saat mengirim request: $e');
      _showMessage('Terjadi kesalahan, coba lagi nanti', isError: true);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileImage = _selectedImage != null
        ? FileImage(_selectedImage!)
        : (_imageUrl != null && _imageUrl!.isNotEmpty
            ? NetworkImage(_imageUrl!)
            : const AssetImage('assets/profile_dummy.webp')) as ImageProvider;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: profileImage,
                      ),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          child: const Icon(Icons.camera_alt,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(_nameController.text,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(_emailController.text,
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 24),
                  _buildInputField('Nama Lengkap', _nameController),
                  const SizedBox(height: 16),
                  _buildInputField('Email', _emailController, readOnly: true),
                  const SizedBox(height: 16),
                  _buildInputField('Nomor WhatsApp', _whatsappController,
                      keyboardType: TextInputType.phone),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: _saveChanges,
                    icon: const Icon(Icons.save),
                    label: const Text('Simpan Perubahan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            filled: readOnly,
            fillColor: readOnly ? Colors.grey.shade200 : null,
          ),
        ),
      ],
    );
  }
}
