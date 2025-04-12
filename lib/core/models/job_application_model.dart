// JobApplication - Ứng tuyển công việc
class JobApplication {
  String idJobApp; // ID ứng tuyển - IDJA001
  String idJobPost; // ID bài đăng tuyển dụng
  String idUser; // ID ứng viên
  JobApplicationStatus jobApplicationStatus; // Trạng thái ứng tuyển
  DateTime submittedAt; // Thời gian gửi hồ sơ ứng tuyển
  DateTime updatedAt; // Thời gian cập nhật ứng tuyển

  // Constructor với các tham số required
  JobApplication({
    required this.idJobApp,
    required this.idJobPost,
    required this.idUser,
    required this.jobApplicationStatus,
    required this.submittedAt,
    required this.updatedAt,
  })  : assert(idJobApp.isNotEmpty, 'idJobApp must not be empty'),
        assert(idJobPost.isNotEmpty, 'idJobPost must not be empty'),
        assert(idUser.isNotEmpty, 'idUser must not be empty');

  // Factory constructor từ Map
  factory JobApplication.fromMap(Map<String, dynamic> map) {
    return JobApplication(
      idJobApp: map['idJobApp'] as String? ?? 'IDJA000',
      idJobPost: map['idJobPost'] as String? ?? 'IDJPP000',
      idUser: map['idUser'] as String? ?? 'IDU000',
      jobApplicationStatus: _parseJobApplicationStatus(map['jobApplicationStatus']),
      submittedAt: DateTime.tryParse(map['submittedAt'] as String? ?? '') ?? DateTime(1970, 1, 1),
      updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? '') ?? DateTime(1970, 1, 1),
    );
  }

  // Chuyển đổi sang Map
  Map<String, dynamic> toMap() {
    return {
      'idJobApp': idJobApp,
      'idJobPost': idJobPost,
      'idUser': idUser,
      'jobApplicationStatus': jobApplicationStatus.name,
      'submittedAt': submittedAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Hàm phụ trợ để parse JobApplicationStatus
  static JobApplicationStatus _parseJobApplicationStatus(dynamic value) {
    if (value is String) {
      return JobApplicationStatus.values.firstWhere(
        (e) => e.name == value,
        orElse: () => JobApplicationStatus.Unknown,
      );
    }
    return JobApplicationStatus.Unknown; // Bỏ logic parse int nếu không cần
  }

  // Override toString để dễ debug
  @override
  String toString() {
    return 'JobApplication(idJobApp: $idJobApp, idJobPost: $idJobPost, idUser: $idUser, '
        'jobApplicationStatus: $jobApplicationStatus, submittedAt: $submittedAt, updatedAt: $updatedAt)';
  }
}

// Enum cho trạng thái ứng tuyển
enum JobApplicationStatus { Submitted, Interviewed, Pass, Fail, Unknown }
//Submitted: chấp nhận
//Interviewed: phỏng vấn
//Pass: đậu 
//Fail: rớt