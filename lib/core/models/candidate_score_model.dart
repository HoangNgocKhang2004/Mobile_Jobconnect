// Lưu trữ điểm phù hợp của ứng viên với công việc, được tính bởi AI
// Chức năng: Chấm điểm ứng viên, danh sách ứng viên nổi bật, phân tích CV
class CandidateScoreModel {
  String idScore; // Mã điểm số, ví dụ: IDCS001
  String idUser; // Mã ứng viên, ví dụ: IDU001
  String idJobPost; // Mã bài đăng, ví dụ: IDJP001
  double suitabilityScore; // Điểm phù hợp (0-100), ví dụ: 92.5
  Map<String, double> weightedCriteria; // Tiêu chí trọng số, ví dụ: {"skills": 0.8, "experience": 0.7}
  DateTime calculatedAt; // Thời gian tính điểm

  CandidateScoreModel({
    required this.idScore,
    required this.idUser,
    required this.idJobPost,
    required this.suitabilityScore,
    required this.weightedCriteria,
    required this.calculatedAt,
  });

  factory CandidateScoreModel.fromMap(Map<String, dynamic> map) {
    return CandidateScoreModel(
      idScore: map['idScore'] as String,
      idUser: map['idUser'] as String,
      idJobPost: map['idJobPost'] as String,
      suitabilityScore: (map['suitabilityScore'] as num).toDouble(),
      weightedCriteria: (map['weightedCriteria'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, (value as num).toDouble())),
      calculatedAt: DateTime.parse(map['calculatedAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idScore': idScore,
      'idUser': idUser,
      'idJobPost': idJobPost,
      'suitabilityScore': suitabilityScore,
      'weightedCriteria': weightedCriteria,
      'calculatedAt': calculatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'CandidateScoreModel(idScore: $idScore, idUser: $idUser, suitabilityScore: $suitabilityScore)';
  }
}