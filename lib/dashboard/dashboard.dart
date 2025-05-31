import 'package:flutter/material.dart';
import 'package:project_akhir_donasi_android/API/api_config.dart';
import 'package:project_akhir_donasi_android/dashboard/profil/profil.dart';
import 'package:project_akhir_donasi_android/dashboard/donasi_saya/donasisaya.dart';
import '../models/donasi_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart'; // Untuk format mata uang
import 'package:shared_preferences/shared_preferences.dart'; // Untuk mendapatkan token
import 'donasi_detail.dart';

class DashboardScreen extends StatefulWidget {
  // `refresh` flag bisa digunakan untuk memicu pembaruan dari luar jika diperlukan
  final bool refresh;

  const DashboardScreen({super.key, this.refresh = false});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  List<Donasi> donasiList = [];
  bool isLoading = true; // Status loading untuk daftar donasi
  String errorMessage = '';

  // Variabel untuk data total donasi di dashboard
  String _totalDonasiDashboard = "Rp 0"; // Nilai default

  @override
  void initState() {
    super.initState();
    // Memuat data donasi dan total donasi saat initState
    _fetchKategoriDonasi();
    _loadUserTotalDonation();
  }

  // Metode ini dipanggil ketika widget diperbarui (misalnya, setelah kembali dari DonasiDetailPage)
  @override
  void didUpdateWidget(covariant DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Jika widget.refresh berubah dari false ke true, maka refresh data
    if (widget.refresh && !oldWidget.refresh) {
      _fetchKategoriDonasi();
      _loadUserTotalDonation();
    }
  }

