import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_akhir_donasi_android/API/api_config.dart';

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
      if (!storedImage.startsWith('http') &&
          !storedImage.startsWith('file://')) {
        _imageUrl = ApiConfig.imageBaseUrl + storedImage;
      } else {
        _imageUrl = storedImage;
      }
    }

    setState(() => isLoading = false);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _imageUrl = 'file://${pickedFile.path}';
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
      var request = http.MultipartRequest('POST', ApiConfig.updateProfileUrl);
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['nama_lengkap'] = _nameController.text;
      request.fields['email'] = _emailController.text;
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

      if (response.statusCode == 200) {
        final respData = jsonDecode(respStr);
        final userData = respData['data'];

        await prefs.setString('fullname', userData['nama_lengkap'] ?? '');
        await prefs.setString('email', userData['email'] ?? '');
        await prefs.setString('whatsapp', userData['no_whatsapp'] ?? '');

        String? serverImage = userData['foto_profil'];
        if (serverImage != null && serverImage.isNotEmpty) {
          String fullUrl = serverImage.startsWith('http')
              ? serverImage
              : ApiConfig.imageBaseUrl + serverImage;

          // Tambah timestamp biar cache browser/Flutter tidak stuck
          fullUrl += '?v=${DateTime.now().millisecondsSinceEpoch}';

          await prefs.setString('foto_profil', fullUrl);
          setState(() {
            _imageUrl = fullUrl;
            _selectedImage = null;
          });
        }

        _showMessage('Perubahan berhasil disimpan');
        if (mounted) Navigator.pop(context, true);
      } else {
        _showMessage('Gagal menyimpan perubahan', isError: true);
      }
    } catch (e) {
      _showMessage('Terjadi kesalahan: $e', isError: true);
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
        : (_imageUrl != null
            ? (_imageUrl!.startsWith('file://')
                ? FileImage(File(_imageUrl!.replaceFirst('file://', '')))
                : NetworkImage(_imageUrl!)) as ImageProvider
            : const AssetImage('assets/profile_dummy.webp'));

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(radius: 50, backgroundImage: profileImage),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.blue),
                          child:
                              const Icon(Icons.camera_alt, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
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
          readOnly: readOnly,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: readOnly,
            fillColor: readOnly ? Colors.grey.shade200 : null,
          ),
        ),
      ],
    );
  }
}
