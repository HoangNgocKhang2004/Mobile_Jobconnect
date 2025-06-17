import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_connect/core/models/job_transaction_detail_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:job_connect/core/constant/apiconstant.dart';

class JobTransactionDetailService {
  final http.Client _client;

  JobTransactionDetailService([http.Client? client]) : _client = client ?? http.Client();

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) throw Exception('Chưa có token, vui lòng đăng nhập lại.');
    return token;
  }

  /// GET /api/JobTransactionDetails/{transactionId}
  Future<JobTransactionDetail> fetchJobTransactionDetail(String transactionId) async {
    final token = await _getToken();
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.jobTransactionDetailEndpoint}/$transactionId',
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
      return JobTransactionDetail.fromJson(data);
    } else if (resp.statusCode == 404) {
      throw Exception('Không tìm thấy giao dịch với id: $transactionId');
    } else {
      throw Exception('Lấy chi tiết giao dịch thất bại: [${resp.statusCode}] ${resp.body}');
    }
  }

  /// POST /api/JobTransactionDetails  (Create or Update)
  Future<JobTransactionDetail> createOrUpdateJobTransactionDetail(JobTransactionDetail transactionDetail) async {
    final token = await _getToken();
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.jobTransactionDetailEndpoint}');
    final bodyJson = jsonEncode(transactionDetail.toJson());

    final resp = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: bodyJson,
    );

    // Nếu server trả về 201 => đã chèn mới thành công
    if (resp.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(resp.body);
      return JobTransactionDetail.fromJson(data);
    }
    // Nếu server trả về 204 => đã cập nhật (update) thành công, không có body
    else if (resp.statusCode == 204) {
      return transactionDetail;
    }
    else {
      throw Exception('Tạo/cập nhật chi tiết giao dịch thất bại: [${resp.statusCode}] ${resp.body}');
    }
  }
}