  // Fungsi untuk mengambil daftar kategori donasi
  Future<void> _fetchKategoriDonasi() async {
    // Pastikan widget masih mounted sebelum setState pertama
    if (!mounted) return;
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final url = ApiConfig.buildUrl('kategori-donasi');
      final response = await http.get(url);

      // Pastikan widget masih mounted sebelum setState berikutnya
      if (!mounted) return;

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['data'] != null) {
          final List<dynamic> donasiData = responseData['data'];
          donasiList = donasiData.map((json) => Donasi.fromJson(json)).toList();
          errorMessage = '';
        } else {
          donasiList = [];
          errorMessage = 'Data donasi tidak ditemukan.';
        }
      } else {
        donasiList = [];
        errorMessage = 'Gagal memuat data donasi: ${response.statusCode}';
      }
    } catch (e) {
      // Pastikan widget masih mounted sebelum setState di catch
      if (!mounted) return;
      donasiList = [];
      errorMessage = 'Terjadi kesalahan saat memuat data donasi: $e';
      print('Error _fetchKategoriDonasi: $e'); // Untuk debugging
    } finally {
      // Pastikan widget masih mounted sebelum setState di finally
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadUserTotalDonation() async {
    // Pastikan widget masih mounted sebelum setState pertama
    if (!mounted) return;

    try {
      final url = ApiConfig.buildUrl('total-donasi');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        if (!mounted) return; // Penting: cek mounted sebelum setState
        setState(() {
          _totalDonasiDashboard = "Rp 0";
        });
        print('User not logged in, no auth token found for total donation.');
        return;
      }

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Pastikan widget masih mounted sebelum setState berikutnya
      if (!mounted) return;

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          final double totalDonasi =
              (responseData['total_donasi'] as num).toDouble();
          setState(() {
            final currencyFormatter = NumberFormat.currency(
              locale: 'id_ID',
              symbol: 'Rp ',
              decimalDigits: 0,
            );
            _totalDonasiDashboard = currencyFormatter.format(totalDonasi);
          });
        } else {
          setState(() {
            _totalDonasiDashboard = "Rp 0";
          });
          print(
              'Error fetching total donasi from API: ${responseData['message']}');
        }
      } else if (response.statusCode == 404) {
        setState(() {
          _totalDonasiDashboard = "Rp 0";
        });
        print('Total donasi API returned 404: No donation data yet.');
      } else if (response.statusCode == 401) {
        setState(() {
          _totalDonasiDashboard = "Rp 0";
        });
        print(
            'Unauthorized access to total donasi API: Status code ${response.statusCode}');
      } else {
        setState(() {
          _totalDonasiDashboard = "Rp 0";
        });
        print(
            'Failed to load total donasi. Status code: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return; // Penting: cek mounted sebelum setState di catch
      setState(() {
        _totalDonasiDashboard = "Rp 0";
      });
      print('Exception when loading total donasi: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Membangun layar yang sesuai berdasarkan _selectedIndex
  Widget _buildCurrentScreen() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeScreen();
      case 1:
        return const DonasiSayaPage();
      case 2:
        return const Center(child: Text("Notifikasi"));
      case 3:
        return const ProfileScreen();
      default:
        return _buildHomeScreen();
    }
  }

  // Membangun tampilan beranda (home screen)
  Widget _buildHomeScreen() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            // Digunakan untuk menumpuk header dan kartu "Total Donasimu"
            children: [
              // Latar belakang header biru
              Container(
                height: 190,
                decoration: BoxDecoration(
                  color: Colors.lightBlue[500],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
                child: const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Selamat Datang",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Kartu "Total Donasimu" yang responsif
              Positioned(
                bottom: 12,
                left: 16,
                right: 16,
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                    children: [
                      Image.asset(
                          'assets/ic_donasi.png', // Ikon kotak biru dengan koin
                          width: 40,
                          height: 40),
                      const SizedBox(width: 12), // Jarak antara ikon dan teks
                      Expanded(
                        // Teks mengambil sisa ruang
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _totalDonasiDashboard, // Menggunakan data dari state
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Text(
                              "Total Donasimu", // Teks label
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Konten di bawah kartu, diberi padding agar tidak tumpang tindih
          Padding(
            padding: const EdgeInsets.only(
                top: 20), // Jarak setelah kartu tumpang tindih
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Mari Berbagi Kebaikan",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                // Conditional rendering untuk loading, error, atau data kosong
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (errorMessage.isNotEmpty)
                  Center(child: Text(errorMessage))
                else if (donasiList.isEmpty)
                  const Center(child: Text("Tidak ada data donasi tersedia."))
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GridView.builder(
                      // Non-scrollable untuk mencegah konflik dengan SingleChildScrollView
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true, // Mengambil ruang seminimal mungkin
                      itemCount: donasiList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 kolom
                        crossAxisSpacing: 8, // Jarak antar kolom
                        mainAxisSpacing: 8, // Jarak antar baris
                        childAspectRatio: 0.68, // Rasio lebar/tinggi item
                      ),
                      itemBuilder: (context, index) {
                        final donasi = donasiList[index];

                        // Hitung persentase donasi terkumpul
                        int persen = 0;
                        if (donasi.targetDana != 0) {
                          double tempPersen =
                              (donasi.donasiTerkumpul / donasi.targetDana) *
                                  100;
                          persen = tempPersen.toInt();
                          if (persen > 100) persen = 100;
                          if (persen < 0) persen = 0;
                        }

                        return GestureDetector(
                          onTap: () async {
                            // Saat berpindah ke DonasiDetailPage, tunggu hingga kembali
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DonasiDetailPage(donasi: donasi),
                              ),
                            );
                            // Setelah kembali dari detail page, refresh data donasi dan total donasi
                            _fetchKategoriDonasi();
                            _loadUserTotalDonation();
                          },
                          child: DonasiCard(
                            id: donasi.id.toString(),
                            gambar: donasi.gambar,
                            tanggal: donasi.tanggalBuat,
                            judul: donasi.judulDonasi,
                            deskripsi: donasi.deskripsi,
                            terkumpul: donasi.donasiTerkumpul
                                .toStringAsFixed(0), // Pastikan ini string
                            target: donasi.targetDana
                                .toStringAsFixed(0), // Pastikan ini string
                            persen: persen,
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildCurrentScreen(), // Menampilkan layar yang aktif
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 0 ? 'assets/home_warna.png' : 'assets/home.png',
              width: 30,
              height: 30,
            ),
            label: "", // Label kosong agar ikon saja yang muncul
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 1 ? 'assets/give_warna.png' : 'assets/give.png',
              width: 30,
              height: 30,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 2 ? 'assets/bell_warna.png' : 'assets/bell.png',
              width: 30,
              height: 30,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 3
                  ? 'assets/profile_warna.png'
                  : 'assets/profile.png',
              width: 30,
              height: 30,
            ),
            label: "",
          ),
        ],
      ),
    );
  }
}

// Widget DonasiCard tetap sama, dengan penambahan format mata uang
class DonasiCard extends StatelessWidget {
  final String id;
  final String gambar;
  final String tanggal;
  final String judul;
  final String deskripsi;
  final String terkumpul; // Ubah ke String agar mudah diformat
  final String target; // Ubah ke String agar mudah diformat
  final int persen;

  const DonasiCard({
    super.key,
    required this.id,
    required this.gambar,
    required this.tanggal,
    required this.judul,
    required this.deskripsi,
    required this.terkumpul,
    required this.target,
    required this.persen,
  });

  @override
  Widget build(BuildContext context) {
    // Formatter untuk mata uang Rupiah
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp', // Simbol tanpa spasi di sini agar lebih compact
      decimalDigits: 0,
    );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: CachedNetworkImage(
              imageUrl: gambar,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                height: 120,
                color: Colors.grey[300],
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red),
                      SizedBox(height: 4),
                      Text('Gagal memuat gambar',
                          style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tanggal,
                    style: const TextStyle(fontSize: 10, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(judul,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(deskripsi,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: persen / 100,
                  backgroundColor: Colors.grey[200],
                  color: Colors.blue,
                  minHeight: 6,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$persen%', style: const TextStyle(fontSize: 10)),
                    Text(
                      // Memformat terkumpul dan target
                      '${currencyFormatter.format(double.parse(terkumpul))} / ${currencyFormatter.format(double.parse(target))}',
                      style: const TextStyle(fontSize: 10),
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
