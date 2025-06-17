class JobPosting {
  final String idJobPost;
  final String title;
  final String? description;
  final String? requirements;
  final double salary;
  final String location;
  final String workType;
  final String experienceLevel;
  final String idCompany;
  final DateTime applicationDeadline;
  final String? benefits;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int isFeatured;
  final String postStatus;

  JobPosting({
    required this.idJobPost,
    required this.title,
    this.description,
    this.requirements,
    required this.salary,
    required this.location,
    required this.workType,
    required this.experienceLevel,
    required this.idCompany,
    required this.applicationDeadline,
    this.benefits,
    required this.createdAt,
    required this.updatedAt,
    required this.isFeatured,
    required this.postStatus,
  });

  factory JobPosting.fromJson(Map<String, dynamic> json) {
    return JobPosting(
      idJobPost: json['idJobPost'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,      
      requirements: json['requirements'] as String?,    
      salary: (json['salary'] as num).toDouble(),
      location: json['location'] as String,
      workType: json['workType'] as String,
      experienceLevel: json['experienceLevel'] as String,
      idCompany: json['idCompany'] as String,
      applicationDeadline: DateTime.parse(json['applicationDeadline'] as String),
      benefits: json['benefits'] as String?,            
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isFeatured: (json['isFeatured'] as num?)?.toInt() ?? 0,
      postStatus: json['postStatus'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'idJobPost': idJobPost,
    'title': title,
    'description': description,
    'requirements': requirements,
    'salary': salary,
    'location': location,
    'workType': workType,
    'experienceLevel': experienceLevel,
    'idCompany': idCompany,
    'applicationDeadline': applicationDeadline.toIso8601String(),
    'benefits': benefits,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'isFeatured': isFeatured,
    'postStatus': postStatus,
  };
}
