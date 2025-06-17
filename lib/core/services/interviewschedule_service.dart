import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:job_connect/core/constant/apiconstant.dart';
import 'package:job_connect/core/models/interview_schedule_model.dart';

class InterviewScheduleService {
  final _client = http.Client();

  /// Lấy tất cả lịch phỏng vấn
  Future<List<InterviewSchedule>> fetchInterviewScheduleAll() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception('Chưa có token, vui lòng đăng nhập lại.');
    }

    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.interviewScheduleEndpoint}');

    final resp = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      final List<dynamic> list = jsonDecode(resp.body);
      return list.map((e) => InterviewSchedule.fromJson(e)).toList();
    } else {
      throw Exception('Lỗi khi lấy danh sách lịch phỏng vấn: [${resp.statusCode}] ${resp.body}');
    }
  }

  /// Lấy lịch phỏng vấn theo ID lịch
  Future<InterviewSchedule> fetchInterviewScheduleById(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception('Chưa có token, vui lòng đăng nhập lại.');
    }

    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.interviewScheduleEndpoint}/$id');

    final resp = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      return InterviewSchedule.fromJson(data);
    } else if (resp.statusCode == 404) {
      throw Exception('Không tìm thấy lịch phỏng vấn với ID: $id');
    } else {
      throw Exception('Lỗi khi lấy lịch phỏng vấn: [${resp.statusCode}] ${resp.body}');
    }
  }

  /// Lấy lịch phỏng vấn theo ID bài tuyển dụng (idJobPost)
  Future<List<InterviewSchedule>> fetchInterviewScheduleByJobId(String jobId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception('Chưa có token, vui lòng đăng nhập lại.');
    }
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.interviewScheduleEndpoint}/jobposting/$jobId');

    final resp = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      final List<dynamic> list = jsonDecode(resp.body);
      return list.map((e) => InterviewSchedule.fromJson(e)).toList();
    } else if (resp.statusCode == 404) {
      return [];
    } else {
      throw Exception('Lỗi khi lấy lịch theo jobId: [${resp.statusCode}] ${resp.body}');
    }
  }


  /// Tạo mới lịch phỏng vấn
  Future<bool> create(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception('Chưa có token, vui lòng đăng nhập lại.');
    }

    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.interviewScheduleEndpoint}');

    final resp = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    return resp.statusCode == 201;
  }

  /// Cập nhật lịch phỏng vấn
  Future<bool> update(String id, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception('Chưa có token, vui lòng đăng nhập lại.');
    }

    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.interviewScheduleEndpoint}/$id');

    final resp = await _client.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    return resp.statusCode == 204;
  }

  /// Xoá lịch phỏng vấn
  Future<bool> delete(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception('Chưa có token, vui lòng đăng nhập lại.');
    }

    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.interviewScheduleEndpoint}/$id');

    final resp = await _client.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return resp.statusCode == 204;
  }
}
