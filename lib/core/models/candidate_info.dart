// Model for candidateInfo table
class CandidateInfo {
  final String idUser;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? address;

  CandidateInfo({
    required this.idUser,
    this.dateOfBirth,
    this.gender,
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'idUser': idUser,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'address': address,
    };
  }

  factory CandidateInfo.fromJson(Map<String, dynamic> json) {
    return CandidateInfo(
      idUser: json['idUser'] as String,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      gender: json['gender'] as String?,
      address: json['address'] as String?,
    );
  }

  @override
  String toString() {
    return 'CandidateInfo(idUser: $idUser, dateOfBirth: $dateOfBirth, gender: $gender)';
  }
}