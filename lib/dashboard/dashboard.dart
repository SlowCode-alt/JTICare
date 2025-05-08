import 'package:flutter/material.dart';
import 'package:project_akhir_donasi_android/dashboard/profil/profil.dart';
import 'package:project_akhir_donasi_android/dashboard/donasi_saya/donasisaya.dart';

class DonasiCard extends StatelessWidget {
  final String gambar;
  final String tanggal;
  final String judul;
  final String deskripsi;
  final String terkumpul;
  final String target;
  final int persen;

  const DonasiCard({
    super.key,
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
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade100),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              gambar,
              height: 90,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            tanggal,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            judul,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            deskripsi,
            style: const TextStyle(fontSize: 11, color: Colors.black87),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: persen / 100,
            backgroundColor: Colors.grey.shade300,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Terkumpul: $terkumpul",
                  style: const TextStyle(fontSize: 9),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  "Target: $target",
                  style: const TextStyle(fontSize: 9),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> donasiList = [
    {
      'gambar': 'assets/banjir.png',
      'tanggal': '03 Maret 2025',
      'judul': 'Peduli Korban Banjir Kutai',
      'deskripsi': 'Sebanyak 2.477 rumah di Kabupaten Kutai Timur (Kutim).',
      'terkumpul': 'Rp 130.000',
      'target': 'Rp 500.000',
      'persen': 70,
    },
    {
      'gambar': 'assets/kebakaran.jpg',
      'tanggal': '05 Maret 2025',
      'judul': 'Bantu Korban Kebakaran Pasar',
      'deskripsi': 'Kebakaran hebat melanda pasar tradisional di Jember.',
      'terkumpul': 'Rp 200.000',
      'target': 'Rp 1.000.000',
      'persen': 20,
    },
    {
      'gambar': 'assets/gempa.jpg',
      'tanggal': '06 Maret 2025',
      'judul': 'Peduli Gempa Cianjur',
      'deskripsi': 'Ratusan rumah rusak akibat gempa magnitudo 5.6.',
      'terkumpul': 'Rp 750.000',
      'target': 'Rp 1.000.000',
      'persen': 75,
    },
    {
      'gambar': 'assets/panti.jpg',
      'tanggal': '07 Maret 2025',
      'judul': 'Santunan Anak Yatim',
      'deskripsi': 'Bantu kebutuhan sehari-hari anak-anak yatim.',
      'terkumpul': 'Rp 300.000',
      'target': 'Rp 600.000',
      'persen': 50,
    },
  ];

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      _buildHomeScreen(),
      const DonasiSayaPage(),
      const Center(child: Text("Notifikasi")),
      // const ProfilePage(), // Ganti dari Text("Profil") ke halaman ProfilePage
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: donasiList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.68,
                    ),
                    itemBuilder: (context, index) {
                      final donasi = donasiList[index];
                      return DonasiCard(
                        gambar: donasi['gambar'],
                        tanggal: donasi['tanggal'],
                        judul: donasi['judul'],
                        deskripsi: donasi['deskripsi'],
                        terkumpul: donasi['terkumpul'],
                        target: donasi['target'],
                        persen: donasi['persen'],
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
      body: _screens[_selectedIndex],
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
