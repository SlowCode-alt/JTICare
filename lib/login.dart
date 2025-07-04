import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project_akhir_donasi_android/dashboard/dashboard.dart';
import 'package:project_akhir_donasi_android/register.dart';
import 'package:project_akhir_donasi_android/screen/forgot_password_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_akhir_donasi_android/API/api_config.dart'; // Impor ApiService
import 'package:http/http.dart' as http;
import '../utils/TokenManager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  Future<void> _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (_formKey.currentState!.validate()) {
      try {
        Uri loginUrl = ApiConfig.buildUrl("login");

        final response = await http.post(
          loginUrl,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        );

        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200 &&
            responseData['message'] == 'Login berhasil' &&
            responseData['user'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', responseData['token']);
          await prefs.setInt('user_id', responseData['user']['id']);
          await prefs.setString('email', responseData['user']['email']);
          await prefs.setString(
              'fullname', responseData['user']['nama_lengkap']);
          await prefs.setString(
              'whatsapp', responseData['user']['no_whatsapp'] ?? '');
          await prefs.setString(
              'foto_profil', responseData['user']['foto_profil'] ?? '');

          await TokenManager.saveToken(responseData['token']); // pakai await

          // Optional: Clear fields
          _emailController.clear();
          _passwordController.clear();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login gagal: ${responseData['message']}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
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
                    const Text("Login",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    buildTextField(
                        "Email", "Masukkan Email Anda", _emailController),
                    const SizedBox(height: 15),
                    buildPasswordField("Kata Sandi", "Masukkan Kata Sandi Anda",
                        _passwordController),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text("Belum punya akun? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RegisterScreen()));
                              },
                              child: const Text("Daftar",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordScreen()));
                          },
                          child: const Text("Lupa Kata Sandi?",
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
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _login, // Update to call the _login function
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("Masuk",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
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
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget buildPasswordField(
      String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            suffixIcon: IconButton(
              icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "$label tidak boleh kosong";
            }
            return null;
          },
        ),
      ],
    );
  }
}
