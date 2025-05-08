import 'package:flutter/material.dart';

class DonasiSayaPage extends StatelessWidget {
  const DonasiSayaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          DonasiSayaHeader(),
          Expanded(
            child: DonasiSayaList(),
          ),
        ],
      ),
    );
  }
}

class DonasiSayaHeader extends StatelessWidget {
  const DonasiSayaHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190, // Sama seperti dashboard
      decoration: const BoxDecoration(
        color: Color(0xFF4EB7F2), // Biru muda
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Donasi Saya',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20), // Sama seperti dashboard
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Rp 1.000",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text("Total Donasi",
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("1",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text("Kali Donasi",
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DonasiSayaList extends StatelessWidget {
  const DonasiSayaList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> donasiList = [
      {
        'judul': 'Banjir Kutai',
        'tanggal': '03 Maret 2025',
        'jumlah': 'Rp 1.000',
        'status': 'Terkonfirmasi',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: donasiList.length,
      itemBuilder: (context, index) {
        final item = donasiList[index];
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const Icon(Icons.favorite, color: Colors.blue),
            title: Text(item['judul'] ?? ''),
            subtitle: Text(item['tanggal'] ?? ''),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(item['jumlah'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(item['status'] ?? '',
                    style: const TextStyle(fontSize: 12, color: Colors.green)),
              ],
            ),
          ),
        );
      },
    );
  }
}
