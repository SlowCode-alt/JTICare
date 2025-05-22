import 'package:flutter/material.dart';
import 'package:project_akhir_donasi_android/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroSplashScreen extends StatefulWidget {
  const IntroSplashScreen({super.key});

  @override
  State<IntroSplashScreen> createState() => _IntroSplashScreenState();
}

class _IntroSplashScreenState extends State<IntroSplashScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> splashData = [
    {
      "title": "Peduli Sesama",
      "desc":
          "JTIcare hadir untuk bantu warga JTI yang sedang dalam kesulitan.",
      "image": "assets/splash1.png",
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

  Future<void> _finishIntro() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('introSeen', true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (index) => setState(() => currentIndex = index),
            itemCount: splashData.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 60,
                          child: Image.asset(
                            'assets/gif/splashgif.gif',
                            width: screenWidth * 0.9,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: screenHeight * 0.1,
                          child: Image.asset(
                            splashData[index]['image']!,
                            width: screenWidth * 0.55,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: ClipPath(
                      clipper: BlueCurveClipper(),
                      child: Container(
                        width: double.infinity,
                        color: const Color(0xFF29B6F6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              splashData[index]['title']!,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              splashData[index]['desc']!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            top: 40,
            right: 20,
            child: TextButton(
              onPressed: _finishIntro,
              child: Text(
                currentIndex == splashData.length - 1 ? "Selesai" : "Lewati",
                style: const TextStyle(color: Colors.blue),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                splashData.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color:
                        currentIndex == index ? Colors.white : Colors.white54,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BlueCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0);
    path.quadraticBezierTo(size.width / 2, 50, size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
