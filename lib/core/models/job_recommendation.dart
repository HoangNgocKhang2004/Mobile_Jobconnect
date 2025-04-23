// JobRecommendation - Tư vấn việc làm / Gợi ý việc làm
class JobRecommendation {
  String idJobRecommendation; // Mã gợi ý việc làm
  String idUser; // Mã người dùng
  String idJobPost; // Mã bài đăng
  String suggestionReason; // Lý do gợi ý (Dựa trên kỹ năng, Kinh nghiệm, Sở thích)

  // Constructor với các tham số required
  JobRecommendation({
    required this.idJobRecommendation,
    required this.idUser,
    required this.idJobPost,
    required this.suggestionReason,
  })  : assert(idJobRecommendation.isNotEmpty, 'idJobRecommendation must not be empty'),
        assert(idUser.isNotEmpty, 'idUser must not be empty'),
        assert(idJobPost.isNotEmpty, 'idJobPost must not be empty'),
        assert(suggestionReason.isNotEmpty, 'suggestionReason must not be empty'); // Tùy chọn

  // Factory constructor từ Map
  factory JobRecommendation.fromMap(Map<String, dynamic> map) {
    return JobRecommendation(
      idJobRecommendation: map['idJobRecommendation'] as String? ?? 'IDJR000',
      idUser: map['idUser'] as String? ?? 'IDU000',
      idJobPost: map['idJobPost'] as String? ?? 'IDJP000',
      suggestionReason: map['suggestionReason'] as String? ?? '',
    );
  }

  // Chuyển đổi sang Map
  Map<String, dynamic> toMap() {
    return {
      'idJobRecommendation': idJobRecommendation,
      'idUser': idUser,
      'idJobPost': idJobPost,
      'suggestionReason': suggestionReason,
    };
  }

  // Override toString để dễ debug
  @override
  String toString() {
    return 'JobRecommendation(idJobRecommendation: $idJobRecommendation, idUser: $idUser, '
        'idJobPost: $idJobPost, suggestionReason: $suggestionReason)';
  }
}