import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:job_connect/features/home/screens/home_screen.dart';
import 'package:job_connect/features/auth/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<double> _fadeAnimation;

  bool _showLoginOptions = false;
  bool _showIntroduction = false;
  int _currentIntroPage = 0;

  final List<Map<String, dynamic>> _introContent = [
    {
      'title': 'Tìm kiếm công việc mơ ước',
      'subtitle':
          'Khám phá hàng ngàn cơ hội việc làm phù hợp với kỹ năng của bạn',
      'icon': Icons.search,
    },
    {
      'title': 'Kết nối với nhà tuyển dụng',
      'subtitle': 'Tương tác trực tiếp và xây dựng mạng lưới chuyên nghiệp',
      'icon': Icons.handshake,
    },
    {
      'title': 'Phát triển sự nghiệp',
      'subtitle':
          'Công cụ và nguồn lực để nâng cao kỹ năng và đạt được mục tiêu',
      'icon': Icons.trending_up,
    },
  ];

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0),
      ),
    );

    _animationController.forward();

    // Hiển thị logo trước, sau đó hiển thị phần giới thiệu
    Timer(const Duration(seconds: 2), () {
      setState(() {
        _showIntroduction = true;
      });

      // Tự động chuyển trang giới thiệu
      Timer.periodic(const Duration(seconds: 3), (timer) {
        if (_currentIntroPage < _introContent.length - 1) {
          _currentIntroPage++;
          if (_pageController.hasClients) {
            _pageController.animateToPage(
              _currentIntroPage,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        } else if (!_showLoginOptions) {
          timer.cancel();
          setState(() {
            _showLoginOptions = true;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToHome({required bool isLoggedIn}) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) =>
                HomePage(key: HomePage.homeKey, isLoggedIn: isLoggedIn),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  void _skipIntroAndShowLogin() {
    setState(() {
      _showLoginOptions = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0D47A1), // Deep blue
              const Color(0xFF1976D2), // Blue
              // ignore: deprecated_member_use
              const Color(0xFF42A5F5).withOpacity(0.9), // Light blue
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height:
                    _showIntroduction ? size.height * 0.25 : size.height * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo với hiệu ứng phóng to
                    ScaleTransition(
                      scale: _animation,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.15),
                              spreadRadius: 2,
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.asset(
                            'assets/images/logohuit.png',
                            fit: BoxFit.cover,
                            width: 120,
                            height: 120,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: const Icon(
                                  Icons.business,
                                  size: 70,
                                  color: Color(0xFF1976D2),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Tên ứng dụng với hiệu ứng làm mờ
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Column(
                        children: [
                          Text(
                            "Huitworks",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2,
                              shadows: [
                                Shadow(
                                  blurRadius: 5.0,
                                  color: Colors.black12,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Kết nối tài năng, khai phá cơ hội",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Phần giới thiệu các tính năng
              if (_showIntroduction && !_showLoginOptions)
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (int page) {
                            setState(() {
                              _currentIntroPage = page;
                            });
                          },
                          itemCount: _introContent.length,
                          itemBuilder: (context, index) {
                            return FadeTransition(
                              opacity: _fadeAnimation,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32.0,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _introContent[index]['icon'],
                                      size: 80,
                                      // ignore: deprecated_member_use
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                    const SizedBox(height: 30),
                                    Text(
                                      _introContent[index]['title'],
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      _introContent[index]['subtitle'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        // ignore: deprecated_member_use
                                        color: Colors.white.withOpacity(0.9),
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Chỉ báo trang hiện tại và nút bỏ qua
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Chỉ báo trang
                            Row(
                              children: List.generate(
                                _introContent.length,
                                (index) => Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                  ),
                                  width:
                                      _currentIntroPage == index ? 24.0 : 8.0,
                                  height: 8.0,
                                  decoration: BoxDecoration(
                                    // ignore: deprecated_member_use
                                    color:
                                        _currentIntroPage == index
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                              ),
                            ),

                            // Khoảng cách
                            const SizedBox(width: 40),

                            // Nút bỏ qua
                            TextButton(
                              onPressed: _skipIntroAndShowLogin,
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                              ),
                              child: const Text(
                                "BỎ QUA",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // Phần hiển thị các nút đăng nhập, đăng ký
              if (_showLoginOptions)
                FadeTransition(
                  opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.0, 1.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 32.0,
                    ),
                    child: Column(
                      children: [
                        // Thông điệp giới thiệu
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Text(
                            "Huitworks giúp bạn kết nối với cơ hội việc làm phù hợp và phát triển sự nghiệp trong môi trường chuyên nghiệp",
                            style: TextStyle(
                              fontSize: 16,
                              // ignore: deprecated_member_use
                              color: Colors.white.withOpacity(0.9),
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        // Nút đăng nhập
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _navigateToLogin,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color(0xFF1976D2),
                              backgroundColor: Colors.white,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: const Text(
                              "ĐĂNG NHẬP / ĐĂNG KÝ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Nút tiếp tục mà không cần đăng nhập
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () => _navigateToHome(isLoggedIn: false),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              // ignore: deprecated_member_use
                              backgroundColor: Colors.white.withOpacity(0.15),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: const Text(
                              "TIẾP TỤC MÀ KHÔNG CẦN ĐĂNG NHẬP",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Phần footer
                        Text(
                          "Phiên bản 1.0.0",
                          style: TextStyle(
                            fontSize: 12,
                            // ignore: deprecated_member_use
                            color: Colors.white.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

              // Hiển thị loading khi không có nội dung khác
              if (!_showIntroduction && !_showLoginOptions)
                const Padding(
                  padding: EdgeInsets.only(bottom: 50),
                  child: CircularProgressIndicator(color: Colors.white),
                ),
            ],
          ),
        ),
      ),
    );
  }
}