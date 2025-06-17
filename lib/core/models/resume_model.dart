import 'package:job_connect/core/models/account_model.dart';
class Resume {
  final String idResume;
  final String idUser;
  final String fileUrl;
  final String fileName;
  final int? fileSizeKB;
  final int isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Account? user;
  final List<String>? resumeSkills;

  Resume({
    required this.idResume,
    required this.idUser,
    required this.fileUrl,
    required this.fileName,
    this.fileSizeKB,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.resumeSkills,
  });

  factory Resume.fromJson(Map<String, dynamic> json) {
    return Resume(
      idResume: json['idResume'],
      idUser: json['idUser'],
      fileUrl: json['fileUrl'],
      fileName: json['fileName'],
      fileSizeKB: json['fileSizeKB'],
      isDefault: json['isDefault'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      user: json['user'] != null ? Account.fromJson(json['user']) : null,
      resumeSkills: (json['resumeSkills'] as List?)?.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'idResume': idResume,
    'idUser': idUser,
    'fileUrl': fileUrl,
    'fileName': fileName,
    'fileSizeKB': fileSizeKB,
    'isDefault': isDefault,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'user': user?.toJson(),
    'resumeSkills': resumeSkills,
  };
}
