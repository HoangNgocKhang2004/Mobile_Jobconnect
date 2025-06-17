import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_connect/features/auth/controllers/auth_service.dart';

class PhoneLoginScreen extends StatefulWidget {
  final void Function(User? user)? onLoginSuccess;

  PhoneLoginScreen({Key? key, this.onLoginSuccess}) : super(key: key);

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedCountryCode = '+84';
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final AuthService _auth = AuthService();

  bool _otpSent = false;
  String? _verificationId;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final phone = _selectedCountryCode + _phoneController.text.trim();
      await _auth.authPhone(
        phoneNumber: phone,
        onCodeSent: (String verificationId, int? resendToken) {
          setState(() {
            _otpSent = true;
            _verificationId = verificationId;
            _isLoading = false;
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('OTP sent to $phone')));
        },
        onVerificationCompleted: (PhoneAuthCredential credential) async {
          try {
            final userCredential = await FirebaseAuth.instance
                .signInWithCredential(credential);
            widget.onLoginSuccess?.call(userCredential.user);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Auto verification failed: $e')),
            );
          } finally {
            setState(() => _isLoading = false);
          }
        },
        onVerificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed: ${e.message}')),
          );
          setState(() => _isLoading = false);
        },
        onCodeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
            _isLoading = false;
          });
        },
      );
    }
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Vui lòng nhập mã OTP')));
      return;
    }
    if (_verificationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không tìm thấy mã xác thực. Vui lòng thử lại.'),
        ),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      final userCredential = await _auth.authPhone(
        phoneNumber: _selectedCountryCode + _phoneController.text.trim(),
        smsCode: otp,
        onCodeSent: (String verificationId, int? resendToken) {},
        onVerificationCompleted: (PhoneAuthCredential credential) {},
        onVerificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Xác thực OTP thất bại: ${e.message}')),
          );
        },
        onCodeAutoRetrievalTimeout: (String verificationId) {},
      );
      if (userCredential != null) {
        widget.onLoginSuccess?.call(userCredential.user);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Xác thực OTP thất bại')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Xác thực OTP thất bại: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Login')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_otpSent) ...[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Row(
                    children: [
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
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child:
                      _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Gửi OTP'),
                ),
              ] else ...[
                TextFormField(
                  controller: _otpController,
                  decoration: const InputDecoration(labelText: 'Nhập mã OTP'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOtp,
                  child:
                      _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Xác thực OTP'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
