import 'package:flutter/material.dart';
import 'package:project_akhir_donasi_android/login.dart';

class IntroSplashScreen extends StatefulWidget {
  const IntroSplashScreen({super.key});

  @override
  State<IntroSplashScreen> createState() => _IntroSplashScreenState();
}

class _IntroSplashScreenState extends State<IntroSplashScreen> {
  PageController _controller = PageController();
  int currentIndex = 0;

  List<Map<String, String>> splashData = [
    {
      "title": "Peduli Sesama",
      "desc":
          "JTIcare hadir untuk bantu warga JTI yang sedang dalam kesulitan.",
      "image": "assets/splash1.png", // Ganti dengan gambar sesuai desain
    },
    {
      "title": "Donasi Aman & Mudah",
      "desc": "Salurkan donasimu dengan transparan dan cepat melalui aplikasi.",
      "image": "assets/splash2.png",
    },
    {
      "title": "Dampak Nyata",
      "desc":
          "Setiap donasi membawa harapan baru bagi mereka yang membutuhkan.",
      "image": "assets/splash3.png",
    },
  ];

  void nextPage() {
    if (currentIndex < splashData.length - 1) {
      _controller.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (index) => setState(() => currentIndex = index),
              itemCount: splashData.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        ),
                        child: Text(currentIndex == splashData.length - 1
                            ? "Selesai"
                            : "Lewati"),
                      ),
                    ),
                    Image.asset(splashData[index]["image"]!, height: 250),
                    SizedBox(height: 30),
                    Text(
                      splashData[index]["title"]!,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Text(
                      splashData[index]["desc"]!,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              splashData.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: currentIndex == index ? 12 : 8,
                height: currentIndex == index ? 12 : 8,
                decoration: BoxDecoration(
                  color: currentIndex == index ? Colors.blue : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: Text(currentIndex == splashData.length - 1
                ? "Selesai"
                : "Selanjutnya"),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
