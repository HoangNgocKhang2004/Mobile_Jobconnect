import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:job_connect/core/constant/apiconstant.dart';
import 'package:job_connect/core/models/resume_skill_model.dart';

class ResumeSkillService {
  final _client = http.Client();

  /// Lấy toàn bộ kỹ năng trong hồ sơ, cần truyền token đã lưu
  Future<List<ResumeSkill>> fetchAllSkills() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) {
      throw Exception('Chưa có token, vui lòng đăng nhập lại.');
    }

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.resumeSkillEndpoint}',
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

      // Map mỗi phần tử Map<String,dynamic> thành ResumeSkill
      return data
          .map((e) => ResumeSkill.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (resp.statusCode == 404) {
      // Nếu endpoint của bạn trả 404 khi không có skill nào
      return [];
    } else {
      throw Exception(
        'Lấy thông tin kỹ năng thất bại: [${resp.statusCode}] ${resp.body}',
      );
    }
  }
}
