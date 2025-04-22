import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    SingleChildScrollView(
      child: Stack(
        children: [
          // Background biru
          Container(
            height: 190,
            decoration: BoxDecoration(
              color: Colors.lightBlue[500],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            padding: EdgeInsets.only(top: 50, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 8),
                      Text("Cari", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Text("Hai, Saiful!",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          // Rectangle putih yang menumpuk
          Positioned(
            top: 140,
            left: 24,
            right: 24,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
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
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Rp 0",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text("Total Donasimu", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Isi konten di bawah
          Padding(
            padding: EdgeInsets.only(top: 230),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Mari Berbagi Kebaikan",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                // Tambahin list donasi di sini
                SizedBox(height: 300), // untuk memberi ruang scroll dulu
              ],
            ),
          ),
        ],
      ),
    ),
    Center(child: Text("Notifikasi")),
    Center(child: Text("Donasi")),
    Center(child: Text("Profil")),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
