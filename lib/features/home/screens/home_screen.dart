import 'package:flutter/material.dart';
import 'package:job_connect/core/models/account.dart';
import 'package:job_connect/features/auth/controllers/user_account_model.dart';
import 'package:job_connect/features/search/screens/search_screen.dart';
import 'package:job_connect/features/chat/screens/chat_screen.dart';
import 'package:job_connect/features/profile/screens/profile_screen.dart';
// import 'package:job_connect/views/cv/cv_management.dart';
import 'package:job_connect/features/referral/screens/referral_rewards_page.dart';
import 'package:job_connect/features/help/screens/help_screen.dart';
import 'package:job_connect/features/resume/screens/cv_analysis_screen.dart';
import 'package:job_connect/features/job/screens/job_suggestions_screen.dart';
import 'package:job_connect/features/job/screens/job_history_screen.dart';
import 'package:job_connect/features/settings/screens/notification_screen.dart';
import 'package:job_connect/features/settings/screens/settings_screen.dart';
import 'package:job_connect/features/home/screens/nearby_jobs_map_screen.dart';
import 'package:job_connect/features/chat/screens/ai_chat_screen.dart';
import 'package:job_connect/features/resume/screens/cv_options_screen.dart';
import 'package:job_connect/features/auth/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:ui';

class HomeScreen extends StatefulWidget {
  final bool isLoggedIn;
  final Account? userAccount;
  const HomeScreen({super.key, this.isLoggedIn = false, this.userAccount});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Danh sách các danh mục công việc
  final List<Map<String, dynamic>> _categories = [
    {'label': 'CNTT', 'icon': Icons.computer, 'color': Colors.blue},
    {'label': 'Kế toán', 'icon': Icons.account_balance, 'color': Colors.green},
    {'label': 'Marketing', 'icon': Icons.campaign, 'color': Colors.orange},
    {'label': 'Giáo dục', 'icon': Icons.school, 'color': Colors.purple},
    {'label': 'Y tế', 'icon': Icons.local_hospital, 'color': Colors.red},
    {'label': 'Xây dựng', 'icon': Icons.engineering, 'color': Colors.teal},
    {'label': 'Luật', 'icon': Icons.gavel, 'color': Colors.indigo},
    {'label': 'Khác', 'icon': Icons.more_horiz, 'color': Colors.grey},
  ];

  // ignore: unused_field
  bool _isLoading = false;

