import 'package:flutter/material.dart';
import 'package:project_akhir_donasi_android/API/donatur_service.dart';
import 'package:project_akhir_donasi_android/API/donasi_service.dart'; // Import DonasiService
import 'package:project_akhir_donasi_android/models/donasisaya_model.dart';
import 'package:project_akhir_donasi_android/models/donasi_model.dart'; // Import Donasi model
import 'package:project_akhir_donasi_android/dashboard/donasi_detail.dart';

class DonasiSayaPage extends StatefulWidget {
  const DonasiSayaPage({super.key});

  @override
  State<DonasiSayaPage> createState() => _DonasiSayaPageState();
}

class _DonasiSayaPageState extends State<DonasiSayaPage> {
  List<DonasiSaya> donasiList = [];
  double totalDonasi = 0;
  int jumlahDonasi = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDonasi();
  }

  Future<void> fetchDonasi() async {
    final service = DonaturService();
    final result = await service.getDataDonatur();

    if (result['status'] == true) {
      setState(() {
        donasiList = (result['data'] as List)
            .map((json) => DonasiSaya.fromJson(json))
            .toList();
        
        final successDonations = donasiList.where((d) => d.status == 'success').toList();
        
        totalDonasi = successDonations.fold(0, (sum, item) => sum + item.nominal);
        jumlahDonasi = successDonations.length;
        
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Gagal mengambil data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          DonasiSayaHeader(
            totalDonasi: totalDonasi,
            jumlahDonasi: jumlahDonasi,
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : donasiList.isEmpty
                    ? const Center(
                        child: Text(
                          'Anda belum melakukan donasi.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : jumlahDonasi == 0
                        ? const Center(
                            child: Text(
                              'Tidak ada donasi yang berhasil',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: donasiList.length,
                            itemBuilder: (context, index) {
                              final donasi = donasiList[index];
                              return DonasiItemCard(donasi: donasi);
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

class DonasiSayaHeader extends StatelessWidget {
  final double totalDonasi;
  final int jumlahDonasi;

  const DonasiSayaHeader({
    super.key,
    required this.totalDonasi,
    required this.jumlahDonasi,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      decoration: const BoxDecoration(
        color: Colors.lightBlue,
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
              borderRadius: BorderRadius.circular(20),
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
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rp ${totalDonasi.toStringAsFixed(0)}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Total Donasi",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      jumlahDonasi.toString(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Kali Donasi",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
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

class DonasiItemCard extends StatelessWidget {
  final DonasiSaya donasi;

  const DonasiItemCard({super.key, required this.donasi});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'https://jticare.my.id/storage/${donasi.gambarDonasi}',
              width: 80,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 60),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  donasi.tanggalTransaksi,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  donasi.kategoriDonasi,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp ${donasi.nominal.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                donasi.status,
                style: TextStyle(
                  fontSize: 12,
                  color:
                      donasi.status == 'success' ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  final donasiService = DonasiService();
                  try {
                    // Mengambil detail kampanye donasi lengkap berdasarkan kategoriDonasiId
                    final Donasi fullDonasi = await donasiService
                        .getDonasiById(donasi.kategoriDonasiId);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DonasiDetailPage(
                            donasi:
                                fullDonasi), // Menggunakan objek Donasi lengkap
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Gagal memuat detail kampanye: $e')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue.shade100,
                  foregroundColor: Colors.blue,
                  minimumSize: const Size(80, 30),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Donasi Lagi',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
