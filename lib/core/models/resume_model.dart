// Model for resumes table
class Resume {
  final String idResume;
  final String idUser;
  final String experience;
  final String education;
  final String? portfolio;
  final String? cvFileUrl;
  final bool isPublic;
  final double? suitabilityScore;
  final String? preferredJobType;
  final double? salaryExpectation;
  final DateTime createdAt;
  final DateTime updatedAt;

  Resume({
    required this.idResume,
    required this.idUser,
    required this.experience,
    required this.education,
    this.portfolio,
    this.cvFileUrl,
    required this.isPublic,
    this.suitabilityScore,
    this.preferredJobType,
    this.salaryExpectation,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'idResume': idResume,
      'idUser': idUser,
      'experience': experience,
      'education': education,
      'portfolio': portfolio,
      'cvFileUrl': cvFileUrl,
      'isPublic': isPublic,
      'suitabilityScore': suitabilityScore,
      'preferredJobType': preferredJobType,
      'salaryExpectation': salaryExpectation,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Resume.fromJson(Map<String, dynamic> json) {
    return Resume(
      idResume: json['idResume'] as String,
      idUser: json['idUser'] as String,
      experience: json['experience'] as String,
      education: json['education'] as String,
      portfolio: json['portfolio'] as String?,
      cvFileUrl: json['cvFileUrl'] as String?,
      isPublic: json['isPublic'] as bool,
      suitabilityScore: (json['suitabilityScore'] as num?)?.toDouble(),
      preferredJobType: json['preferredJobType'] as String?,
      salaryExpectation: (json['salaryExpectation'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  String toString() {
    return 'Resume(idResume: $idResume, idUser: $idUser, isPublic: $isPublic)';
  }
}