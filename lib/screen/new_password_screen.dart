import 'package:flutter/material.dart';
import 'package:project_akhir_donasi_android/widget/password_field.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Bagian atas (logo dan teks)
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/jticarebiru.png', height: 100),
                  const SizedBox(height: 20),
                  const Text("Kata Sandi Baru",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text("Masukkan Kata Sandi Baru",
                      textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  PasswordField(
                      controller: _passwordController,
                      label: "Kata Sandi Baru"),
                  const SizedBox(height: 10),
                  PasswordField(
                      controller: _confirmPasswordController,
                      label: "Konfirmasi Kata Sandi"),
                  const SizedBox(height: 5),
                  const Text(
                      "Kata Sandi harus berisi 6 karakter dengan huruf dan angka!",
                      style: TextStyle(fontSize: 12, color: Colors.black)),
                ],
              ),
            ),
          ),

          // Tombol di bawah
          Padding(
            padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue, // Warna tombol
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3), // Shadow
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_passwordController.text ==
                        _confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Kata sandi berhasil diubah")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Kata sandi tidak cocok")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.transparent, // Agar mengikuti Container
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    "Ubah Kata Sandi",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
