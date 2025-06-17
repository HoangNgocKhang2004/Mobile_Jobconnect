class JobApplication {
  final String idJobPost;
  final String idUser;
  final String cvFileUrl;
  final String coverLetter;
  String applicationStatus;
  final DateTime submittedAt;
  final DateTime updatedAt;

  JobApplication({
    required this.idJobPost,
    required this.idUser,
    required this.cvFileUrl,
    required this.coverLetter,
    required this.applicationStatus,
    required this.submittedAt,
    required this.updatedAt,
  });

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      idJobPost: json['idJobPost'] as String,
      idUser: json['idUser'] as String,
      cvFileUrl: json['cvFileUrl'] as String,
      coverLetter: json['coverLetter'] as String,
      applicationStatus: json['applicationStatus'] as String,
      submittedAt: DateTime.parse(json['submittedAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idJobPost': idJobPost,
      'idUser': idUser,
      'cvFileUrl': cvFileUrl,
      'coverLetter': coverLetter,
      'applicationStatus': applicationStatus,
      // submittedAt/updatedAt để backend tạo tự động, không gửi trong body
    };
  }
}
