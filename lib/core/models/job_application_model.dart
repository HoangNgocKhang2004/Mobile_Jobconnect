// Model for jobApplication table
class JobApplication {
  final String idJobApp;
  final String idJobPost;
  final String idUser;
  final String? cvFileUrl;
  final String? coverLetter;
  final double? suitabilityScore;
  final String jobApplicationStatus;
  final DateTime submittedAt;
  final DateTime updatedAt;

  JobApplication({
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

  Map<String, dynamic> toJson() {
    return {
      'idJobApp': idJobApp,
      'idJobPost': idJobPost,
      'idUser': idUser,
      'cvFileUrl': cvFileUrl,
      'coverLetter': coverLetter,
      'suitabilityScore': suitabilityScore,
      'jobApplicationStatus': jobApplicationStatus,
      'submittedAt': submittedAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      idJobApp: json['idJobApp'] as String,
      idJobPost: json['idJobPost'] as String,
      idUser: json['idUser'] as String,
      cvFileUrl: json['cvFileUrl'] as String?,
      coverLetter: json['coverLetter'] as String?,
      suitabilityScore: (json['suitabilityScore'] as num?)?.toDouble(),
      jobApplicationStatus: json['jobApplicationStatus'] as String,
      submittedAt: DateTime.parse(json['submittedAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  String toString() {
    return 'JobApplication(idJobApp: $idJobApp, idJobPost: $idJobPost, idUser: $idUser, jobApplicationStatus: $jobApplicationStatus)';
  }
}