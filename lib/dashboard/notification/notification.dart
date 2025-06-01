import 'package:flutter/material.dart';
import 'package:project_akhir_donasi_android/API/api_config.dart';
import 'package:project_akhir_donasi_android/models/notifikasi_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_akhir_donasi_android/dashboard/notification/no_donations_exception.dart'; // Pastikan path ini benar

class NotifikasiScreen extends StatefulWidget {
  const NotifikasiScreen({super.key});

  @override
  _NotifikasiScreenState createState() => _NotifikasiScreenState();
}

class _NotifikasiScreenState extends State<NotifikasiScreen> {
  late Future<List<NotifikasiModel>> _notifikasiList;
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchNotifications();
  }

  Future<void> _loadTokenAndFetchNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');

    if (_token != null) {
      setState(() {
        _notifikasiList = ApiConfig.fetchNotifikasi(_token!);
      });
    } else {
      setState(() {
        // Jika token tidak ditemukan, langsung tampilkan "Data tidak ditemukan"
        _notifikasiList =
            Future.error('Token tidak ditemukan. Data tidak ditemukan.');
      });
      print('Token tidak ditemukan untuk NotifikasiScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 120,
            decoration: const BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notifikasi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Ini adalah notifikasi pembayaran donasi anda',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 254, 254),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _token == null
                ? const Center(
                    child: Text(
                        'Data tidak ditemukan', // Pesan ini jika token null
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey)))
                : FutureBuilder<List<NotifikasiModel>>(
                    future: _notifikasiList,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      // Jika ada error ATAU data kosong
                      if (snapshot.hasError ||
                          !snapshot.hasData ||
                          snapshot.data!.isEmpty) {
                        String errorMessage =
                            'Data tidak ditemukan'; // Default message
                        // Jika ada error dan itu NoDonationsFoundException, pakai pesan dari exception
                        if (snapshot.hasError &&
                            snapshot.error is NoDonationsFoundException) {
                          errorMessage =
                              (snapshot.error as NoDonationsFoundException)
                                  .message;
                        } else if (snapshot.hasError) {
                          // Untuk error lain yang bukan NoDonationsFoundException, juga tampilkan "Data tidak ditemukan"
                          errorMessage =
                              'Data tidak ditemukan'; // Atau 'Terjadi kesalahan. Data tidak ditemukan.' jika Anda ingin sedikit lebih informatif
                        }
                        return Center(
                            child: Text(errorMessage,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.grey)));
                      }

                      final data = snapshot.data!;

                      return ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final notif = data[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 6),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.blue.shade200),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  )
                                ],
                              ),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    notif.imageUrl,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.broken_image),
                                  ),
                                ),
                                title: Text(
                                  notif.message,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                subtitle: Text(
                                  notif.createdAtFormatted,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
