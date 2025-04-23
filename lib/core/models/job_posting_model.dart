// Model for jobPosting table
class JobPosting {
  final String idJobPost;
  final String title;
  final String description;
  final String requirements;
  final double? salary;
  final String location;
  final String jobType;
  final String experienceLevel;
  final String idCompany;
  final DateTime? applicationDeadline;
  final String? benefits;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String jobPostStatus;

  JobPosting({
    required this.idJobPost,
    required this.title,
    required this.description,
    required this.requirements,
    this.salary,
    required this.location,
    required this.jobType,
    required this.experienceLevel,
    required this.idCompany,
    this.applicationDeadline,
    this.benefits,
    required this.createdAt,
    required this.updatedAt,
    required this.jobPostStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'idJobPost': idJobPost,
      'title': title,
      'description': description,
      'requirements': requirements,
      'salary': salary,
      'location': location,
      'jobType': jobType,
      'experienceLevel': experienceLevel,
      'idCompany': idCompany,
      'applicationDeadline': applicationDeadline?.toIso8601String(),
      'benefits': benefits,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'jobPostStatus': jobPostStatus,
    };
  }

  factory JobPosting.fromJson(Map<String, dynamic> json) {
    return JobPosting(
      idJobPost: json['idJobPost'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      requirements: json['requirements'] as String,
      salary: (json['salary'] as num?)?.toDouble(),
      location: json['location'] as String,
      jobType: json['jobType'] as String,
      experienceLevel: json['experienceLevel'] as String,
      idCompany: json['idCompany'] as String,
      applicationDeadline: json['applicationDeadline'] != null
          ? DateTime.parse(json['applicationDeadline'] as String)
          : null,
      benefits: json['benefits'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      jobPostStatus: json['jobPostStatus'] as String,
    );
  }

  @override
  String toString() {
    return 'JobPosting(idJobPost: $idJobPost, title: $title, jobType: $jobType, jobPostStatus: $jobPostStatus)';
  }
}