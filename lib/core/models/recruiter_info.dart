// Model for recruiterInfo table
class RecruiterInfo {
  final String idUser;
  final String? department;
  final String? title;
  final String? idCompany;

  RecruiterInfo({
    required this.idUser,
    this.department,
    this.title,
    this.idCompany,
  });

  Map<String, dynamic> toJson() {
    return {
      'idUser': idUser,
      'department': department,
      'title': title,
      'idCompany': idCompany,
    };
  }

  factory RecruiterInfo.fromJson(Map<String, dynamic> json) {
    return RecruiterInfo(
      idUser: json['idUser'] as String,
      department: json['department'] as String?,
      title: json['title'] as String?,
      idCompany: json['idCompany'] as String?,
    );
  }

  @override
  String toString() {
    return 'RecruiterInfo(idUser: $idUser, department: $department, title: $title, idCompany: $idCompany)';
  }
}