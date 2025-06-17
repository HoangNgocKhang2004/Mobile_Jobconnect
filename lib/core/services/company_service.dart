import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:job_connect/core/constant/apiconstant.dart';
import 'package:job_connect/core/models/company_model.dart';


class CompanyService {
  final _client = http.Client(); 

  // Lấy danh sách tất cả công ty
  Future<List<Company>> fetchAll() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) {
      throw Exception('Chưa có token, vui lòng đăng nhập lại.');
    }

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.companyEndpoint}',
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
      return list.map((e) => Company.fromJson(e)).toList();
    } else {
      throw Exception(
        'Lỗi khi lấy danh sách công ty: [${resp.statusCode}] ${resp.body}',
      );
    }
  }

  // Lấy thông tin công ty theo ID
  Future<Company> fetchCompanyById(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) {
      throw Exception('Chưa có token, vui lòng đăng nhập lại.');
    }

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.companyEndpoint}/$id',
    );

    final resp = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      return Company.fromJson(jsonDecode(resp.body));
    } else {
      throw Exception('Lỗi khi lấy thông tin công ty: [${resp.statusCode}] ${resp.body}');
    }
  }

  Future<Company> updateCompany(Company company) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) {
      throw Exception('Chưa có token, vui lòng đăng nhập lại.');
    }

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.companyEndpoint}/${company.idCompany}',
    );

    final resp = await _client.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(company.toJson()),
    );

    if (resp.statusCode == 200) {
      // Thành công, server trả về JSON Company
      return Company.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
    } else if (resp.statusCode == 204) {
      // Thành công nhưng không trả body
      return company;
    } else {
      throw Exception('Lỗi khi cập nhật thông tin công ty: [${resp.statusCode}] ${resp.body}');
    }
  }

}