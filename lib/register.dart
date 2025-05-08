import 'package:flutter/material.dart';
import 'package:project_akhir_donasi_android/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project_akhir_donasi_android/API/api_config.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset('assets/jticarebiru.png', height: 100),
            ),
          ),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text("Registrasi",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    buildTextField("Nama Lengkap", "Masukkan Nama Lengkap Anda",
                        _nameController),
                    const SizedBox(height: 15),
                    buildTextField(
                        "Email", "Masukkan Email Anda", _emailController),
                    const SizedBox(height: 15),
                    buildTextField("Nomor WhatsApp",
                        "Masukkan Nomor WhatsApp Anda", _phoneController),
                    const SizedBox(height: 15),
                    buildPasswordField("Kata Sandi", "Masukkan Kata Sandi Anda",
                        _passwordController, _obscurePassword, () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    }),
                    const SizedBox(height: 15),
                    buildPasswordField(
                        "Konfirmasi Kata Sandi",
                        "Ulangi Kata Sandi Anda",
                        _confirmPasswordController,
                        _obscureConfirmPassword, () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    }),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Sudah punya akun? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          },
                          child: const Text("Masuk",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final Uri url = ApiConfig.buildUrl("register");
                      print(url); // Debugging URL
                      final response = await http.post(
                        url,
                        headers: {
                          'Accept': 'application/json',
                          'Content-Type': 'application/json',
                        },
                        body: json.encode({
                          "nama_lengkap": _nameController.text,
                          "email": _emailController.text,
                          "password": _passwordController.text,
                          "confirm": _confirmPasswordController.text,
                          "no_whatsapp": _phoneController.text,
                        }),
                      );

                      final result = json.decode(response.body);

                      if (response.statusCode == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result["message"])),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      } else {
                        String message =
                            result['message'] ?? 'Registrasi gagal';
                        if (result is Map && result.containsKey('errors')) {
                          final errors =
                              result['errors'] as Map<String, dynamic>;
                          message = errors.values.first[0];
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(message)),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    "Daftar",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(
      String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: label == "Nomor WhatsApp"
              ? TextInputType.phone
              : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "$label tidak boleh kosong";
            } else if (label == "Email" &&
                !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return "Format email tidak valid";
            } else if (label == "Nomor WhatsApp" &&
                !RegExp(r'^(?:\+62|08)[0-9]{8,13}$').hasMatch(value)) {
              return "Format nomor WhatsApp tidak valid";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget buildPasswordField(
    String label,
    String hint,
    TextEditingController controller,
    bool obscureText,
    VoidCallback toggle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            suffixIcon: IconButton(
              icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey),
              onPressed: toggle,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "$label tidak boleh kosong";
            } else if (label == "Kata Sandi" && value.length < 6) {
              return "Kata sandi minimal 6 karakter";
            } else if (label == "Konfirmasi Kata Sandi" &&
                value != _passwordController.text) {
              return "Kata sandi tidak cocok";
            }
            return null;
          },
        ),
      ],
    );
  }
}
