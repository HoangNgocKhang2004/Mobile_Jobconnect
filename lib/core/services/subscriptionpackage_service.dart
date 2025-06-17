import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_connect/core/models/subscription_package_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:job_connect/core/constant/apiconstant.dart';

class SubscriptionpackageService {
  final _client = http.Client();

  // Lấy danh sách gói dịch vụ
  Future<List<SubscriptionPackage>> fetchSubscriptionPackages() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) throw Exception('Chưa có token.');

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.subscriptionPackageEndpoint}',
    );
    final resp = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      final List<dynamic> data = jsonDecode(resp.body);
      return data.map((e) => SubscriptionPackage.fromJson(e)).toList();
    }
    throw Exception('Lấy gói dịch vụ thất bại: [${resp.statusCode}] ${resp.body}');
  }

  // Lấy thông tin gói dịch vụ theo id
  Future<SubscriptionPackage> fetchSubscriptionPackageById(String packageId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) {
      throw Exception('Chưa có token, vui lòng đăng nhập lại.');
    }

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.subscriptionPackageEndpoint}/$packageId',
    );
    final resp = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(resp.body);
      return SubscriptionPackage.fromJson(data);
    } else if (resp.statusCode == 404) {
      throw Exception('Không tìm thấy gói dịch vụ với id: $packageId');
    } else {
      throw Exception('Lấy gói dịch vụ thất bại: [${resp.statusCode}] ${resp.body}');
    }
  }
  /// Kích hoạt gói sau khi đã quét mã thành công
  Future<bool> activatePackage({ required String packageId, required String transactionCode}) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.subscriptionPackageEndpoint}/activate',
    );
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'packageId': packageId,
        'transactionCode': transactionCode,
      }),
    );
    return response.statusCode == 200;
  }
}