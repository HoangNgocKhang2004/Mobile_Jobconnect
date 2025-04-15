// Quản lý đơn ứng tuyển của ứng viên
// Chức năng: Nộp đơn ứng tuyển, theo dõi trạng thái đơn, lưu CV và thư xin việc
class JobApplicationModel {
  String idJobApp; // Mã đơn ứng tuyển, ví dụ: IDJA001
  String idJobPost; // Mã bài đăng tuyển dụng, ví dụ: IDJP001
  String idUser; // Mã ứng viên, ví dụ: IDU001
  String? cvFileUrl; // URL tệp CV, ví dụ: "cv.pdf", có thể null
  String? coverLetter; // Thư xin việc, có thể null
  double? suitabilityScore; // Điểm phù hợp do AI tính, ví dụ: 90.0, có thể null
  JobApplicationStatus jobApplicationStatus; // Trạng thái: pending, viewed, interview, accepted, rejected
  DateTime submittedAt; // Thời gian nộp đơn
  DateTime updatedAt; // Thời gian cập nhật trạng thái

  JobApplicationModel({
    required this.idJobApp,
    required this.idJobPost,
    required this.idUser,
    this.cvFileUrl,
    this.coverLetter,
    this.suitabilityScore,
    required this.jobApplicationStatus,
    required this.submittedAt,
    required this.updatedAt,
  });

  factory JobApplicationModel.fromMap(Map<String, dynamic> map) {
    return JobApplicationModel(
      idJobApp: map['idJobApp'] as String,
      idJobPost: map['idJobPost'] as String,
      idUser: map['idUser'] as String,
      cvFileUrl: map['cvFileUrl'] as String?,
      coverLetter: map['coverLetter'] as String?,
      suitabilityScore: (map['suitabilityScore'] as num?)?.toDouble(),
      jobApplicationStatus: JobApplicationStatus.values.firstWhere((e) => e.toString() == 'JobApplicationStatus.${map['jobApplicationStatus']}'),
      submittedAt: DateTime.parse(map['submittedAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idJobApp': idJobApp,
      'idJobPost': idJobPost,
      'idUser': idUser,
      'cvFileUrl': cvFileUrl,
      'coverLetter': coverLetter,
      'suitabilityScore': suitabilityScore,
      'jobApplicationStatus': jobApplicationStatus.toString().split('.').last,
      'submittedAt': submittedAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'JobApplicationModel(idJobApp: $idJobApp, idJobPost: $idJobPost, idUser: $idUser, jobApplicationStatus: $jobApplicationStatus)';
  }
}

enum JobApplicationStatus { pending, viewed, interview, accepted, rejected }