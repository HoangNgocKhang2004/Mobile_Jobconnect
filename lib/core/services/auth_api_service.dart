import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_connect/core/constant/apiconstant.dart';
import 'package:job_connect/core/models/auth_login_dto.dart';
import 'package:job_connect/core/models/auth_register_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth_response.dart';

class AuthAPIService {
  final _client = http.Client();
  static const _keyToken    = 'jwt_token';
  static const _keyLoggedIn = 'is_logged_in';

  /// Đăng ký người dùng mới
  Future<void> register(RegisterDto dto) async {
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.registerEndpoint);
    final resp = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );

    if (resp.statusCode != 200) {
      throw Exception('Đăng ký thất bại: ${resp.body}');
    }
  }

  /// Đăng nhập, trả về AuthResponse và lưu token + isLoggedIn
  Future<AuthResponse> login(LoginDto dto) async {
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.loginEndpoint);
    final resp = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );

    print('🔐 Login request to $uri');
    print('📥 Status: ${resp.statusCode}');
    print('📥 Body: ${resp.body}');

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      final auth = AuthResponse.fromJson(data);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyToken, auth.token);
      await prefs.setBool(_keyLoggedIn, true);

      return auth;
    } else {
      throw Exception('Đăng nhập thất bại: ${resp.body}');
    }
  }

  /// Đăng xuất: xóa token và đánh dấu không còn đăng nhập
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.setBool(_keyLoggedIn, false);
  }

  /// Kiểm tra xem user đã login chưa
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  /// Lấy JWT token đã lưu
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }
}