  // Hiển thị dialog danh sách công việc theo danh mục
  void _showJobsByCategoryDialog(BuildContext context, String categoryLabel) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Danh mục: $categoryLabel'),
            content: const Text(
              'Hiển thị danh sách công việc cho danh mục này.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Đóng'),
              ),
            ],
          ),
    );
  }

  // ignore: unused_field
  bool _isRefreshing = false;
  final ScrollController _scrollController = ScrollController();

  // Slideshow Properties
  int _currentBannerIndex = 0;
  final PageController _bannerController = PageController();
  Timer? _bannerTimer;

  // Danh sách các mục trong slideshow
  final List<Map<String, dynamic>> _bannerItems = [
    {
      'image': 'assets/images/logohuit.png',
      'color': Colors.blue.shade700,
      'title': 'Tìm kiếm công việc mơ ước',
      'description': 'Khám phá hàng ngàn cơ hội việc làm mới nhất',
    },
    {
      'image': 'assets/images/logohuit.png',
      'color': Colors.green.shade700,
      'title': 'Ứng tuyển dễ dàng',
      'description': 'Ứng tuyển chỉ với vài thao tác đơn giản',
    },
    {
      'image': 'assets/images/logohuit.png',
      'color': Colors.orange.shade700,
      'title': 'Xây dựng CV nổi bật',
      'description': 'Tạo CV chuyên nghiệp để thu hút nhà tuyển dụng',
    },
    {
      'image': 'assets/images/logohuit.png',
      'color': Colors.purple.shade700,
      'title': 'Kết nối doanh nghiệp',
      'description': 'Liên hệ trực tiếp với các công ty hàng đầu',
    },
  ];

  // Lấy trạng thái đăng nhập từ widget cha
  bool get isLoggedIn => widget.isLoggedIn;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    // Đảm bảo timer được khởi động sau khi widget đã được xây dựng
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startBannerTimer();
    });
  }

  void _startBannerTimer() {
    // Hủy timer hiện tại nếu có
    _bannerTimer?.cancel();

    // Tạo timer mới
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_currentBannerIndex < _bannerItems.length - 1) {
        _currentBannerIndex++;
      } else {
        _currentBannerIndex = 0;
      }

      if (_bannerController.hasClients) {
        _bannerController.animateToPage(
          _currentBannerIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _logout(BuildContext context) async {
    bool? confirmLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: _buildLogoutDialog(context),
        );
      },
    );

    if (confirmLogout == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  Widget _buildLogoutDialog(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Color(0xFF1565C0),
                    size: 36,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Xác nhận đăng xuất',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text(
                  'Bạn có chắc chắn muốn đăng xuất khỏi tài khoản hiện tại?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF666666),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF666666),
                          side: const BorderSide(color: Color(0xFFDDDDDD)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'HỦY',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'ĐĂNG XUẤT',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
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

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    // Giả lập tải dữ liệu
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Giả lập tải lại dữ liệu
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  // Hiển thị dialog tìm kiếm
  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Tìm kiếm'),
            content: TextField(
              decoration: InputDecoration(
                hintText: 'Nhập từ khóa tìm kiếm...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF1E88E5)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  // ignore: deprecated_member_use
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                ),
              ),
              autofocus: true,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Xử lý tìm kiếm
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Tìm kiếm'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      drawer: _buildDrawer(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Kiểm tra đăng nhập trước khi cho phép sử dụng AI Chat
          if (!isLoggedIn) {
            _showLoginRequiredDialog();
            return;
          }

          // Nếu đã đăng nhập, mở AI Chat
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AIChatScreen()),
          );
        },
        backgroundColor: const Color(0xFF1E88E5),
        icon: const Icon(Icons.smart_toy, color: Colors.white),
        label: const Text(
          "AI Chat",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 4,
      ),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        toolbarHeight: 70,
        leadingWidth: 60,
        leading: Builder(
          builder:
              (context) => Padding(
                padding: const EdgeInsets.only(left: 16),
                child: IconButton(
                  icon: const Icon(
                    Icons.menu_rounded,
                    color: Color(0xFF1E88E5),
                    size: 28,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
        ),
        title: const Text(
          "Huitworks",
          style: TextStyle(
            color: Color(0xFF1E88E5),
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: Color(0xFF1E88E5),
                      size: 26,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationScreen(),
                      ),
                    );
                  },
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.red.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: const Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    // ignore: deprecated_member_use
                    color: const Color(0xFF1E88E5).withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: CircleAvatar(
                  radius: 16,
                  // ignore: deprecated_member_use
                  backgroundColor: const Color(0xFF1E88E5).withOpacity(0.1),
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFF1E88E5),
                    size: 20,
                  ),
                ),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header với gradient
              Container(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.grey.withOpacity(0.05),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Phần chào mừng và nút tìm kiếm
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getGreeting(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "Tìm việc mơ ước của bạn",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333333),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            // ignore: deprecated_member_use
                            color: const Color(0xFF1E88E5).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.search,
                              color: Color(0xFF1E88E5),
                              size: 26,
                            ),
                            tooltip: 'Tìm kiếm',
                            onPressed: () {
                              try {
                                HomePage.goToSearchTab();
                              } catch (e) {
                                _showSearchDialog(context);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Slideshow Banner
                    _buildBannerSlideshow(),
                  ],
                ),
              ),

              // Phần nội dung còn lại
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Danh mục công việc
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Danh mục",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Xem tất cả",
                            style: TextStyle(
                              color: Color(0xFF1E88E5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Danh mục công việc được cải tiến
                    SizedBox(
                      height: 110,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(_categories.length, (index) {
                          final category = _categories[index];
                          return GestureDetector(
                            onTap: () {
                              _showJobsByCategoryDialog(
                                context,
                                category['label'],
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOutCubic,
                              margin: EdgeInsets.only(
                                right: index == _categories.length - 1 ? 0 : 16,
                              ),
                              child: _buildCategoryCard(
                                category['label'],
                                category['icon'],
                                category['color'],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Nút khám phá việc làm gần bạn
                    GestureDetector(
                      onTap: () {
                        // Điều hướng đến màn hình bản đồ việc làm
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NearbyJobsMapScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: const Color(0xFF1E88E5).withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Khám phá việc làm gần bạn",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Công ty nổi bật
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Công ty nổi bật",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Xem tất cả",
                            style: TextStyle(
                              color: Color(0xFF1E88E5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Danh sách công ty nổi bật
                    // SizedBox(
                    //   height: 200,
                    //   child: ListView(
                    //     scrollDirection: Axis.horizontal,
                    //     children: [
                    //       _buildCompanyCard(
                    //         "Ngân Hàng TMCP Á Châu",
                    //         "ACB",
                    //         Colors.blue,
                    //       ),
                    //       _buildCompanyCard(
                    //         "Công Ty Cổ Phần HTC Viễn Thông",
                    //         "HITC",
                    //         Colors.orange,
                    //       ),
                    //       _buildCompanyCard(
                    //         "Tập Đoàn Sun Group",
                    //         "SUN",
                    //         Colors.amber,
                    //       ),
                    //       _buildCompanyCard(
                    //         "FPT Software",
                    //         "FPT",
                    //         Colors.green,
                    //       ),
                    //       _buildCompanyCard("Viettel Group", "VTL", Colors.red),
                    //     ],
                    //   ),
                    // ),

                    // Danh sách công ty nổi bật
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _fetchFeaturedCompanies(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                            height: 200,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (snapshot.hasError) {
                          return SizedBox(
                            height: 60,
                            child: Center(
                              child: Text('Lỗi tải dữ liệu công ty'),
                            ),
                          );
                        }
                        final companies = snapshot.data ?? [];
                        if (companies.isEmpty) {
                          return SizedBox(
                            height: 60,
                            child: Center(
                              child: Text('Không có công ty nổi bật'),
                            ),
                          );
                        }
                        return SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: companies.length,
                            itemBuilder: (context, index) {
                              final company = companies[index];
                              return _buildCompanyCard(
                                company['name'] ?? '',
                                company['logo'] ?? '',
                                _parseColor(company['color']),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 25),

                    // Công việc nổi bật
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Việc làm nổi bật",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Xem tất cả",
                            style: TextStyle(
                              color: Color(0xFF1E88E5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Danh sách công việc nổi bật từ Firestore
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _fetchFeaturedJobsFromFirestore(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                            height: 180,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (snapshot.hasError) {
                          return SizedBox(
                            height: 60,
                            child: Center(
                              child: Text('Lỗi tải dữ liệu việc làm'),
                            ),
                          );
                        }
                        final jobs = snapshot.data ?? [];
                        if (jobs.isEmpty) {
                          return SizedBox(
                            height: 60,
                            child: Center(
                              child: Text('Không có việc làm nổi bật'),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: jobs.length,
                          itemBuilder: (context, index) {
                            final job = jobs[index];
                            return _buildJobCard(
                              job['title'] ?? '',
                              job['company'] ?? '',
                              job['location'] ?? '',
                              job['salary'] ?? '',
                              _parseColor(job['color']),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Huitworks Podcast",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Xem tất cả",
                            style: TextStyle(
                              color: Color(0xFF1E88E5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return _buildPodcastCard(
                          index == 0
                              ? "AI tạo sinh: Giải pháp thay thế đào tạo nhân sự"
                              : index == 1
                              ? "Trí tuệ nhân tạo (AI) hỗ trợ người lao động tối ưu"
                              : index == 2
                              ? "Trí tuệ nhân tạo (AI) đang thay đổi cách chúng ta"
                              : "Chia khóa thăng tiến trong sự nghiệp (Phần 3)",
                          index == 0
                              ? "08 tháng 07, 2024"
                              : index == 1
                              ? "29 tháng 05, 2024"
                              : index == 2
                              ? "13 tháng 05, 2024"
                              : "15 tháng 12, 2023",
                          index == 0
                              ? "00:10:15"
                              : index == 1
                              ? "00:10:42"
                              : index == 2
                              ? "00:11:04"
                              : "00:15:53",
                        );
                      },
                    ),

                    // Section: Kinh nghiệm thành công
                    Container(
                      margin: const EdgeInsets.only(top: 24, bottom: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Phần tiêu đề "Cùng chia sẻ - Cùng vươn xa"
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xFF1565C0),
                                  Color(0xFF1976D2),
                                  Color(0xFF42A5F5),
                                ],
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  // ignore: deprecated_member_use
                                  color: Colors.blue.withOpacity(0.2),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          // ignore: deprecated_member_use
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.send,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Cùng chia sẻ - Cùng vươn xa",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                letterSpacing: 0.5,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 3),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(
                                                    2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                      0xFF4CAF50,
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.workspace_premium,
                                                    color: Colors.white,
                                                    size: 8,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                const Text(
                                                  "Kinh nghiệm thành công",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 28,
                                  decoration: BoxDecoration(
                                    // ignore: deprecated_member_use
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      // Xử lý khi nhấn "Xem tất cả"
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 0,
                                      ),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      textStyle: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    child: const Text("Xem tất cả"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Card content area with light blue-green background
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFFE1F5FE), // Xanh dương rất nhạt
                                  Color(0xFFF5F5F5), // Trắng nhạt
                                ],
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  // ignore: deprecated_member_use
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                SizedBox(
                                  height: 280,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    children: [
                                      _buildExperienceCard(
                                        imageUrl: "assets/images/logohuit.png",
                                        title:
                                            "Ikigai - Thấu hiểu bản thân, tiếp lợi thế cho hành trình sự nghiệp",
                                        description:
                                            "Ikigai - một mô hình bắt nguồn từ đất nước Nhật Bản từ hơn 1.000 năm trước",
                                      ),
                                      _buildExperienceCard(
                                        imageUrl: "assets/images/logohuit.png",
                                        title:
                                            "Bạn đã sẵn sàng cho sự nghiệp phát triển?",
                                        description:
                                            "Chúng tôi giúp bạn định hướng và phát triển sự nghiệp",
                                      ),
                                      _buildExperienceCard(
                                        imageUrl: "assets/images/logohuit.png",
                                        title: "Lộ trình phát triển sự nghiệp",
                                        description:
                                            "Phương pháp và công cụ giúp bạn đạt được mục tiêu",
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerSlideshow() {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _bannerController,
            itemCount: _bannerItems.length,
            onPageChanged: (index) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
            itemBuilder: (context, index) {
              Map<String, dynamic> banner = _bannerItems[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [banner['color'], banner['color'].withOpacity(0.8)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Hiệu ứng hình học trang trí
                    Positioned(
                      top: -20,
                      right: -20,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // ignore: deprecated_member_use
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -40,
                      left: -20,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // ignore: deprecated_member_use
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),

                    // Nội dung banner
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  banner['title'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  banner['description'],
                                  style: TextStyle(
                                    // ignore: deprecated_member_use
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  height: 36,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: banner['color'],
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                    child: const Text(
                                      "Khám phá ngay",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                // ignore: deprecated_member_use
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                index == 0
                                    ? Icons.search
                                    : index == 1
                                    ? Icons.work_outline
                                    : index == 2
                                    ? Icons.description
                                    : Icons.business,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        // Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_bannerItems.length, (index) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    _currentBannerIndex == index
                        ? const Color(0xFF1E88E5)
                        // ignore: deprecated_member_use
                        : Colors.grey.withOpacity(0.3),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF1E88E5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Text(
                    "HUIT",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.userAccount?.userName ?? "Người dùng",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.userAccount?.email ?? "Email chưa cung cấp",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          _buildDrawerItem(context, Icons.home, "Trang chủ", isSelected: true),
          _buildDrawerItem(context, Icons.group_add, "Đề xuất ứng viên"),
          _buildDrawerItem(context, Icons.analytics, "Phân tích CV"),
          _buildDrawerItem(context, Icons.bookmark, "Công việc đã lưu"),
          _buildDrawerItem(context, Icons.history, "Lịch sử ứng tuyển"),
          _buildDrawerItem(
            context,
            Icons.work_outline,
            'Gợi ý công việc',
            isJobSuggestion: true,
          ),
          const Divider(),
          _buildDrawerItem(context, Icons.settings, "Cài đặt"),
          _buildDrawerItem(context, Icons.help_outline, "Trợ giúp & Hỗ trợ"),
          _buildDrawerItem(context, Icons.logout, "Đăng xuất"),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title, {
    bool isSelected = false,
    bool isJobSuggestion = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
      title: Text(
        title,
        style: TextStyle(color: isSelected ? Colors.blue : Colors.black),
      ),
      selected: isSelected,
      onTap: () {
        Navigator.pop(context); // Đóng drawer trước khi chuyển trang
        // if (isJobSuggestion) {
        //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const JobSuggestionsPage()));
        // } else {
        switch (title) {
          case "Trang chủ":
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case "Đề xuất ứng viên":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReferralHomePage()),
            );
            break;
          case "Phân tích CV":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CVAnalysisPage()),
            );
            break;
          case "Công việc đã lưu":
            //Navigator.(context, '/saved_jobs');
            break;
          case "Lịch sử ứng tuyển":
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const JobHistoryScreen(),
                fullscreenDialog: false,
              ),
            );
            break;
          case "Gợi ý công việc":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const JobSuggestionsPage(),
              ),
            );
            break;
          case "Cài đặt":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingScreen()),
            );
            break;
          case "Trợ giúp & Hỗ trợ":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HelpScreen()),
            );
            break;
          case "Đăng xuất":
            _logout(context);
            break;
        }
      },
      // },
    );
  }

  Widget _buildCategoryCard(String label, IconData icon, Color color) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(
    String title,
    String company,
    String location,
    String salary,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        // ignore: deprecated_member_use
        side: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo công ty
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  company.substring(0, 1),
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Thông tin công việc
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    company,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              location,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.attach_money,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              salary,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Bookmark button
            IconButton(
              icon: const Icon(Icons.bookmark_border, color: Colors.grey),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyCard(String companyName, String logo, Color color) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // ignore: deprecated_member_use
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          SizedBox(
            height: 60,
            width: 60,
            child: Image.asset(
              'assets/images/logohuit.png',
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        logo,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              companyName,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              "Việc mới",
              style: TextStyle(
                color: Color(0xFF1E88E5),
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPodcastCard(String title, String date, String duration) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Thumbnail podcast
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xFFE1F5FE),
              ),
              child: Center(
                child: Icon(
                  Icons.podcasts,
                  color: Colors.green.shade700,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Thông tin podcast
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        duration,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const Icon(
                        Icons.play_circle_filled,
                        color: Color(0xFF26A69A),
                        size: 32,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Like button
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Icon(
                Icons.favorite_border,
                color: Colors.green.shade500,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fetch featured companies (dummy implementation, replace with Firestore or API as needed)
  Future<List<Map<String, dynamic>>> _fetchFeaturedCompanies() async {
    // Return dummy data
    return [
      {
        'name': 'Ngân Hàng TMCP Á Châu',
        'logo': 'ACB',
        'color': Colors.blue.value,
      },
      {
        'name': 'Công Ty Cổ Phần HTC Viễn Thông',
        'logo': 'HITC',
        'color': Colors.orange.value,
      },
      {
        'name': 'Tập Đoàn Sun Group',
        'logo': 'SUN',
        'color': Colors.amber.value,
      },
      {'name': 'FPT Software', 'logo': 'FPT', 'color': Colors.green.value},
      {'name': 'Viettel Group', 'logo': 'VTL', 'color': Colors.red.value},
    ];
  }

  // Dummy implementation for fetching featured jobs from Firestore or API
  Future<List<Map<String, dynamic>>> _fetchFeaturedJobsFromFirestore() async {
    // Return dummy data
    return [
      {
        'title': 'Lập trình viên Flutter',
        'company': 'FPT Software',
        'location': 'Hà Nội',
        'salary': '20-30 triệu',
        'color': Colors.green.value,
      },
      {
        'title': 'Chuyên viên Marketing',
        'company': 'Viettel Group',
        'location': 'Hồ Chí Minh',
        'salary': '15-25 triệu',
        'color': Colors.red.value,
      },
      {
        'title': 'Kế toán tổng hợp',
        'company': 'ACB',
        'location': 'Đà Nẵng',
        'salary': '12-18 triệu',
        'color': Colors.blue.value,
      },
    ];
  }

  // Helper to parse color from hex string or int
  Color _parseColor(dynamic colorValue) {
    if (colorValue is int) {
      return Color(colorValue);
    }
    if (colorValue is String) {
      String value = colorValue.replaceAll('#', '');
      if (value.length == 6) {
        value = 'FF$value'; // add alpha if missing
      }
      return Color(int.parse(value, radix: 16));
    }
    // fallback color
    return Colors.blue;
  }

  // Phương thức trả về lời chào tùy theo thời gian trong ngày
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Chào buổi sáng,";
    } else if (hour < 17) {
      return "Chào buổi chiều,";
    } else {
      return "Chào buổi tối,";
    }
  }

  // Hiển thị dialog yêu cầu đăng nhập
  void _showLoginRequiredDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) => Container(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );

        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
          child: FadeTransition(
            opacity: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(curvedAnimation),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 10,
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header with gradient
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF1E88E5), Color(0xFF0D47A1)],
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Icon with animation
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 500),
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: child,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    // ignore: deprecated_member_use
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.lock_outline,
                                color: Color(0xFF1976D2),
                                size: 36,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Yêu cầu đăng nhập',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Content
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: Column(
                        children: [
                          const Text(
                            'Để truy cập tính năng này, bạn cần đăng nhập vào tài khoản Huitworks của mình.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF666666),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Login button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1976D2),
                                foregroundColor: Colors.white,
                                elevation: 2,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.login, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'ĐĂNG NHẬP NGAY',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Cancel button
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF666666),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'ĐỂ SAU',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget để hiển thị card kinh nghiệm
  Widget _buildExperienceCard({
    required String imageUrl,
    required String title,
    required String description,
  }) {
    return Container(
      width: 280,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          // ignore: deprecated_member_use
          color: const Color(0xFF1976D2).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with gradient overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Image.asset(
                  imageUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Gradient overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        // ignore: deprecated_member_use
                        const Color(0xFF1565C0).withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ),
              // Hot tag (trên góc trái)
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1976D2),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.star, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        "HOT",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Title and description
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.remove_red_eye_outlined,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "1.2k lượt xem",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: const Color(0xFF1976D2).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Xem chi tiết",
                        style: TextStyle(
                          color: Color(0xFF1976D2),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

class HomePage extends StatefulWidget {
  final bool isLoggedIn;
  final Account? userAccount;
  const HomePage({super.key, this.isLoggedIn = false, this.userAccount});

  // GlobalKey để truy cập trực tiếp đến state
  // ignore: library_private_types_in_public_api
  static final GlobalKey<_HomePageState> homeKey = GlobalKey<_HomePageState>();

  // Cập nhật phương thức tĩnh để chuyển đến tab tìm kiếm trực tiếp
  static void goToSearchTab() {
    // Kiểm tra state và page controller
    if (homeKey.currentState != null &&
        homeKey.currentState!._pageController.hasClients) {
      final state = homeKey.currentState!;
      // Kiểm tra đăng nhập trước khi chuyển tab
      if (!state.isLoggedIn && 1 != 0 && 1 != 4) {
        // Index 1 là Search
        state._showLoginRequiredDialog();
        return;
      }
      state._pageController.jumpToPage(1); // Index 1 là SearchPage
      // Cập nhật lại currentIndex để UI đồng bộ
      // ignore: invalid_use_of_protected_member
      state.setState(() {
        state._currentIndex = 1;
      });
    } else {
      // print(
      //   "Error: Cannot navigate to search tab. State or PageController not available.",
      // );
      // Có thể thêm fallback ở đây nếu cần, ví dụ hiển thị dialog tìm kiếm
    }
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  // Lấy trạng thái đăng nhập từ widget cha
  bool get isLoggedIn => widget.isLoggedIn;

  // Danh sách các màn hình
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    // Khởi tạo danh sách màn hình ở đây để có thể sử dụng isLoggedIn
    _screens = [
      HomeScreen(
        key: const PageStorageKey('HomeScreen'),
        isLoggedIn: isLoggedIn,
        userAccount: widget.userAccount,
      ),
      const SearchPage(key: PageStorageKey('SearchPage')),
      const CVOptionsScreen(key: PageStorageKey('CVOptionsScreen')),
      const MessagesPage(key: PageStorageKey('MessagesPage')),
      ProfilePage(
        key: const PageStorageKey('ProfilePage'),
        isLoggedIn: isLoggedIn,
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    // Kiểm tra đăng nhập
    if (!isLoggedIn && ![0, 4].contains(index)) {
      // Cho phép index 0 (Home) và 4 (Profile)
      _showLoginRequiredDialog();
      return;
    }

    // Chỉ chuyển trang nếu index hợp lệ (0-4)
    if (index >= 0 && index < _screens.length) {
      setState(() {
        _currentIndex = index;
      });
      _pageController.jumpToPage(index);
    } else {
      // print("Invalid index: $index"); // Log lỗi nếu index không hợp lệ
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
        onPageChanged: (index) {
          // Cập nhật lại _currentIndex khi vuốt trang (nếu cần)
          // Hiện tại physics là NeverScrollableScrollPhysics nên không cần thiết
          // setState(() {
          //   _currentIndex = index;
          // });
        },
      ),
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              spreadRadius: 0,
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  0,
                  Icons.home_outlined,
                  Icons.home_rounded,
                  'Home',
                ),
                _buildNavItem(
                  1,
                  Icons.search_outlined,
                  Icons.search_rounded,
                  'Search',
                ),
                _buildNavItem(
                  2,
                  Icons.description_outlined,
                  Icons.description_rounded,
                  'CV',
                  isSpecial: true,
                ),
                _buildNavItem(
                  3,
                  Icons.chat_bubble_outline_rounded,
                  Icons.chat_bubble_rounded,
                  'Chat',
                ),
                _buildNavItem(
                  4,
                  Icons.person_outline_rounded,
                  Icons.person_rounded,
                  'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData iconOutlined,
    IconData iconFilled,
    String label, {
    bool isSpecial = false,
  }) {
    final isSelected = _currentIndex == index;

    // Xử lý đặc biệt cho tab CV
    if (isSpecial) {
      return InkWell(
        onTap: () => _onTabTapped(index),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          width: 60,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3A7BD5), Color(0xFF00D2FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3A7BD5).withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    isSelected ? iconFilled : iconOutlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 56,
                child: Text(
                  _getShortLabel(label),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color:
                        isSelected
                            ? const Color(0xFF3A7BD5)
                            : Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Cho các tab thông thường
    return InkWell(
      onTap: () => _onTabTapped(index),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? _getColorForIndex(index).withOpacity(0.15)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: _getColorForIndex(index).withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                        : null,
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (
                    Widget child,
                    Animation<double> animation,
                  ) {
                    return ScaleTransition(
                      scale: CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutBack,
                      ),
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: Icon(
                    isSelected ? iconFilled : iconOutlined,
                    key: ValueKey<bool>(isSelected),
                    color:
                        isSelected
                            ? _getColorForIndex(index)
                            : Colors.grey.shade600,
                    size: isSelected ? 22 : 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 56,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color:
                      isSelected
                          ? _getColorForIndex(index)
                          : Colors.grey.shade600,
                ),
                child: Text(
                  _getShortLabel(label),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForIndex(int index) {
    // Màu sắc khác nhau cho từng tab
    switch (index) {
      case 0:
        return const Color(0xFF1E88E5); // Xanh dương cho Home
      case 1:
        return const Color(0xFF26A69A); // Xanh lục cho Search
      case 2:
        return const Color(0xFF3A7BD5); // Xanh dương sáng cho CV
      case 3:
        return const Color(0xFF7E57C2); // Tím cho Chat
      case 4:
        return const Color(0xFF5C6BC0); // Chàm cho Profile
      default:
        return const Color(0xFF1E88E5);
    }
  }

  // Giữ nguyên hàm rút gọn label
  String _getShortLabel(String label) {
    if (label.length > 8) {
      return label.substring(0, 7) + '...';
    }
    return label;
  }

  // Hiển thị dialog yêu cầu đăng nhập
  void _showLoginRequiredDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) => Container(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );

        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
          child: FadeTransition(
            opacity: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(curvedAnimation),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 10,
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header with gradient
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF1E88E5), Color(0xFF0D47A1)],
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Icon with animation
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 500),
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: child,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    // ignore: deprecated_member_use
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.lock_outline,
                                color: Color(0xFF1976D2),
                                size: 36,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Yêu cầu đăng nhập',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Content
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: Column(
                        children: [
                          const Text(
                            'Để truy cập tính năng này, bạn cần đăng nhập vào tài khoản Huitworks của mình.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF666666),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Login button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1976D2),
                                foregroundColor: Colors.white,
                                elevation: 2,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.login, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'ĐĂNG NHẬP NGAY',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Cancel button
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF666666),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'ĐỂ SAU',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
