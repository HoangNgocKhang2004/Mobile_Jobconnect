import 'package:flutter/material.dart';
import 'package:job_connect/core/models/account.dart';
import 'package:job_connect/features/auth/controllers/user_account_model.dart';
import 'package:job_connect/features/candidate/screens/top_candidates_screen.dart';
import 'package:job_connect/features/search/screens/hr_search_screen.dart';
import 'package:job_connect/features/post/screens/post_job_screen.dart';
import 'package:job_connect/features/chat/screens/hr_chat_screen.dart';
import 'package:job_connect/features/profile/screens/hr_profile_screen.dart';
import 'package:flutter/services.dart';
import 'package:job_connect/features/recruiter/screens/candidate_list_screen.dart';
import 'package:job_connect/features/settings/screens/notification_screen.dart';
import 'package:job_connect/features/settings/screens/settings_screen.dart';
import 'package:job_connect/features/help/screens/help_screen.dart';
import 'package:job_connect/features/chat/screens/ai_chat_screen.dart';
import 'package:job_connect/features/job/screens/job_list_screen.dart';
import 'package:job_connect/features/auth/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

class HRHomeScreen extends StatefulWidget {
  final Account userAccount;
  const HRHomeScreen({super.key, required this.userAccount});

  @override
  State<HRHomeScreen> createState() => _HRHomeScreenState();
}

