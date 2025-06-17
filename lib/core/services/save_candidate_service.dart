import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_connect/core/constant/apiconstant.dart';
import 'package:job_connect/core/models/save_candidate_model.dart';

class SaveCandidateService {
  final String baseUrl = ApiConstants.baseUrl;            
  static const String _path = ApiConstants.saveCandidateEndpoint; 
  // GET: Lấy tất cả, rồi client-side lọc theo recruiterId
  Future<List<SaveCandidate>> getSavedCandidates(String recruiterId) async {
    final url = Uri.parse('$baseUrl$_path');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      // lọc ra những bản ghi của recruiterId này
      return data
          .map((j) => SaveCandidate.fromJson(j))
          .where((sc) => sc.idUserRecruiter == recruiterId)
          .toList();
    } else {
      throw Exception('Lỗi khi lấy danh sách đã lưu: ${response.statusCode}');
    }
  }

  // POST: Tạo mới
  Future<void> saveCandidate(SaveCandidate candidate) async {
    final url = Uri.parse('$baseUrl$_path');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(candidate.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Lỗi khi lưu ứng viên: ${response.statusCode}');
    }
  }

  // PUT: Cập nhật Note (nếu cần)
  Future<void> updateCandidate(SaveCandidate candidate) async {
    final url = Uri.parse('$baseUrl$_path/'
        '${candidate.idUserRecruiter}/${candidate.idUserCandidate}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(candidate.toJson()),
    );

    if (response.statusCode != 204) {
      // controller trả NoContent (204) khi thành công
      throw Exception('Lỗi khi cập nhật ứng viên: ${response.statusCode}');
    }
  }

  // DELETE: Xóa theo path parameters
  Future<void> deleteCandidate(String recruiterId, String candidateId) async {
    final url = Uri.parse('$baseUrl$_path/$recruiterId/$candidateId');
    final response = await http.delete(url);

    if (response.statusCode != 204) {
      throw Exception('Lỗi khi xóa ứng viên: ${response.statusCode}');
    }
  }
}
