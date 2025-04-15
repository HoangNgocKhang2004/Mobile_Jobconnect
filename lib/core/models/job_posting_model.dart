// Quản lý bài đăng tuyển dụng từ nhà tuyển dụng
// Chức năng: Tạo/quản lý bài đăng, tìm kiếm công việc, hiển thị chi tiết công việc, gợi ý công việc
import 'package:job_connect/core/models/company_model.dart';

class JobPostingModel {
  String idJobPost; // Mã bài đăng, ví dụ: IDJP001
  String title; // Tiêu đề, ví dụ: "Lập trình viên Java"
  String description; // Mô tả công việc
  String requirements; // Yêu cầu công việc
  List<String> requiredSkills; // Kỹ năng yêu cầu, ví dụ: ["Java", "Spring"]
  double? salary; // Mức lương, ví dụ: 2000.0, có thể null
  String location; // Địa điểm làm việc, ví dụ: "Hà Nội"
  JobType jobType; // Loại công việc: full_time, part_time, contract, internship
  ExperienceLevel experienceLevel; // Cấp độ kinh nghiệm: junior, mid, senior
  CompanyModel company; // Thông tin công ty đăng tuyển
  DateTime createdAt; // Thời gian tạo bài đăng
  DateTime updatedAt; // Thời gian cập nhật bài đăng
  JobPostStatus jobPostStatus; // Trạng thái bài đăng: open, closed, draft

  JobPostingModel({
    required this.idJobPost,
    required this.title,
    required this.description,
    required this.requirements,
    required this.requiredSkills,
    this.salary,
    required this.location,
    required this.jobType,
    required this.experienceLevel,
    required this.company,
    required this.createdAt,
    required this.updatedAt,
    required this.jobPostStatus,
  });

  factory JobPostingModel.fromMap(Map<String, dynamic> map) {
    return JobPostingModel(
      idJobPost: map['idJobPost'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      requirements: map['requirements'] as String,
      requiredSkills: (map['requiredSkills'] as List<dynamic>).cast<String>(),
      salary: (map['salary'] as num?)?.toDouble(),
      location: map['location'] as String,
      jobType: JobType.values.firstWhere((e) => e.toString() == 'JobType.${map['jobType']}'),
      experienceLevel: ExperienceLevel.values.firstWhere((e) => e.toString() == 'ExperienceLevel.${map['experienceLevel']}'),
      company: CompanyModel.fromMap(map['company'] as Map<String, dynamic>),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      jobPostStatus: JobPostStatus.values.firstWhere((e) => e.toString() == 'JobPostStatus.${map['jobPostStatus']}'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idJobPost': idJobPost,
      'title': title,
      'description': description,
      'requirements': requirements,
      'requiredSkills': requiredSkills,
      'salary': salary,
      'location': location,
      'jobType': jobType.toString().split('.').last,
      'experienceLevel': experienceLevel.toString().split('.').last,
      'company': company.toMap(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'jobPostStatus': jobPostStatus.toString().split('.').last,
    };
  }

  @override
  String toString() {
    return 'JobPostingModel(idJobPost: $idJobPost, title: $title, jobType: $jobType, jobPostStatus: $jobPostStatus)';
  }
}

enum JobType { full_time, part_time, contract, internship }
enum ExperienceLevel { junior, mid, senior }
enum JobPostStatus { open, closed, draft }