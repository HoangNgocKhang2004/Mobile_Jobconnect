import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_connect/core/models/job_application_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:job_connect/core/constant/apiconstant.dart';

class JobApplicationService {
  final http.Client _client;

  JobApplicationService([http.Client? client]) : _client = client ?? http.Client();

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) throw Exception('Chưa có token.');
    return token;
  }

  /// GET /api/JobApplication
  Future<List<JobApplication>> fetchAllApplications() async {
    final token = await _getToken();
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.jobApplicationEndpoint}');
    final resp = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (resp.statusCode == 200) {
      final List data = jsonDecode(resp.body);
      return data.map((e) => JobApplication.fromJson(e)).toList();
    }
    throw Exception(
        'Lấy tất cả job applications thất bại: [${resp.statusCode}] ${resp.body}');
  }

  /// GET /api/JobApplication/user/{idUser}
  Future<List<JobApplication>> fetchByUser(String idUser) async {
    final token = await _getToken();
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.jobApplicationEndpoint}/user/$idUser',
    );
    final resp = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (resp.statusCode == 200) {
      final List data = jsonDecode(resp.body);
      return data.map((e) => JobApplication.fromJson(e)).toList();
    } else if (resp.statusCode == 404) {
      return [];
    }
    throw Exception(
        'Lấy job applications theo user thất bại: [${resp.statusCode}] ${resp.body}');
  }

  /// GET /api/JobApplication/{jobPost}/{user}
  Future<JobApplication?> fetchByKey(String jobPostId, String userId) async {
    final token = await _getToken();
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.jobApplicationEndpoint}/$jobPostId/$userId',
    );
    final resp = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (resp.statusCode == 200) {
      return JobApplication.fromJson(jsonDecode(resp.body));
    } else if (resp.statusCode == 404) {
      return null;
    }
    throw Exception(
        'Lấy job application thất bại: [${resp.statusCode}] ${resp.body}');
  }

  /// GET /api/JobApplication/jobposting/{jobPostId}
  Future<List<JobApplication>> fetchByJob(String jobPostId) async {
    final token = await _getToken();
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.jobApplicationEndpoint}/jobposting/$jobPostId',
    );
    final resp = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (resp.statusCode == 200) {
      final List data = jsonDecode(resp.body);
      return data.map((e) => JobApplication.fromJson(e)).toList();
    } else if (resp.statusCode == 404) {
      return [];
    }
    throw Exception(
        'Lấy job applications theo job thất bại: [${resp.statusCode}] ${resp.body}');
  }

  /// POST /api/JobApplication
  Future<JobApplication> createApplication(JobApplication app) async {
    final token = await _getToken();
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.jobApplicationEndpoint}');
    final bodyJson = jsonEncode(app.toJson());
    final resp = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: bodyJson,
    );
    if (resp.statusCode == 201 || resp.statusCode == 200) {
      return JobApplication.fromJson(jsonDecode(resp.body));
    }
    throw Exception(
        'Tạo job application thất bại: [${resp.statusCode}] ${resp.body}');
  }

  /// PUT /api/JobApplication/{jobPost}/{user}
  Future<void> updateApplication(JobApplication app) async {
    final token = await _getToken();
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.jobApplicationEndpoint}/${app.idJobPost}/${app.idUser}',
    );
    // Khi cập nhật, chỉ gửi những trường có thể thay đổi (cvFileUrl, coverLetter, applicationStatus)
    final bodyJson = jsonEncode({
      'cvFileUrl': app.cvFileUrl,
      'coverLetter': app.coverLetter,
      'applicationStatus': app.applicationStatus,
    });
    final resp = await _client.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: bodyJson,
    );
    if (resp.statusCode != 204 && resp.statusCode != 200) {
      throw Exception(
          'Cập nhật job application thất bại: [${resp.statusCode}] ${resp.body}');
    }
  }

  /// DELETE /api/JobApplication/{jobPost}/{user}
  Future<void> deleteApplication(String jobPostId, String userId) async {
    final token = await _getToken();
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.jobApplicationEndpoint}/$jobPostId/$userId',
    );
    final resp = await _client.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (resp.statusCode != 204 && resp.statusCode != 200) {
      throw Exception(
          'Xóa job application thất bại: [${resp.statusCode}] ${resp.body}');
    }
  }

  /// PUT /api/JobApplication/{jobPost}/{user}/status
  /// Chỉ thay đổi field applicationStatus
  Future<void> updateApplicationStatus({
    required String jobPostId,
    required String userId,
    required String newStatus,
  }) async {
    final token = await _getToken();
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.jobApplicationEndpoint}/$jobPostId/$userId/status',
    );
    final bodyJson = jsonEncode({
      'applicationStatus': newStatus,
    });
    final resp = await _client.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: bodyJson,
    );
    if (resp.statusCode != 204 && resp.statusCode != 200) {
      throw Exception(
          'Cập nhật trạng thái ứng tuyển thất bại: [${resp.statusCode}] ${resp.body}');
    }
  }
}
