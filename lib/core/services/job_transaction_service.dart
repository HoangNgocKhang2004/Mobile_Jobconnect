import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_connect/core/models/job_transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:job_connect/core/constant/apiconstant.dart';

class JobtransactionService {
  final _client = http.Client();

  // Lấy danh sách giao dịch
  Future<List<JobTransaction>> fetchJobTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) throw Exception('Chưa có token.');

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.jobTransactionEndpoint}',
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
      return data.map((e) => JobTransaction.fromJson(e)).toList();
    }
    throw Exception('Lấy giao dịch thất bại: [${resp.statusCode}] ${resp.body}');
  }

  // Lấy thông tin giao dịch theo id
  Future<JobTransaction> fetchJobTransactionById(String transactionId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) {
      throw Exception('Chưa có token, vui lòng đăng nhập lại.');
    }

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.jobTransactionEndpoint}/$transactionId',
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
      return JobTransaction.fromJson(data);
    } else if (resp.statusCode == 404) {
      throw Exception('Không tìm thấy giao dịch với id: $transactionId');
    } else {
      throw Exception('Lấy giao dịch thất bại: [${resp.statusCode}] ${resp.body}');
    }
  }

  // Lấy giao dịch qua idUser
  Future<List<JobTransaction>> fetchJobTransactionsByUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) throw Exception('Chưa có token.');

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.jobTransactionEndpoint}/user/$userId',
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
      return data.map((e) => JobTransaction.fromJson(e)).toList();
    }
    throw Exception('Lấy giao dịch thất bại: [${resp.statusCode}] ${resp.body}');
  }

  // Tạo giao dịch mới
  Future<JobTransaction> createJobTransaction(JobTransaction transaction) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) throw Exception('Chưa có token.');

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.jobTransactionEndpoint}',
    );
    final resp = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(transaction.toJson()),
    );

    if (resp.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(resp.body);
      return JobTransaction.fromJson(data);
    }
    throw Exception('Tạo giao dịch thất bại: [${resp.statusCode}] ${resp.body}');
  }

  // Cập nhật trạng thái giao dịch
  Future<void> updateTransactionStatus(String transactionId, String newStatus) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) throw Exception('Chưa có token.');

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.jobTransactionEndpoint}/$transactionId/status',
    );

    final resp = await _client.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'status': newStatus}),
    );

    if (resp.statusCode != 204) {
      throw Exception('Cập nhật trạng thái thất bại: [${resp.statusCode}] ${resp.body}');
    }
  }

  // Xóa giao dịch
  Future<void> deleteJobTransaction(String transactionId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) throw Exception('Chưa có token.');

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.jobTransactionEndpoint}/$transactionId',
    );

    final resp = await _client.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode != 204) {
      throw Exception('Xóa giao dịch thất bại: [${resp.statusCode}] ${resp.body}');
    }
  }

}