import 'package:http/http.dart' as http;
import 'package:job_connect/core/constant/apiconstant.dart';
import 'dart:convert';
import 'package:job_connect/core/models/account_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountService {
  // Lấy thông tin Account dựa trên idUser
  Future<Account> fetchAccountById(String idUser) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.userEndpoint}/$idUser'),
        headers: {
          'Content-Type': 'application/json',
          // Thêm header xác thực nếu cần, ví dụ: 'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return Account.fromJson(jsonData);
      } else {
        throw Exception('Không thể lấy thông tin tài khoản: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi gọi API lấy tài khoản: $e');
    }
  }

  // Lấy danh sách tất cả Account (nếu cần)
  Future<List<Account>> fetchAllAccounts() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.userEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => Account.fromJson(json)).toList();
      } else {
        throw Exception('Không thể lấy danh sách tài khoản: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi gọi API lấy danh sách tài khoản: $e');
    }
  }

  // Cập nhật thông tin tài khoản
  Future<void> updateAccount(Account account) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) throw Exception('Chưa có token.');

    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.userEndpoint}/${account.idUser}');
    final resp = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(account.toJson()),
    );

    if (resp.statusCode != 200 && resp.statusCode != 204) {
      print('PUT $uri → ${resp.statusCode}: ${resp.body}');
      throw Exception('Không thể cập nhật tài khoản: ${resp.statusCode}');
    }
  }

}