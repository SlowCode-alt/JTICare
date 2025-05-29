import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            "Pertanyaan yang Sering Diajukan",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ExpansionTile(
            title: Text("Bagaimana cara menggunakan aplikasi ini?"),
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    "Kamu bisa mulai dengan membuat akun, lalu login dan mulai menjelajahi fitur yang tersedia."),
              ),
            ],
          ),
          ExpansionTile(
            title: Text("Bagaimana jika saya lupa kata sandi?"),
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child:
                    Text("Gunakan fitur 'Lupa Password' pada halaman login."),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
