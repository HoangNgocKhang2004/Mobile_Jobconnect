// Quản lý hồ sơ cá nhân của ứng viên
// Chức năng: Tạo/chỉnh sửa hồ sơ, tải CV/chứng chỉ, cài đặt hiển thị hồ sơ, ứng tuyển công việc
class ResumeModel {
  String idResume; // Mã hồ sơ, ví dụ: IDR001
  String idUser; // Mã người dùng sở hữu hồ sơ, ví dụ: IDU001
  String experience; // Kinh nghiệm làm việc, ví dụ: "2 năm lập trình viên"
  String education; // Trình độ học vấn, ví dụ: "Cử nhân CNTT"
  List<String> skills; // Danh sách kỹ năng, ví dụ: ["Java", "Python"]
  String? portfolio; // Liên kết portfolio, ví dụ: "https://github.com/user", có thể null
  List<String>? certificateUrls; // URL chứng chỉ, ví dụ: ["cert1.pdf"], có thể null
  String? cvFileUrl; // URL tệp CV, ví dụ: "cv.pdf", có thể null
  bool isPublic; // Hồ sơ công khai (true) hay riêng tư (false)
  double? suitabilityScore; // Điểm phù hợp do AI tính, ví dụ: 85.5, có thể null
  DateTime createdAt; // Thời gian tạo hồ sơ
  DateTime updatedAt; // Thời gian cập nhật hồ sơ

  ResumeModel({
    required this.idResume,
    required this.idUser,
    required this.experience,
    required this.education,
    required this.skills,
    this.portfolio,
    this.certificateUrls,
    this.cvFileUrl,
    required this.isPublic,
    this.suitabilityScore,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ResumeModel.fromMap(Map<String, dynamic> map) {
    return ResumeModel(
      idResume: map['idResume'] as String,
      idUser: map['idUser'] as String,
      experience: map['experience'] as String,
      education: map['education'] as String,
      skills: (map['skills'] as List<dynamic>).cast<String>(),
      portfolio: map['portfolio'] as String?,
      certificateUrls: (map['certificateUrls'] as List<dynamic>?)?.cast<String>(),
      cvFileUrl: map['cvFileUrl'] as String?,
      isPublic: map['isPublic'] as bool,
      suitabilityScore: (map['suitabilityScore'] as num?)?.toDouble(),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idResume': idResume,
      'idUser': idUser,
      'experience': experience,
      'education': education,
      'skills': skills,
      'portfolio': portfolio,
      'certificateUrls': certificateUrls,
      'cvFileUrl': cvFileUrl,
      'isPublic': isPublic,
      'suitabilityScore': suitabilityScore,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'ResumeModel(idResume: $idResume, idUser: $idUser, isPublic: $isPublic)';
  }
}