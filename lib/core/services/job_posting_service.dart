import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_connect/core/models/job_posting_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:job_connect/core/constant/apiconstant.dart';

class JobPostingService {
  final _client = http.Client();

  // Lấy thông tin job đã đăng của công ty
  Future<List<JobPosting>> fetchJobPostingsByCompanyId(String companyId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) throw Exception('Chưa có token.');

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}'
      '${ApiConstants.jobPostingEndpoint}/company/$companyId',
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
      return data.map((e) => JobPosting.fromJson(e)).toList();
    }
    throw Exception('Lấy job postings thất bại: [${resp.statusCode}] ${resp.body}');
  }

  // Lấy thông tin job đã đăng theo id
  Future<JobPosting> fetchJobPostingById(String jobId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) {
      throw Exception('Chưa có token, vui lòng đăng nhập lại.');
    }

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.jobPostingEndpoint}/$jobId',
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
      return JobPosting.fromJson(data);
    } else if (resp.statusCode == 404) {
      throw Exception('Không tìm thấy job posting với id: $jobId');
    } else {
      throw Exception(
        'Lấy thông tin job posting thất bại: [${resp.statusCode}] ${resp.body}',
      );
    }
  }

  // Đăng tin tuyển dụng
  Future<JobPosting> createJobPosting(JobPosting jobPosting) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) {
      throw Exception('Chưa có token, vui lòng đăng nhập lại.');
    }

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.jobPostingEndpoint}/simple',
    );
    final resp = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(jobPosting.toJson()),
    );

    if (resp.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(resp.body);
      return JobPosting.fromJson(data);
    } else {
      throw Exception(
        'Đăng tin tuyển dụng thất bại: [${resp.statusCode}] ${resp.body}',
      );
    }
  }

  // Cập nhật thông tin job đã đăng
  Future<JobPosting> updateJobPosting(JobPosting jobPosting) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) {
      throw Exception('Chưa có token, vui lòng đăng nhập lại.');
    }

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.jobPostingEndpoint}/${jobPosting.idJobPost}',
    );
    final resp = await _client.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(jobPosting.toJson()),
    );

    if (resp.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(resp.body);
      return JobPosting.fromJson(data);
    } else {
      throw Exception(
        'Cập nhật thông tin job posting thất bại: [${resp.statusCode}] ${resp.body}',
      );
    }
  }

  // Xóa job đã đăng
  Future<void> deleteJobPosting(String jobId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) {
      throw Exception('Chưa có token, vui lòng đăng nhập lại.');
    }

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.jobPostingEndpoint}/$jobId',
    );
    final resp = await _client.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode != 204) {
      throw Exception(
        'Xóa job posting thất bại: [${resp.statusCode}] ${resp.body}',
      );
    }
  }
    // Cập nhật trạng thái bài đăng (open, closed, waiting, editing)
  Future<void> updateJobStatus(String jobId, String status) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) {
      throw Exception('Chưa có token, vui lòng đăng nhập lại.');
    }

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.jobPostingEndpoint}/$jobId/status',
    );

    final resp = await _client.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'status': status}),
    );

    if (resp.statusCode != 204) {
      final error = jsonDecode(resp.body);
      throw Exception(error['message'] ?? 'Cập nhật trạng thái thất bại.');
    }
  }

}