class _HRHomeScreenState extends State<HRHomeScreen> {
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
                colors: [Color(0xFF3366FF), Color(0xFF5E91F2)],
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
                    color: Color(0xFF3366FF),
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
                          backgroundColor: const Color(0xFF3366FF),
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
  Widget build(BuildContext context) {
    // Thiết lập theme chung
    final primaryColor = Color(0xFF3366FF);
    final backgroundColor = Color(0xFFF7F9FC);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          centerTitle: false,
          title: Text(
            'HR Dashboard',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black87,
            ),
          ),
          actions: [
            IconButton(
              icon: Badge(
                label: Text('3'),
                child: Icon(
                  Icons.notifications_outlined,
                  color: Colors.black54,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationScreen()),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CircleAvatar(
                backgroundColor: primaryColor,
                child: Text('NK', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
        drawer: _buildDrawer(context, primaryColor),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              // Thực hiện các tác vụ khi refresh như tải lại dữ liệu
              // Phải trả về một Future để cho biết khi nào refresh hoàn tất
              await Future.delayed(
                Duration(seconds: 1),
              ); // Giả lập tải dữ liệu trong 2 giây
              // Đặt code để tải lại dữ liệu tại đây
            },
            child: SingleChildScrollView(
              physics:
                  const AlwaysScrollableScrollPhysics(), // Đảm bảo có thể scroll ngay cả khi nội dung ngắn
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeSection(),
                    SizedBox(height: 24),
                    _buildStatisticsSection(primaryColor),
                    SizedBox(height: 24),
                    _buildRecentActivitiesSection(context),
                    SizedBox(height: 24),
                    _buildUpcomingSection(context),
                    // Khoảng cách dưới cùng
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: primaryColor,
          icon: const Icon(Icons.smart_toy, color: Colors.white),
          label: const Text(
            "AI Chat",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 4,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AIChatScreen()),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, Color primaryColor) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryColor, Color(0xFF5E91F2)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  // ignore: deprecated_member_use
                  backgroundColor: Colors.white.withOpacity(0.9),
                  child: Icon(Icons.person, size: 40, color: primaryColor),
                ),
                SizedBox(height: 10),
                Text(
                  widget.userAccount.userName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.userAccount.email,
                  style: TextStyle(
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.dashboard_outlined, 'Dashboard'),
          _buildDrawerItem(
            Icons.people_outline,
            'Quản lý ứng viên',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CandidateListPage(),
                ),
              );
            },
          ),

          _buildDrawerItem(
            Icons.work_outline,
            'Danh sách công việc',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const JobListScreen()),
              );
            },
          ),

          _buildDrawerItem(
            Icons.star_border,
            'Danh sách ứng viên nổi bật',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CandidateListScreen(),
                ),
              );
            },
          ),

          _buildDrawerItem(Icons.topic_outlined, 'Báo cáo'),
          _buildDrawerItem(Icons.calendar_today_outlined, 'Lịch phỏng vấn'),
          Divider(),
          _buildDrawerItem(
            Icons.settings_outlined,
            'Cài đặt',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingScreen()),
              );
            },
          ),
          _buildDrawerItem(
            Icons.help_outline,
            'Trợ giúp',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpScreen()),
              );
            },
          ),
          _buildDrawerItem(
            Icons.logout,
            'Đăng xuất',
            onTap: () {
              _logout(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
      onTap: onTap, // Gán sự kiện onTap từ bên ngoài
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xin chào, \n${widget.userAccount.userName}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Chúc một ngày làm việc hiệu quả!',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
            OutlinedButton.icon(
              icon: Icon(Icons.calendar_month),
              label: Text('Tháng 3, 2025'),
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Color(0xFFE9F3FF),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cần phê duyệt',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '5 hồ sơ ứng viên đang chờ đánh giá',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF3366FF),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('Xem ngay'),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.article_outlined,
                  size: 60,
                  // ignore: deprecated_member_use
                  color: Color(0xFF3366FF).withOpacity(0.7),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsSection(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Thống kê tuyển dụng',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: Text('Xem tất cả', style: TextStyle(color: primaryColor)),
            ),
          ],
        ),
        SizedBox(height: 16),
        GridView.count(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2, // Điều chỉnh tỷ lệ để tránh overflow
          children: [
            _buildStatisticCard(
              title: 'Ứng viên',
              count: '154',
              icon: Icons.people_outline,
              iconBackgroundColor: Color(0xFFE2F1FF),
              iconColor: primaryColor,
              trendValue: '+12%',
              trendUp: true,
            ),
            _buildStatisticCard(
              title: 'Công việc đang tuyển',
              count: '32',
              icon: Icons.work_outline,
              iconBackgroundColor: Color(0xFFFFEEE3),
              iconColor: Color(0xFFFF8A47),
              trendValue: '+5%',
              trendUp: true,
            ),
            _buildStatisticCard(
              title: 'Đã phỏng vấn',
              count: '78',
              icon: Icons.record_voice_over_outlined,
              iconBackgroundColor: Color(0xFFE9F9E7),
              iconColor: Color(0xFF4CAF50),
              trendValue: '+18%',
              trendUp: true,
            ),
            _buildStatisticCard(
              title: 'Được tuyển',
              count: '23',
              icon: Icons.check_circle_outline,
              iconBackgroundColor: Color(0xFFE8E4FF),
              iconColor: Color(0xFF7C4DFF),
              trendValue: '0%',
              trendUp: null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatisticCard({
    required String title,
    required String count,
    required IconData icon,
    required Color iconBackgroundColor,
    required Color iconColor,
    required String trendValue,
    required bool? trendUp,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Keep this to ensure minimum height
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 24, color: iconColor),
                ),
                if (trendUp != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: trendUp ? Color(0xFFE9F9E7) : Color(0xFFFFE8E8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          trendUp ? Icons.arrow_upward : Icons.arrow_downward,
                          size: 12,
                          color:
                              trendUp ? Color(0xFF4CAF50) : Color(0xFFE53935),
                        ),
                        SizedBox(width: 2),
                        Text(
                          trendValue,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:
                                trendUp ? Color(0xFF4CAF50) : Color(0xFFE53935),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            Flexible(
              // ignore: sized_box_for_whitespace
              child: Container(
                height: 70, // Fixed height to prevent overflow
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      count,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      title,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivitiesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Hoạt động gần đây',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Xem tất cả',
                style: TextStyle(color: Color(0xFF3366FF)),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 3,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              return _buildActivityItem(
                index == 0
                    ? 'Lê Văn Anh đã được mời phỏng vấn'
                    : index == 1
                    ? 'Công việc mới: Flutter Developer đã được đăng tuyển'
                    : 'Trần Thị Mai được nhận vào vị trí UI/UX Designer',
                index == 0
                    ? '2 giờ trước'
                    : index == 1
                    ? '5 giờ trước'
                    : '1 ngày trước',
                index == 0
                    ? Icons.calendar_today
                    : index == 1
                    ? Icons.work
                    : Icons.check_circle,
                index == 0
                    ? Color(0xFF7C4DFF)
                    : index == 1
                    ? Color(0xFF4CAF50)
                    : Color(0xFF3366FF),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    String title,
    String time,
    IconData icon,
    Color color,
  ) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 24, color: color),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
      ),
      subtitle: Text(
        time,
        style: TextStyle(fontSize: 13, color: Colors.black54),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  Widget _buildUpcomingSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lịch phỏng vấn sắp tới',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInterviewItem(
                  name: 'Nguyễn Văn Bình',
                  position: 'Senior Flutter Developer',
                  time: '9:00 - 10:30',
                  date: 'Hôm nay',
                  avatarColor: Color(0xFF3366FF),
                ),
                SizedBox(height: 12),
                Divider(),
                SizedBox(height: 12),
                _buildInterviewItem(
                  name: 'Trần Thị Hương',
                  position: 'Product Manager',
                  time: '13:30 - 14:30',
                  date: 'Hôm nay',
                  avatarColor: Color(0xFFFF8A47),
                ),
                SizedBox(height: 12),
                Divider(),
                SizedBox(height: 12),
                _buildInterviewItem(
                  name: 'Lê Minh Tuấn',
                  position: 'UI/UX Designer',
                  time: '10:00 - 11:00',
                  date: 'Ngày mai',
                  avatarColor: Color(0xFF4CAF50),
                ),
                SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(double.infinity, 48),
                  ),
                  child: Text('Xem tất cả lịch phỏng vấn'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInterviewItem({
    required String name,
    required String position,
    required String time,
    required String date,
    required Color avatarColor,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          // ignore: deprecated_member_use
          backgroundColor: avatarColor.withOpacity(0.2),
          child: Text(
            name.split(' ').map((e) => e[0]).join(),
            style: TextStyle(color: avatarColor, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 2),
              Text(
                position,
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              time,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            SizedBox(height: 2),
            Text(date, style: TextStyle(color: Colors.black54, fontSize: 13)),
          ],
        ),
      ],
    );
  }
}

class HomeHrPage extends StatefulWidget {
  final bool isLoggedIn;
  final Account userAccount;

  const HomeHrPage({
    super.key,
    required this.isLoggedIn,
    required this.userAccount,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeHrPage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      HRHomeScreen(
        key: PageStorageKey('HRHomeScreen'),
        userAccount: widget.userAccount,
      ),
      const SearchHrScreen(key: PageStorageKey('SearchHrScreen')),
      const PostJobPage(key: PageStorageKey('PostJobPage')),
      const HRMessagesPage(key: PageStorageKey('HRMessagesPage')),
      const RecruiterProfilePage(key: PageStorageKey('RecruiterProfilePage')),
    ]);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    // Chuyển thẳng đến trang tương ứng
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: Container(
        height: 76,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFF9FAFC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              spreadRadius: 0,
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
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
                  Icons.explore_outlined,
                  Icons.explore,
                  'Explore',
                ),
                _buildNavItem(
                  2,
                  Icons.camera_alt_outlined,
                  Icons.camera_alt,
                  'Post',
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

    // Nếu là nút đặc biệt (nút thêm bài viết)
    if (isSpecial) {
      return InkWell(
        onTap: () => _onTabTapped(index),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          width: 64,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6A82FB), Color(0xFFFC5C7D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFC5C7D).withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    isSelected ? iconFilled : iconOutlined,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 64,
                child: Text(
                  _getShortLabel(label),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color:
                        isSelected
                            ? const Color(0xFFFC5C7D)
                            : Colors.grey.shade500,
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
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? _getColorForIndex(index).withOpacity(0.12)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: _getColorForIndex(index).withOpacity(0.18),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ]
                        : null,
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
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
                            : Colors.grey.shade500,
                    size: isSelected ? 24 : 22,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 64,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color:
                      isSelected
                          ? _getColorForIndex(index)
                          : Colors.grey.shade500,
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
    // Màu sắc khác nhau cho từng tab mang lại sự phong phú
    switch (index) {
      case 0:
        return const Color(0xFF1E88E5); // Blue cho Home
      case 1:
        return const Color(0xFF26A69A); // Teal cho Explore
      case 2:
        return const Color(0xFFFC5C7D); // Pink cho Post
      case 3:
        return const Color(0xFF7E57C2); // Purple cho Messages
      case 4:
        return const Color(0xFF5C6BC0); // Indigo cho Profile
      default:
        return const Color(0xFF1E88E5);
    }
  }

  String _getShortLabel(String label) {
    if (label.length > 10) {
      return label.substring(0, 9) + '...';
    }
    return label;
  }
}
