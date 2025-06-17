import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_connect/features/help/screens/help_screen.dart';
import 'package:job_connect/features/payments/screens/hr_payment_screen.dart';
import 'package:job_connect/features/profile/screens/hr_edit_profile_screen.dart';
import 'package:job_connect/core/models/account_model.dart';
import 'package:job_connect/core/models/company_model.dart';
import 'package:job_connect/core/models/recruiter_info_model.dart';

class HrSettingsScreen extends StatefulWidget {
  final Account account;
  final Company company;
  final RecruiterInfo recruiterInfo;
  const HrSettingsScreen({
    super.key,
    required this.account,
    required this.company,
    required this.recruiterInfo,
  });

  @override
  State<HrSettingsScreen> createState() => _HrSettingsScreenState();
}

class _HrSettingsScreenState extends State<HrSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  double _textScale = 1.0;
  String _selectedLanguage = 'Tiếng Việt';
  bool _darkModeEnabled = false;

  @override
  void initState() {
    super.initState();
    // Nếu muốn lưu chế độ tối vào local storage, có thể load ở đây
  }

  @override
  Widget build(BuildContext context) {
    // Sử dụng MediaQuery để áp dụng textScaleFactor cho toàn bộ màn hình
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(_textScale)),
      child: Scaffold(
        backgroundColor: _darkModeEnabled ? Colors.grey[900] : Colors.grey[50],
        appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: _darkModeEnabled ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Cài đặt",
          style: TextStyle(
            color: _darkModeEnabled ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        systemOverlayStyle: _darkModeEnabled
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        ),
        body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Phần hồ sơ
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _darkModeEnabled ? Colors.grey[850] : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _darkModeEnabled ? Colors.grey[700]! : Colors.grey[200]!,
                                width: 2,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(widget.account.avatarUrl ?? ''),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.account.userName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _darkModeEnabled ? Colors.white : Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.account.email,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Phần cài đặt tài khoản
                    _buildSectionHeader(context, "Tài khoản"),
                    _buildSettingSection([
                      _buildSettingItem(
                        icon: Icons.person_outline,
                        title: "Thông tin cá nhân",
                        subtitle: "Chỉnh sửa thông tin cá nhân của bạn",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HrEditProfileScreen(
                                account: widget.account,
                                company: widget.company,
                                recruiterInfo: widget.recruiterInfo,
                              ),
                            ),
                          );
                        },
                        darkMode: _darkModeEnabled,
                      ),
                      _buildSettingItem(
                        icon: Icons.lock_outline,
                        title: "Bảo mật",
                        subtitle: "Thay đổi mật khẩu, xác thực hai yếu tố",
                        onTap: () {},
                        darkMode: _darkModeEnabled,
                      ),
                      _buildSettingItem(
                        icon: Icons.payment_outlined,
                        title: "Thanh toán",
                        subtitle: "Quản lý phương thức thanh toán",
                        onTap: () {},
                        darkMode: _darkModeEnabled,
                      ),
                    ]),

                    // Phần cài đặt chung
                    _buildSectionHeader(context, "Chung"),
                    _buildSettingSection([
                      _buildSwitchSettingItem(
                        icon: Icons.notifications_outlined,
                        title: "Thông báo",
                        value: _notificationsEnabled,
                        onChanged: (value) {
                          setState(() {
                            _notificationsEnabled = value;
                          });
                        },
                        darkMode: _darkModeEnabled,
                      ),
                      _buildSwitchSettingItem(
                        icon: Icons.dark_mode_outlined,
                        title: "Chế độ tối",
                        value: _darkModeEnabled,
                        onChanged: (value) {
                          setState(() {
                            _darkModeEnabled = value;
                          });
                        },
                        darkMode: _darkModeEnabled,
                      ),
                      _buildSwitchSettingItem(
                        icon: Icons.fingerprint,
                        title: "Đăng nhập sinh trắc học",
                        value: _biometricEnabled,
                        onChanged: (value) {
                          setState(() {
                            _biometricEnabled = value;
                          });
                        },
                        darkMode: _darkModeEnabled,
                      ),
                    ]),

                    // Phần cài đặt hiển thị
                    _buildSectionHeader(context, "Hiển thị"),
                    _buildSettingSection([
                      _buildTextScaleSettingItem(
                        icon: Icons.text_fields,
                        title: "Cỡ chữ",
                        value: _textScale,
                        onChanged: (value) {
                          setState(() {
                            _textScale = value;
                          });
                        },
                        darkMode: _darkModeEnabled,
                      ),
                      _buildDropdownSettingItem(
                        icon: Icons.language_outlined,
                        title: "Ngôn ngữ",
                        value: _selectedLanguage,
                        items: ['Tiếng Việt', 'English', '日本語', '한국어', '中文'],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedLanguage = value;
                            });
                          }
                        },
                        darkMode: _darkModeEnabled,
                      ),
                    ]),

                    // Phần cài đặt khác
                    _buildSectionHeader(context, "Khác"),
                    _buildSettingSection([
                      _buildSettingItem(
                        icon: Icons.help_outline,
                        title: "Trợ giúp & Hỗ trợ",
                        subtitle: "Câu hỏi thường gặp, liên hệ hỗ trợ",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HelpScreen()),
                          );
                        },
                        darkMode: _darkModeEnabled,
                      ),
                      _buildSettingItem(
                        icon: Icons.info_outline,
                        title: "Giới thiệu",
                        subtitle: "Phiên bản ứng dụng, điều khoản sử dụng",
                        onTap: () {},
                        darkMode: _darkModeEnabled,
                      ),
                    ]),

                    const SizedBox(height: 24),

                    // Nút đăng xuất
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Đăng xuất"),
                              content: const Text("Bạn có chắc chắn muốn đăng xuất?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Hủy"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    // Thực hiện đăng xuất
                                  },
                                  child: const Text("Đăng xuất"),
                                ),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[50],
                          foregroundColor: Colors.red,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Đăng xuất",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // Phiên bản ứng dụng
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          "Phiên bản 1.0.0",
                          style: TextStyle(
                            color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        )
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 24, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          // Nếu dark mode thì dùng màu xanh dương, không dùng trắng
          color: _darkModeEnabled ? Colors.white : Theme.of(context).primaryColor,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingSection(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: _darkModeEnabled ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    required bool darkMode,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: Colors.blue,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: darkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: darkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: darkMode ? Colors.grey[400] : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchSettingItem({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool darkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.blue,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: darkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  // Widget điều chỉnh cỡ chữ sử dụng Slider và hiển thị mức chữ
  Widget _buildTextScaleSettingItem({
    required IconData icon,
    required String title,
    required double value,
    required ValueChanged<double> onChanged,
    required bool darkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Colors.blue,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: darkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                value < 0.95
                    ? "Nhỏ"
                    : value > 1.25
                        ? "Lớn"
                        : "Vừa",
                style: TextStyle(
                  fontSize: 14,
                  color: darkMode ? Colors.grey[400] : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: 0.8,
            max: 1.4,
            divisions: 6,
            label: value.toStringAsFixed(2),
            onChanged: onChanged,
            activeColor: Colors.blue,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Nhỏ", style: TextStyle(fontSize: 12)),
                Text("Vừa", style: TextStyle(fontSize: 12)),
                Text("Lớn", style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSettingItem({
    required IconData icon,
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required bool darkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.blue,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: darkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          DropdownButton<String>(
            value: value,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
            underline: const SizedBox(),
            style: TextStyle(
              fontSize: 16,
              color: darkMode ? Colors.white : Colors.black87,
            ),
            dropdownColor: darkMode ? Colors.grey[850] : Colors.white,
          ),
        ],
      ),
    );
  }
}