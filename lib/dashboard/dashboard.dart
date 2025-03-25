import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Center(child: Text("Beranda")),
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
      appBar: AppBar(
        title: Text("Dashboard"),
        backgroundColor: Colors.blue,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/home.png', width: 24, height: 24),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/bell.png', width: 24, height: 24),
            label: "Notifikasi",
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/give.png', width: 24, height: 24),
            label: "Donasi",
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/profile.png', width: 24, height: 24),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}
