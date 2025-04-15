// Quản lý gợi ý công việc cho ứng viên dựa trên AI
// Chức năng: Gợi ý công việc phù hợp, hiển thị lý do gợi ý, xếp hạng độ phù hợp
class JobRecommendationModel {
  String idJobRecommendation; // Mã gợi ý, ví dụ: IDJR001
  String idUser; // Mã người dùng nhận gợi ý, ví dụ: IDU001
  String idJobPost; // Mã bài đăng tuyển dụng, ví dụ: IDJP001
  String suggestionReason; // Lý do gợi ý, ví dụ: "Khớp kỹ năng Java"
  double confidenceScore; // Điểm tin cậy của gợi ý, ví dụ: 0.95

  JobRecommendationModel({
    required this.idJobRecommendation,
    required this.idUser,
    required this.idJobPost,
    required this.suggestionReason,
    required this.confidenceScore,
  });

  factory JobRecommendationModel.fromMap(Map<String, dynamic> map) {
    return JobRecommendationModel(
      idJobRecommendation: map['idJobRecommendation'] as String,
      idUser: map['idUser'] as String,
      idJobPost: map['idJobPost'] as String,
      suggestionReason: map['suggestionReason'] as String,
      confidenceScore: (map['confidenceScore'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idJobRecommendation': idJobRecommendation,
      'idUser': idUser,
      'idJobPost': idJobPost,
      'suggestionReason': suggestionReason,
      'confidenceScore': confidenceScore,
    };
  }

  @override
  String toString() {
    return 'JobRecommendationModel(idJobRecommendation: $idJobRecommendation, idUser: $idUser, idJobPost: $idJobPost)';
  }
}