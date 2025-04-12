// Quản lý hồ sơ ứng viên
class ResumeModel {
  String idResume; //Mã hồ sơ - IDR001
  String idUser; //Mã ứng viên
  String experience; //Kinh nghiệm
  String education; //Trình độ
  List<String> skills; //Danh sách kĩ năng
  String? portfolio; // Có thể null
  DateTime createdAt; // Thời gian tạo hồ sơ
  DateTime updatedAt; // Thời gian cập nhật hồ sơ

  // Constructor với các tham số required
  ResumeModel({
    required this.idResume,
    required this.idUser,
    required this.experience,
    required this.education,
    required this.skills,
    this.portfolio,
    required this.createdAt,
    required this.updatedAt,
  })  : assert(idResume.isNotEmpty, 'idResume must not be empty'),
        assert(idUser.isNotEmpty, 'idUser must not be empty');

  // Factory constructor từ Map
  factory ResumeModel.fromMap(Map<String, dynamic> map) {
    final skillsData = map['skills'];
    return ResumeModel(
      idResume: map['idResume'] as String? ?? 'IDR000',
      idUser: map['idUser'] as String? ?? 'IDU000',
      experience: map['experience'] as String? ?? 'Unknown',
      education: map['education'] as String? ?? 'Unknown',
      skills: skillsData is List<dynamic>
          ? skillsData.map((e) => e is String ? e : '').toList()
          : [],
      portfolio: map['portfolio'] as String?,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime(1970, 1, 1),
      updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? '') ?? DateTime(1970, 1, 1),
    );
  }

  // Chuyển đổi sang Map
  Map<String, dynamic> toMap() {
    return {
      'idResume': idResume,
      'idUser': idUser,
      'experience': experience,
      'education': education,
      'skills': skills,
      'portfolio': portfolio,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Override toString để dễ debug
  @override
  String toString() {
    return 'ResumeModel(idResume: $idResume, idUser: $idUser, experience: $experience, '
        'education: $education, skills: $skills, portfolio: $portfolio, '
        'createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}