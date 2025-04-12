// Quản lý bài đăng
import 'package:job_connect/core/models/company_model.dart';

class JobPostingModel {
  String idJobPost;
  String title;
  String description;
  String requirements;
  double? salary; // Có thể null
  String location;
  CompanyModel company; // Tham chiếu đến công ty (thay vì chỉ idCompany)
  DateTime createdAt;
  DateTime updatedAt;
  JobPostStatus jobPostStatus;

  // Constructor với các tham số required
  JobPostingModel({
    required this.idJobPost,
    required this.title,
    required this.description,
    required this.requirements,
    this.salary,
    required this.location,
    required this.company,
    required this.createdAt,
    required this.updatedAt,
    required this.jobPostStatus,
  })  : assert(idJobPost.isNotEmpty, 'idJobPost must not be empty'),
        assert(title.isNotEmpty, 'title must not be empty');

  // Factory constructor từ Map
  factory JobPostingModel.fromMap(Map<String, dynamic> map) {
    return JobPostingModel(
      idJobPost: map['idJobPost'] as String? ?? 'IDJP000',
      title: map['title'] as String? ?? 'Unknown',
      description: map['description'] as String? ?? 'Unknown',
      requirements: map['requirements'] as String? ?? 'Unknown',
      salary: map['salary'] != null ? (map['salary'] as num?)?.toDouble() : null,
      location: map['location'] as String? ?? 'Unknown',
      company: CompanyModel.fromMap(map['company'] as Map<String, dynamic>? ?? {'idCompany': 'IDC000'}),
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime(1970, 1, 1),
      updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? '') ?? DateTime(1970, 1, 1),
      jobPostStatus: _parseJobPostStatus(map['jobPostStatus']),
    );
  }

  // Chuyển đổi sang Map
  Map<String, dynamic> toMap() {
    return {
      'idJobPost': idJobPost,
      'title': title,
      'description': description,
      'requirements': requirements,
      'salary': salary,
      'location': location,
      'company': company.toMap(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'jobPostStatus': jobPostStatus.name,
    };
  }

  // Hàm phụ trợ để parse JobPostStatus
  static JobPostStatus _parseJobPostStatus(dynamic value) {
    if (value is String) {
      return JobPostStatus.values.firstWhere(
        (e) => e.name == value,
        orElse: () => JobPostStatus.Unknown,
      );
    }
    return JobPostStatus.Unknown;
  }

  // Override toString để dễ debug
  @override
  String toString() {
    return 'JobPostingModel(idJobPost: $idJobPost, title: $title, description: $description, '
        'requirements: $requirements, salary: $salary, location: $location, '
        'company: $company, createdAt: $createdAt, updatedAt: $updatedAt, '
        'jobPostStatus: $jobPostStatus)';
  }
}

// Enum cho trạng thái bài đăng
enum JobPostStatus { Active, Inactive, Unknown }
// Active: hoạt động
//Inactive: không hoạt động