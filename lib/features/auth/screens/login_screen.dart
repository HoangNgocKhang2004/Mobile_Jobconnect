import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_connect/collection/user_account_collection.dart';
import 'package:job_connect/core/models/account.dart';
import 'package:job_connect/features/auth/controllers/user_account_model.dart';
import 'package:job_connect/features/auth/controllers/auth_service.dart';
import 'package:job_connect/features/auth/screens/phone_login.dart';
import 'package:job_connect/features/hr/screens/hr_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:job_connect/features/auth/screens/register_screen.dart';
import 'package:job_connect/features/auth/screens/forgot_password_screen.dart';
import 'package:job_connect/features/home/screens/home_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum UserRole { candidate, employer }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  UserRole _selectedRole = UserRole.candidate;
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  final _auth = AuthService();
  final _userCollection = UserAccountCollection();

  // Add a flag to track which view to show
  bool _showLoginForm = false;

  @override
  void initState() {
    super.initState();
    _loadSavedUsername();

    // Animation setup
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Switch to the traditional login form
  void _showTraditionalLogin() {
    setState(() {
      _showLoginForm = true;
    });
  }

  // Switch back to social login options
  void _showSocialLoginOptions() {
    setState(() {
      _showLoginForm = false;
    });
  }

  // Navigate to the home screen for candidates
  goToHomeCandidate(BuildContext context, Account user) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (BuildContext context) =>
                HomePage(isLoggedIn: true, userAccount: user),
      ),
    );
  }

  // Navigate to the home screen for HR
  goToHomeHR(BuildContext context, Account user) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (BuildContext context) =>
                HomeHrPage(isLoggedIn: true, userAccount: user),
      ),
    );
  }

  // Show the login form or social login options based on the flag
  Future<void> _loginIn(BuildContext context) async {
    // Kiểm tra trạng thái loading
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    // Đặt trạng thái loading
    setState(() {
      _isLoading = true;
    });

    String username = _emailController.text.trim();

    await Future.delayed(const Duration(seconds: 1));

    // 1. Gọi hàm đăng nhập với email và mật khẩu
    // Kiểm tra xem người dùng đã nhập email và mật khẩu chưa
    final userCredential = await _auth.loginInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );

    // Kiểm tra xem người dùng đã đăng nhập thành công chưa
    if (userCredential == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tên đăng nhập hoặc mật khẩu không đúng'),
            backgroundColor: Colors.red,
          ),
        );
      }

      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Lấy thông tin người dùng từ Firebase
    final user = userCredential.user;

    // 2. Kiểm tra User trong Firestore
    final userDoc = await _userCollection.getUserById(user?.uid ?? '');
    print(
      "Kiểm tra userDoc: ${userDoc != null ? 'Tìm thấy' : 'Không tìm thấy'}",
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    //await prefs.setString('userRole', _selectedRole?.toString() ?? 'unknown');

    // Lưu trạng thái đăng nhập nếu cần (ví dụ: SharedPreferences)
    if (_rememberMe) {
      await prefs.setString('username', username);
    } else {
      await prefs.remove('username');
    }

    if (userDoc != null) {
      if (mounted) {
        // Thêm hiệu ứng fade out khi chuyển màn hình
        _animationController.reverse().then((_) {
          if (userDoc.role != null && userDoc.role.roleName == 'Candidate') {
            goToHomeCandidate(context, userDoc);
            return;
          }

          if (userDoc.role != null && userDoc.role.roleName == 'HR') {
            goToHomeHR(context, userDoc);
            return;
          }
        });
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không tìm thấy người dùng trong hệ thống.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Hàm đăng nhập bằng Google
  Future<void> _loginGoogle(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Gọi Google Auth
      final userCredential = await _auth.authGoogle();

      print("Google UserCredential: $userCredential");

      // Kiểm tra xem người dùng đã đăng nhập thành công chưa
      if (userCredential == null || userCredential.user == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Đăng nhập bằng Google thất bại, vui lòng thử lại.',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
        setState(() {
          _isLoading = false;
        });
        return; // Dừng nếu auth thất bại
      }

      // 2. Kiểm tra User trong Firestore
      final user = userCredential.user!;
      final userDoc = await _userCollection.getUserById(user.uid);

      print(
        "Kiểm tra userDoc: ${userDoc != null ? 'Tìm thấy' : 'Không tìm thấy'}",
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      if (userDoc != null) {
        print("User Role: ${userDoc.role.roleName}");

        if (mounted) {
          // Thêm hiệu ứng fade out khi chuyển màn hình
          _animationController.reverse().then((_) {
            if (userDoc.role.roleName == 'Candidate') {
              goToHomeCandidate(context, userDoc);
              return;
            }

            if (userDoc.role.roleName == 'HR') {
              goToHomeHR(context, userDoc);
              return;
            }
          });
        }
      } else {
        // Người dùng không tồn tại, hiển thị thông báo gợi ý đăng ký
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Tài khoản Google chưa được đăng ký, vui lòng đăng ký trước.',
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4),
            ),
          );

          // Có thể chuyển hướng đến trang đăng ký ở đây nếu cần
          // Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
        }
      }
    } catch (e) {
      print("Lỗi Google Sign In chi tiết: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Đã xảy ra lỗi khi đăng nhập Google: ${e.toString()}',
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Hàm đăng nhập bằng Facebook
  Future<void> _loginFacebook(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Gọi Facebook Auth
      final userCredential = await _auth.authFacebook();

      print("Facebook UserCredential: $userCredential");

      // Kiểm tra xem người dùng đã đăng nhập thành công chưa
      if (userCredential == null || userCredential.user == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Đăng nhập bằng Facebook thất bại, vui lòng thử lại.',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
        setState(() {
          _isLoading = false;
        });
        return; // Dừng nếu auth thất bại
      }

      // 2. Kiểm tra User trong Firestore
      final user = userCredential.user!;
      final userDoc = await _userCollection.getUserById(user.uid);

      print(
        "Kiểm tra userDoc: ${userDoc != null ? 'Tìm thấy' : 'Không tìm thấy'}",
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      if (userDoc != null) {
        print("User Role: ${userDoc.role.roleName}");

        if (mounted) {
          // Thêm hiệu ứng fade out khi chuyển màn hình
          _animationController.reverse().then((_) {
            if (userDoc.role.roleName == 'Candidate') {
              goToHomeCandidate(context, userDoc);
              return;
            }

            if (userDoc.role.roleName == 'HR') {
              goToHomeHR(context, userDoc);
              return;
            }
          });
        }
      } else {
        // Người dùng không tồn tại, hiển thị thông báo gợi ý đăng ký
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Tài khoản Facebook chưa được đăng ký, vui lòng đăng ký trước.',
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      print("Lỗi Facebook Sign In chi tiết: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Đã xảy ra lỗi khi đăng nhập Facebook: ${e.toString()}',
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Hàm đăng nhập bằng số điện thoại (Firebase Phone Auth)
  // Hàm mở trang đăng nhập bằng số điện thoại
  Future<void> _loginWithPhone(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PhoneLoginScreen(
              onLoginSuccess: (user) async {
                final userDoc = await _userCollection.getUserById(user!.uid);
                if (mounted && userDoc != null) {
                  _animationController.reverse().then((_) {
                    if (userDoc.role.roleName == 'Candidate') {
                      goToHomeCandidate(context, userDoc);
                    } else if (userDoc.role.roleName == 'HR') {
                      goToHomeHR(context, userDoc);
                    }
                  });
                }
              },
            ),
      ),
    );
  }

  // Hàm khôi phục tên đăng nhập đã lưu từ SharedPreferences
  Future<void> _loadSavedUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username');
    if (savedUsername != null) {
      setState(() {
        _emailController.text = savedUsername;
        _rememberMe = true;
      });
    }

    // Khôi phục vai trò người dùng nếu có
    final savedRole = prefs.getString('userRole');
    if (savedRole != null) {
      try {
        setState(() {
          _selectedRole = UserRole.values.firstWhere(
            (e) => e.toString() == savedRole,
            orElse: () => UserRole.candidate,
          );
        });
      } catch (_) {
        // Mặc định là ứng viên nếu có lỗi
        setState(() {
          _selectedRole = UserRole.candidate;
        });
      }
    }
  }

  // Build the social login options view (initial view)
  Widget _buildSocialLoginView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo - Sử dụng Image thay vì Icon để hiển thị logo thực tế
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/logohuit.png', // Thay thế bằng logo thực tế
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Icon(
                      FontAwesomeIcons.userTie,
                      size: 60,
                      color: const Color(0xFF1565C0),
                    ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Tiêu đề đăng nhập
          const Text(
            'Chào mừng bạn trở lại',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF202124),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Đăng nhập để tiếp tục với Huitworks',
            style: TextStyle(fontSize: 14, color: Color(0xFF5F6368)),
          ),
          const SizedBox(height: 32),

          // Huitworks login button
          _buildLoginButton(
            onPressed: _showTraditionalLogin,
            text: 'Đăng nhập với Huitworks',
            backgroundColor: const Color(0xFF1976D2),
            textColor: Colors.white,
            icon: Icons.business_center,
            iconColor: Colors.white,
            hasBorder: false,
          ),
          const SizedBox(height: 20),

          // Divider with text
          Row(
            children: const [
              Expanded(child: Divider(thickness: 1, color: Color(0xFFE0E0E0))),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'hoặc tiếp tục với',
                  style: TextStyle(color: Color(0xFF5F6368), fontSize: 12),
                ),
              ),
              Expanded(child: Divider(thickness: 1, color: Color(0xFFE0E0E0))),
            ],
          ),
          const SizedBox(height: 20),

          // Social Login Buttons
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE0E0E0),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        _loginGoogle(context);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Center(
                        child: Image.asset(
                          'assets/icons/google.png',
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSocialIconButton(
                  icon: Icons.facebook,
                  iconColor: const Color(0xFF1877F2),
                  borderColor: const Color(0xFFE0E0E0),
                  onPressed: () {
                    _loginFacebook(context);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSocialIconButton(
                  icon: Icons.phone,
                  iconColor: Colors.green,
                  borderColor: const Color(0xFFE0E0E0),
                  onPressed: () {
                    _loginWithPhone(context);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),

          // Register link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Chưa có tài khoản Huitworks?',
                style: TextStyle(color: Color(0xFF5F6368), fontSize: 14),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder:
                          (context, animation, secondaryAnimation) =>
                              const RegisterScreen(),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        var curve = Curves.easeInOut;
                        var tween = Tween(
                          begin: 0.0,
                          end: 1.0,
                        ).chain(CurveTween(curve: curve));
                        return FadeTransition(
                          opacity: animation.drive(tween),
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 500),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF1976D2),
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Đăng Ký',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    //decoration: TextDecoration.underline,
                    decorationThickness: 2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Terms and Privacy
          const Text(
            'Bằng cách tiếp tục, bạn đồng ý với Điều khoản sử dụng và Chính sách bảo mật của chúng tôi',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF757575), fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Helper method để tạo nút đăng nhập với style nhất quán
  Widget _buildLoginButton({
    required VoidCallback onPressed,
    required String text,
    required Color backgroundColor,
    required Color textColor,
    required IconData icon,
    required Color iconColor,
    required bool hasBorder,
  }) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: backgroundColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: iconColor, size: 20),
        label: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side:
                hasBorder
                    ? BorderSide(color: const Color(0xFFE0E0E0), width: 1)
                    : BorderSide.none,
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  // Helper method để tạo các nút đăng nhập bằng mạng xã hội dạng icon
  Widget _buildSocialIconButton({
    required IconData icon,
    required Color iconColor,
    required Color borderColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Center(child: Icon(icon, color: iconColor, size: 24)),
        ),
      ),
    );
  }

  // Build the traditional login form
  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Back button to return to social login options
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF1976D2)),
                onPressed: _showSocialLoginOptions,
              ),
            ),

            // Logo container with consistent design from splash
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(130),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logohuit.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Icon(
                        FontAwesomeIcons.userTie,
                        size: 60,
                        color: const Color(0xFF1565C0),
                      ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              'Huitworks',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976D2),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            // const Text(
            //   'Kết nối tài năng, mở rộng cơ hội nghề nghiệp!',
            //   style: TextStyle(
            //     fontSize: 13,
            //     color: Colors.black54,
            //     letterSpacing: 0.5,
            //   ),
            // ),
            const SizedBox(height: 24),

            // Role selection
            // Container(
            //   padding: const EdgeInsets.symmetric(vertical: 8),
            //   decoration: BoxDecoration(
            //     // ignore: deprecated_member_use
            //     color: Colors.blue.withOpacity(0.05),
            //     borderRadius: BorderRadius.circular(16),
            //     // ignore: deprecated_member_use
            //     border: Border.all(color: Colors.blue.withOpacity(0.1)),
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       const Padding(
            //         padding: EdgeInsets.only(left: 16, top: 8),
            //         child: Text(
            //           'Bạn là:',
            //           style: TextStyle(
            //             fontWeight: FontWeight.w500,
            //             fontSize: 16,
            //             color: Color(0xFF1976D2),
            //           ),
            //         ),
            //       ),
            //       Row(
            //         children: [
            //           Expanded(
            //             flex: 1,
            //             child: RadioListTile<UserRole>(
            //               dense: true,
            //               title: const Text(
            //                 'Ứng viên',
            //                 style: TextStyle(fontSize: 14),
            //               ),
            //               value: UserRole.candidate,
            //               groupValue: _selectedRole,
            //               activeColor: const Color(0xFF1976D2),
            //               onChanged: (UserRole? value) {
            //                 setState(() {
            //                   _selectedRole = value!;
            //                 });
            //               },
            //             ),
            //           ),
            //           Expanded(
            //             flex: 1,
            //             child: RadioListTile<UserRole>(
            //               dense: true,
            //               title: const Text(
            //                 'HR',
            //                 style: TextStyle(fontSize: 14),
            //               ),
            //               value: UserRole.employer,
            //               groupValue: _selectedRole,
            //               activeColor: const Color(0xFF1976D2),
            //               onChanged: (UserRole? value) {
            //                 setState(() {
            //                   _selectedRole = value!;
            //                 });
            //               },
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 20),
            // Email field
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Nhập Email',
                labelStyle: const TextStyle(color: Color(0xFF1976D2)),
                prefixIcon: const Icon(Icons.email, color: Color(0xFF1976D2)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  // ignore: deprecated_member_use
                  borderSide: BorderSide(color: Colors.blue.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFF1976D2),
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
                filled: true,
                // ignore: deprecated_member_use
                fillColor: Colors.blue.withOpacity(0.05),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tên đăng nhập';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Password field
            TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                hintText: 'Nhập mật khẩu',
                labelStyle: const TextStyle(color: Color(0xFF1976D2)),
                prefixIcon: const Icon(Icons.lock, color: Color(0xFF1976D2)),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: const Color(0xFF1976D2),
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  // ignore: deprecated_member_use
                  borderSide: BorderSide(color: Colors.blue.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFF1976D2),
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
                filled: true,
                // ignore: deprecated_member_use
                fillColor: Colors.blue.withOpacity(0.05),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập mật khẩu';
                }
                return null;
              },
            ),

            const SizedBox(height: 8),

            // Remember and Forgot password
            Row(
              children: [
                Theme(
                  data: Theme.of(context).copyWith(
                    checkboxTheme: CheckboxThemeData(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    // ignore: deprecated_member_use
                    unselectedWidgetColor: Colors.blue.withOpacity(0.6),
                  ),
                  child: Checkbox(
                    value: _rememberMe,
                    activeColor: const Color(0xFF1976D2),
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value!;
                      });
                    },
                  ),
                ),
                const Text(
                  'Nhớ tài khoản',
                  style: TextStyle(color: Colors.black54),
                ),
                const Spacer(),
                // Cập nhật nút quên mật khẩu
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF1976D2),
                  ),
                  child: const Text(
                    'Quên mật khẩu?',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Login button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: !_isLoading ? () => _loginIn(context) : null,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:
                      _selectedRole == UserRole.candidate
                          ? const Color(0xFF1976D2)
                          : const Color(0xFF1976D2),
                  // ignore: deprecated_member_use
                  disabledBackgroundColor: Colors.blue.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                ),
                child:
                    _isLoading
                        ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : Text(
                          "ĐĂNG NHẬP",
                          // _selectedRole == UserRole.candidate
                          //     ? 'ĐĂNG NHẬP VỚI TƯ CÁCH ỨNG VIÊN'
                          //     : 'ĐĂNG NHẬP VỚI TƯ CÁCH HR',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
              ),
            ),

            const SizedBox(height: 20),

            // Register link
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     const Text(
            //       'Chưa có tài khoản?',
            //       style: TextStyle(color: Colors.black54),
            //     ),
            //     TextButton(
            //       onPressed: () {
            //         Navigator.push(
            //           context,
            //           PageRouteBuilder(
            //             pageBuilder:
            //                 (context, animation, secondaryAnimation) =>
            //                     const RegisterScreen(),
            //             transitionsBuilder: (
            //               context,
            //               animation,
            //               secondaryAnimation,
            //               child,
            //             ) {
            //               return FadeTransition(
            //                 opacity: animation,
            //                 child: child,
            //               );
            //             },
            //             transitionDuration: const Duration(milliseconds: 800),
            //           ),
            //         );
            //       },
            //       style: TextButton.styleFrom(
            //         foregroundColor: const Color(0xFF1976D2),
            //       ),
            //       child: const Text(
            //         'Đăng ký ngay',
            //         style: TextStyle(fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D47A1), // Deep blue
              Color(0xFF1976D2), // Blue
              Color(0xFF42A5F5), // Light blue
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeInAnimation,
            child: Stack(
              children: [
                // Background design elements
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.05,
                  right: -50,
                  child: const Opacity(
                    opacity: 0.15,
                    child: Icon(Icons.circle, size: 200, color: Colors.white),
                  ),
                ),
                Positioned(
                  bottom: -30,
                  left: -30,
                  child: const Opacity(
                    opacity: 0.1,
                    child: Icon(Icons.circle, size: 150, color: Colors.white),
                  ),
                ),

                Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Container(
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder: (
                            Widget child,
                            Animation<double> animation,
                          ) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          child:
                              _showLoginForm
                                  ? _buildLoginForm()
                                  : _buildSocialLoginView(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
