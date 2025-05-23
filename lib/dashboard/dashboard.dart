import 'package:flutter/material.dart';
import 'package:project_akhir_donasi_android/API/api_config.dart';
import 'package:project_akhir_donasi_android/dashboard/profil/profil.dart';
import 'package:project_akhir_donasi_android/dashboard/donasi_saya/donasisaya.dart';
import '../models/donasi_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'donasi_detail.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  List<Donasi> donasiList = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchKategoriDonasi();
  }

  Future<void> _fetchKategoriDonasi() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final url = ApiConfig.buildUrl('kategori-donasi');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['data'] != null) {
          final List<dynamic> donasiData = responseData['data'];
          donasiList = donasiData.map((json) => Donasi.fromJson(json)).toList();
          errorMessage = '';
        } else {
          donasiList = [];
          errorMessage = 'Data tidak ditemukan';
        }
      } else {
        donasiList = [];
        errorMessage = 'Gagal memuat data: ${response.statusCode}';
      }
    } catch (e) {
      donasiList = [];
      errorMessage = 'Gagal memuat data: $e';
    }

    setState(() {
      isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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

  Widget _buildHomeScreen() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            height: 190,
            decoration: BoxDecoration(
              color: Colors.lightBlue[500],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 8),
                      Text("Cari", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Hai, Saiful!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 140,
            left: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
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
                  Image.asset('assets/ic_donasi.png', width: 40, height: 40),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Rp 0",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          "Total Donasimu",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 230),
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
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (errorMessage.isNotEmpty)
                  Center(child: Text(errorMessage))
                else if (donasiList.isEmpty)
                  const Center(child: Text("Tidak ada data donasi tersedia"))
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: donasiList.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.68,
                      ),
                      itemBuilder: (context, index) {
                        final donasi = donasiList[index];
                        
                        int persen = 0;
                        if (donasi.targetDana != 0) {
                          double tempPersen = (donasi.donasiTerkumpul / donasi.targetDana) * 100;
                          persen = tempPersen.toInt();
                          if (persen > 100) persen = 100;
                          if (persen < 0) persen = 0;
                        }

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DonasiDetailPage(donasi: donasi),
                              ),
                            );
                          },
                          child: DonasiCard(
                            id: donasi.id.toString(),
                            gambar: donasi.gambar,
                            tanggal: donasi.tanggalBuat,
                            judul: donasi.judulDonasi,
                            deskripsi: donasi.deskripsi,
                            terkumpul: donasi.donasiTerkumpul.toStringAsFixed(0),
                            target: donasi.targetDana.toStringAsFixed(0),
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
      body: _buildCurrentScreen(),
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
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 1 ? 'assets/bell_warna.png' : 'assets/bell.png',
              width: 30,
              height: 30,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 2 ? 'assets/give_warna.png' : 'assets/give.png',
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

class DonasiCard extends StatelessWidget {
  final String id;
  final String gambar;
  final String tanggal;
  final String judul;
  final String deskripsi;
  final String terkumpul;
  final String target;
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
                      Text('Gagal memuat gambar', style: TextStyle(fontSize: 10)),
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
                    Text('Rp$terkumpul / Rp$target',
                        style: const TextStyle(fontSize: 10)),
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