import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:job_connect/core/constant/apiconstant.dart';
import 'package:job_connect/core/models/bank_model.dart';

class BankService {
  final _client = http.Client();

  /// Lấy tất cả tài khoản ngân hàng
  Future<List<Bank>> fetchAll() async {
    final token = await _getToken();
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.bankEndpoint}');

    final resp = await _client.get(
      uri,
      headers: _headers(token),
    );

    if (resp.statusCode == 200) {
      final List<dynamic> list = jsonDecode(resp.body);
      return list.map((e) => Bank.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Lỗi khi lấy danh sách ngân hàng: [${resp.statusCode}] ${resp.body}');
    }
  }

  /// Lấy tài khoản ngân hàng theo bankId
  Future<Bank> fetchByBankId(String bankId) async {
    final token = await _getToken();
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.bankEndpoint}/$bankId');

    final resp = await _client.get(
      uri,
      headers: _headers(token),
    );

    if (resp.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(resp.body);
      return Bank.fromJson(data);
    } else if (resp.statusCode == 404) {
      throw Exception('Không tìm thấy tài khoản ngân hàng với id: $bankId');
    } else {
      throw Exception('Lỗi khi lấy tài khoản ngân hàng theo id: [${resp.statusCode}] ${resp.body}');
    }
  }

  /// Lấy tài khoản ngân hàng theo UserId
  Future<List<Bank>> fetchByUserId(String userId) async {
    final token = await _getToken();
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.bankEndpoint}/user/$userId');

    final resp = await _client.get(
      uri,
      headers: _headers(token),
    );

    if (resp.statusCode == 200) {
      final List<dynamic> list = jsonDecode(resp.body);
      return list.map((e) => Bank.fromJson(e as Map<String, dynamic>)).toList();
    } else if (resp.statusCode == 404) {
      throw Exception('Không tìm thấy tài khoản ngân hàng cho userId: $userId');
    } else {
      throw Exception('Lỗi khi lấy thông tin ngân hàng: [${resp.statusCode}] ${resp.body}');
    }
  }

  /// Tạo tài khoản ngân hàng mới
  Future<void> createBank(Bank bank) async {
    final token = await _getToken();
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.bankEndpoint}');

    final resp = await _client.post(
      uri,
      headers: _headers(token),
      body: jsonEncode({
        // Vì CreateBankDto không có bankId
        'bankName': bank.bankName,
        'bankCode': bank.bankCode,
        'balance': bank.balance,
        'cardNumber': bank.cardNumber,
        'accountType': bank.accountType,
        'cardType': bank.cardType,
        'isDefault': bank.isDefault ? 1 : 0,
        'imageUrl': bank.imageUrl,
        'userId': bank.userId,
      }),
    );

    if (resp.statusCode != 201) {
      throw Exception('Tạo tài khoản ngân hàng thất bại: [${resp.statusCode}] ${resp.body}');
    }
  }

  /// Cập nhật thông tin tài khoản ngân hàng
  Future<void> updateBank(String bankId, Bank updatedBank) async {
    final token = await _getToken();
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.bankEndpoint}/$bankId');

    final resp = await _client.put(
      uri,
      headers: _headers(token),
      body: jsonEncode({
        // Các trường cho UpdateBankDto
        'bankName': updatedBank.bankName,
        'bankCode': updatedBank.bankCode,
        'balance': updatedBank.balance,
        'cardNumber': updatedBank.cardNumber,
        'accountType': updatedBank.accountType,
        'cardType': updatedBank.cardType,
        'isDefault': updatedBank.isDefault ? 1 : 0,
        'imageUrl': updatedBank.imageUrl,
      }),
    );

    if (resp.statusCode != 204) {
      throw Exception('Cập nhật tài khoản ngân hàng thất bại: [${resp.statusCode}] ${resp.body}');
    }
  }

  /// Cập nhật số dư mới cho bankId
  static Future<bool> updateBankBalance(String bankId, double newBalance) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.bankEndpoint}/$bankId/balance');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'balance': newBalance}),
    );

    if (response.statusCode == 200) {
      print('Cập nhật số dư thành công.');
      return true;
    } else {
      print('Cập nhật số dư thất bại: ${response.body}');
      return false;
    }
  }

  /// Lấy JWT token từ SharedPreferences
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) throw Exception('Chưa có token, vui lòng đăng nhập lại.');
    return token;
  }

  /// Header mặc định cho API gọi có JWT
  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
}
