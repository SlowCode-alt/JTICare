import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_akhir_donasi_android/API/api_config.dart';

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

  void _kirimPesan() async {
    if (_formKey.currentState!.validate()) {
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

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pesan berhasil dikirim')),
          );
          _emailController.clear();
          _namaController.clear();
          _pesanController.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal mengirim pesan')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
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
                  ElevatedButton(
                    onPressed: _kirimPesan,
                    child: const Text('Kirim'),
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
