import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:job_connect/collection/user_account_collection.dart';
import 'package:job_connect/core/models/account.dart';
import 'package:job_connect/core/models/role_model.dart';
import 'package:job_connect/features/auth/controllers/user_account_model.dart';
import 'package:job_connect/features/auth/controllers/auth_service.dart';
import 'package:job_connect/features/auth/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _roleController = TextEditingController(text: 'Candidate');
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;
  bool _agreeToTerms = false;
  String _selectedCountryCode = '+84'; // Mã mặc định cho Việt Nam
  bool _isLoading = false;
  bool _isCompletingSignUp =
      false; // Trạng thái chờ chọn vai trò sau khi Google Sign In
  User? _user; // Lưu tạm thông tin user

  final _auth = AuthService();
  final _userCollection = UserAccountCollection();

  @override
  void dispose() {
    _roleController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lấy màu chính từ theme để sử dụng trong toàn bộ UI
    final primaryColor = Theme.of(context).primaryColor;
    // ignore: deprecated_member_use
    final secondaryColor = primaryColor.withOpacity(0.1);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Nút quay lại
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Logo hoặc hình ảnh
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: primaryColor.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logohuit.png',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tiêu đề
                  const Text(
                    'Tạo tài khoản',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  // Phụ đề
                  Text(
                    'Hãy điền thông tin cá nhân để đăng ký',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // Form đăng ký
                  // Role
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Vai trò',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Ứng viên'),
                              value: 'Candidate',
                              groupValue: _roleController.text,
                              onChanged: (value) {
                                setState(() {
                                  _roleController.text = value!;
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('HR'),
                              value: 'HR',
                              groupValue: _roleController.text,
                              onChanged: (value) {
                                setState(() {
                                  _roleController.text = value!;
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Họ tên
                  _buildTextField(
                    controller: _nameController,
                    label: 'Họ và tên',
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập họ tên';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Email
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập email';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'Email không hợp lệ';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Số điện thoại với mã quốc gia
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Row(
                      children: [
                        // Widget chọn mã quốc gia
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(color: Colors.grey.shade400),
                            ),
                          ),
                          child: CountryCodePicker(
                            onChanged: (CountryCode countryCode) {
                              setState(() {
                                _selectedCountryCode =
                                    countryCode.dialCode ?? '+84';
                              });
                            },
                            initialSelection: 'VN',
                            favorite: const ['VN', 'US', 'GB', 'JP', 'KR'],
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            alignLeft: false,
                            padding: EdgeInsets.zero,
                          ),
                        ),

                        // Trường nhập số điện thoại
                        Expanded(
                          child: TextFormField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              labelText: 'Số điện thoại',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập số điện thoại';
                              }
                              if (!RegExp(r'^\d{9,10}$').hasMatch(value)) {
                                return 'Số điện thoại không hợp lệ';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // === Nút Hành động ===
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (_isCompletingSignUp) ...[
                    // Điều khoản và điều kiện
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Transform.scale(
                          scale: 1.1,
                          child: Checkbox(
                            value: _agreeToTerms,
                            onChanged: (value) {
                              setState(() {
                                _agreeToTerms = value ?? false;
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            activeColor: primaryColor,
                          ),
                        ),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: 'Tôi đồng ý với ',
                              style: const TextStyle(fontSize: 15),
                              children: [
                                TextSpan(
                                  text: 'Điều khoản & Điều kiện',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () {
                                          // Hiển thị điều khoản và điều kiện
                                        },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Nút Hoàn tất đăng ký
                    ElevatedButton(
                      onPressed: () {
                        if (_user?.providerData.first.providerId ==
                            'google.com') {
                          _completeGoogleRegistration(context);
                        } else if (_user?.providerData.first.providerId ==
                            'facebook.com') {
                          _completeFacebookRegistration(context);
                        } else if (_user?.providerData.first.providerId ==
                            'phone') {
                          _completePhoneRegistration(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'HOÀN TẤT ĐĂNG KÝ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ] else ...[
                    _buildPasswordField(
                      controller: _passwordController,
                      label: 'Mật khẩu',
                      isObscure: _isObscurePassword,
                      onToggleVisibility: () {
                        setState(() {
                          _isObscurePassword = !_isObscurePassword;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mật khẩu';
                        }
                        if (value.length < 6) {
                          return 'Mật khẩu phải có ít nhất 6 ký tự';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    _buildPasswordField(
                      controller: _confirmPasswordController,
                      label: 'Xác nhận mật khẩu',
                      isObscure: _isObscureConfirmPassword,
                      onToggleVisibility: () {
                        setState(() {
                          _isObscureConfirmPassword =
                              !_isObscureConfirmPassword;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng xác nhận mật khẩu';
                        }
                        if (value != _passwordController.text) {
                          return 'Mật khẩu không khớp';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Điều khoản và điều kiện
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Transform.scale(
                          scale: 1.1,
                          child: Checkbox(
                            value: _agreeToTerms,
                            onChanged: (value) {
                              setState(() {
                                _agreeToTerms = value ?? false;
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            activeColor: primaryColor,
                          ),
                        ),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: 'Tôi đồng ý với ',
                              style: const TextStyle(fontSize: 15),
                              children: [
                                TextSpan(
                                  text: 'Điều khoản & Điều kiện',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () {
                                          // Hiển thị điều khoản và điều kiện
                                        },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Nút đăng ký bằng Email/Password
                    ElevatedButton(
                      onPressed: () => _email_password_sign_up(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'ĐĂNG KÝ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Đã có tài khoản
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Đã có tài khoản? ',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 15,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Đăng nhập',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Hoặc đăng ký với
                    Row(
                      children: [
                        Expanded(
                          child: Divider(color: Colors.grey[400], thickness: 1),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Hoặc đăng ký với',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(color: Colors.grey[400], thickness: 1),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Đăng ký bằng mạng xã hội
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Google sign up button
                        InkWell(
                          onTap: () {
                            _initiateGoogleSignIn(context);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/icons/google.png',
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Facebook sign up button
                        _socialButton(
                          icon: Icons.facebook,
                          color: Colors.blue,
                          onTap: () {
                            _initiateFacebookSignIn(context);
                          },
                        ),
                        const SizedBox(width: 24),
                        // Phone authentication button
                        _socialButton(
                          icon: Icons.phone_android,
                          color: Colors.green,
                          onTap: () {
                            // Xử lý đăng ký với số điện thoại
                            _initiatePhoneSignIn(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget tạo trường nhập text chung
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      validator: validator,
    );
  }

  // Widget tạo trường nhập mật khẩu
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isObscure,
    required VoidCallback onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            isObscure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: onToggleVisibility,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      validator: validator,
    );
  }

  // Widget tạo nút mạng xã hội
  Widget _socialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: Icon(icon, color: color, size: 30)),
      ),
    );
  }

  //
  goToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
    );
  }

  // Hàm ví dụ điều hướng khi đăng nhập thành công
  void goToLoginSuccess(BuildContext context) {
    // Ví dụ: lưu SharedPreferences và điều hướng
    print("Điều hướng đến trang chính sau khi đăng nhập Google thành công.");
    // Navigator.of(context).pushReplacementNamed('/home');
    goToLogin(context); // Tạm gọi lại hàm cũ của bạn
  }

  /*Xu ly dang ky*/

  Future<void> _email_password_sign_up(BuildContext context) async {
    // Kiểm tra xem form có hợp lệ không
    if (_formKey.currentState!.validate()) {
      if (!_agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vui lòng đồng ý với điều khoản và điều kiện'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final user = await _auth.signupWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Kiểm tra xem người dùng đã được tạo thành công hay chưa
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng ký thất bại!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      _user = user.user;

      final userAccount = Account(
        idUser: _user!.uid,
        userName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _selectedCountryCode + _phoneController.text.trim(),
        role:
            _roleController.text == 'HR'
                ? Role(
                  idRole: 'IDR002',
                  roleName: 'HR',
                  description: 'Người tuyển dụng',
                )
                : Role(
                  idRole: 'IDR003',
                  roleName: 'Candidate',
                  description: 'Người tìm việc',
                ),
        accountStatus: AccountStatus.Active.name,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Thêm người dùng vào Firestore với ID tự động
      await _userCollection.addUser(userAccount);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng ký thành công!'),
          backgroundColor: Colors.green,
        ),
      );

      goToLogin(context);
    }
  }

  Future<void> _initiatePhoneSignIn(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final phone = _selectedCountryCode + _phoneController.text.trim();

    try {
      await _auth.authPhone(
        phoneNumber: phone,
        onCodeSent: (String verificationId, int? forceResendingToken) async {
          setState(() {
            _isLoading = false;
          });
          String smsCode = '';
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: const Text('Nhập mã xác thực OTP'),
                content: TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Mã OTP'),
                  onChanged: (value) {
                    smsCode = value;
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Hủy'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (smsCode.isEmpty) return;
                      Navigator.of(context).pop();
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        final credential = PhoneAuthProvider.credential(
                          verificationId: verificationId,
                          smsCode: smsCode,
                        );
                        final userCredential = await FirebaseAuth.instance
                            .signInWithCredential(credential);
                        setState(() {
                          _isLoading = false;
                        });

                        if (userCredential.user == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Đăng ký bằng số điện thoại thất bại.',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        _user = userCredential.user;

                        // Kiểm tra user đã tồn tại trong Firestore chưa
                        final userDoc = await _userCollection.getUserById(
                          _user!.uid,
                        );

                        if (userDoc != null) {
                          goToLoginSuccess(context);
                        } else {
                          setState(() {
                            _isCompletingSignUp = true;
                            // Không có email/displayName với phone, để trống
                            _emailController.text = '';
                            _nameController.text = '';
                          });
                        }
                      } catch (e) {
                        setState(() {
                          _isLoading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Xác thực OTP thất bại: ${e.toString()}',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: const Text('Xác nhận'),
                  ),
                ],
              );
            },
          );
        },
        onVerificationCompleted: (PhoneAuthCredential credential) async {
          try {
            final userCredential = await FirebaseAuth.instance
                .signInWithCredential(credential);
            setState(() {
              _isLoading = false;
            });

            if (userCredential.user == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đăng ký bằng số điện thoại thất bại.'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            _user = userCredential.user;

            // Kiểm tra user đã tồn tại trong Firestore chưa
            final userDoc = await _userCollection.getUserById(_user!.uid);

            if (userDoc != null) {
              goToLoginSuccess(context);
            } else {
              setState(() {
                _isCompletingSignUp = true;
                _emailController.text = '';
                _nameController.text = '';
              });
            }
          } catch (e) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Xác thực tự động thất bại: ${e.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        // Xác thực không thành công
        onVerificationFailed: (FirebaseAuthException e) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi xác thực: ${e.message}'),
              backgroundColor: Colors.red,
            ),
          );
        },
        // Hết thời gian tự động xác thực
        onCodeAutoRetrievalTimeout: (verificationId) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Hết thời gian nhập mã OTP.'),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xảy ra lỗi: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _completePhoneRegistration(BuildContext context) async {
    // Chỉ chạy nếu đang ở trạng thái hoàn tất và có dữ liệu user Phone
    if (!_isCompletingSignUp || _user == null) return;

    // Validate xem đã chọn role chưa và các trường cần thiết khác (ví dụ: phone, terms)
    if (_roleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn vai trò của bạn (HR hoặc Candidate)'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng đồng ý với điều khoản và điều kiện'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) {
      print("Form không hợp lệ khi hoàn tất");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final role =
          _roleController.text == 'HR'
              ? Role(
                idRole: 'IDR002',
                roleName: 'HR',
                description: 'Người tuyển dụng',
              )
              : Role(
                idRole: 'IDR003',
                roleName: 'Candidate',
                description: 'Người tìm việc',
              );

      final userAccount = Account(
        idUser: _user!.uid,
        userName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _selectedCountryCode + _phoneController.text.trim(),
        role:
            _roleController.text == 'HR'
                ? Role(
                  idRole: 'IDR002',
                  roleName: 'HR',
                  description: 'Người tuyển dụng',
                )
                : Role(
                  idRole: 'IDR003',
                  roleName: 'Candidate',
                  description: 'Người tìm việc',
                ),
        accountStatus: AccountStatus.Active.name,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _userCollection.addUser(userAccount);
      print(
        "Đã lưu thông tin người dùng Phone vào Firestore: ${userAccount.toJson()}",
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng ký thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        goToLoginSuccess(context);
      }
    } catch (e) {
      print("Lỗi lưu Firestore khi hoàn tất Phone Sign Up: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi lưu thông tin: ${e.toString()}'),
            backgroundColor: Colors.red,
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

  Future<void> _initiateGoogleSignIn(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Gọi Google Auth
      final userCredential = await _auth.authGoogle();

      print("Google UserCredential: $userCredential");

      // Kiểm tra xem người dùng đã được tạo thành công hay chưa
      if (userCredential == null || userCredential.user == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đăng ký bằng Google thất bại.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return; // Dừng nếu auth thất bại
      }

      // 2. Kiểm tra User trong Firestore
      final user = userCredential.user!;
      final userDoc = await _userCollection.getUserById(user.uid);

      if (userDoc != null) {
        // ---- NGƯỜI DÙNG ĐÃ TỒN TẠI (ĐĂNG NHẬP) ----
        print('Google User đã tồn tại. Vui lòng đăng nhập...');
        if (mounted) {
          goToLoginSuccess(context);
        }
      } else {
        // ---- NGƯỜI DÙNG MỚI (CẦN CHỌN ROLE) ----
        print('Google User mới. Chuyển sang chọn Role.');
        if (mounted) {
          setState(() {
            _user = user; // Lưu thông tin user Google
            _isCompletingSignUp = true; // Bật trạng thái chờ chọn role

            // Tự động điền một số trường nếu muốn
            _emailController.text = user.email ?? '';
            _nameController.text = user.displayName ?? '';
          });
        }
      }
    } catch (e) {
      print("Lỗi Google Sign In hoặc Firestore check: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xảy ra lỗi: ${e.toString()}'),
            backgroundColor: Colors.red,
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

  Future<void> _completeGoogleRegistration(BuildContext context) async {
    // Chỉ chạy nếu đang ở trạng thái hoàn tất và có dữ liệu user Google
    if (!_isCompletingSignUp || _user == null) return;

    // Validate xem đã chọn role chưa và các trường cần thiết khác (ví dụ: phone, terms)
    if (_roleController.selection == const TextSelection.collapsed(offset: 0)) {
      // Nếu chưa chọn role, hiển thị thông báo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn vai trò của bạn (HR hoặc Candidate)'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng đồng ý với điều khoản và điều kiện'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Validate các trường khác nếu cần (_formKey có thể cần validate lại phần phone, name nếu bạn cho sửa)
    if (!_formKey.currentState!.validate()) {
      print("Form không hợp lệ khi hoàn tất");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Tạo RoleModel dựa trên lựa chọn
      final role =
          _roleController.text == 'HR'
              ? Role(
                idRole: 'IDR002',
                roleName: 'HR',
                description: 'Người tuyển dụng',
              )
              : Role(
                idRole: 'IDR003',
                roleName: 'Candidate',
                description: 'Người tìm việc',
              );

      // Tạo UserAccountModel cuối cùng
      final userAccount = Account(
        idUser: _user!.uid,
        userName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _selectedCountryCode + _phoneController.text.trim(),
        role:
            _roleController.text == 'HR'
                ? Role(
                  idRole: 'IDR002',
                  roleName: 'HR',
                  description: 'Người tuyển dụng',
                )
                : Role(
                  idRole: 'IDR003',
                  roleName: 'Candidate',
                  description: 'Người tìm việc',
                ),
        accountStatus: AccountStatus.Active.name,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Lưu vào Firestore bằng ID cụ thể (quan trọng)
      await _userCollection.addUser(userAccount);
      print(
        "Đã lưu thông tin người dùng vào Firestore: ${userAccount.toJson()}",
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng ký thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        // Điều hướng đến màn hình chính hoặc login thành công
        goToLoginSuccess(context);
      }
    } catch (e) {
      print("Lỗi lưu Firestore khi hoàn tất Google Sign Up: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi lưu thông tin: ${e.toString()}'),
            backgroundColor: Colors.red,
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

  Future<void> _initiateFacebookSignIn(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Gọi Facebook Auth
      final userCredential = await _auth.authFacebook();

      print("Facebook UserCredential: $userCredential");

      // Kiểm tra xem người dùng đã được tạo thành công hay chưa
      if (userCredential == null || userCredential.user == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đăng ký bằng Facebook thất bại.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return; // Dừng nếu auth thất bại
      }

      // 2. Kiểm tra User trong Firestore
      final user = userCredential.user!;
      final userDoc = await _userCollection.getUserById(user.uid);

      if (userDoc != null) {
        // ---- NGƯỜI DÙNG ĐÃ TỒN TẠI (ĐĂNG NHẬP) ----
        print('Facebook User ${user.uid} đã tồn tại. Đăng nhập...');
        if (mounted) {
          goToLoginSuccess(context);
        }
      } else {
        // ---- NGƯỜI DÙNG MỚI (CẦN CHỌN ROLE) ----
        print('Facebook User ${user.uid} mới. Chuyển sang chọn Role.');
        if (mounted) {
          setState(() {
            _user = user; // Lưu thông tin user Facebook
            _isCompletingSignUp = true; // Bật trạng thái chờ chọn role

            // Có thể tự điền một số trường nếu muốn
            _emailController.text = user.email ?? '';
            _nameController.text = user.displayName ?? '';
          });
        }
      }
    } catch (e) {
      print("Lỗi Facebook Sign In hoặc Firestore check: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xảy ra lỗi: ${e.toString()}'),
            backgroundColor: Colors.red,
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

  Future<void> _completeFacebookRegistration(BuildContext context) async {
    // Chỉ chạy nếu đang ở trạng thái hoàn tất và có dữ liệu user Facebook
    if (!_isCompletingSignUp || _user == null) return;

    // Validate xem đã chọn role chưa và các trường cần thiết khác (ví dụ: phone, terms)
    if (_roleController.text.isEmpty) {
      // Nếu chưa chọn role, hiển thị thông báo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn vai trò của bạn (HR hoặc Candidate)'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng đồng ý với điều khoản và điều kiện'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Validate các trường khác nếu cần (_formKey có thể cần validate lại phần phone, name nếu bạn cho sửa)
    if (!_formKey.currentState!.validate()) {
      print("Form không hợp lệ khi hoàn tất");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Tạo RoleModel dựa trên lựa chọn
      final role =
          _roleController.text == 'HR'
              ? Role(
                idRole: 'IDR002',
                roleName: 'HR',
                description: 'Người tuyển dụng',
              )
              : Role(
                idRole: 'IDR003',
                roleName: 'Candidate',
                description: 'Người tìm việc',
              );

      // Tạo UserAccountModel cuối cùng
      final userAccount = Account(
        idUser: _user!.uid,
        userName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _selectedCountryCode + _phoneController.text.trim(),
        role:
            _roleController.text == 'HR'
                ? Role(
                  idRole: 'IDR002',
                  roleName: 'HR',
                  description: 'Người tuyển dụng',
                )
                : Role(
                  idRole: 'IDR003',
                  roleName: 'Candidate',
                  description: 'Người tìm việc',
                ),
        accountStatus: AccountStatus.Active.name,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Lưu vào Firestore bằng ID cụ thể (quan trọng)
      await _userCollection.addUser(userAccount);
      print(
        "Đã lưu thông tin người dùng vào Firestore: ${userAccount.toJson()}",
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng ký thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        // Điều hướng đến màn hình chính hoặc login thành công
        goToLoginSuccess(context);
      }
    } catch (e) {
      print("Lỗi lưu Firestore khi hoàn tất Facebook Sign Up: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi lưu thông tin: ${e.toString()}'),
            backgroundColor: Colors.red,
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
}
