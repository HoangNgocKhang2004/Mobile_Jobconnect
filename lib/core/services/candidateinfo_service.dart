import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:job_connect/core/constant/apiconstant.dart';
import 'package:job_connect/core/models/candidate_info_model.dart';

class CandidateInfoService {
  final _client = http.Client();

  // Lấy danh sách tất cả ứng viên
  Future<List<CandidateInfo>> fetchAll() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) {
      throw Exception('Chưa có token, vui lòng đăng nhập lại.');
    }

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.candidateInfoEndpoint}',
    );

    final resp = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      final List<dynamic> list = jsonDecode(resp.body);
      return list.map((e) => CandidateInfo.fromJson(e)).toList();
    } else {
      throw Exception(
        'Lỗi khi lấy danh sách ứng viên: [${resp.statusCode}] ${resp.body}',
      );
    }
  }

  // Lấy thông tin ứng viên theo ID người dùng
  Future<CandidateInfo> fetchByUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) {
      throw Exception('Chưa có token, vui lòng đăng nhập lại.');
    }

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.candidateInfoEndpoint}/$userId',
    );

    final resp = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      return CandidateInfo.fromJson(data);
    } else if (resp.statusCode == 404) {
      throw Exception('Không tìm thấy ứng viên với id: $userId');
    } else {
      throw Exception(
        'Lỗi khi lấy thông tin ứng viên: [${resp.statusCode}] ${resp.body}',
      );
    }
  }
}
