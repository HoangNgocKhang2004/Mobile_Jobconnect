// FeedbackModel - Quản lý phản hồi
class FeedbackModel {
  String idFeedBack; // Mã phản hồi - IDF001
  String idUser; // Mã người dùng
  String idJobPost; // Mã bài đăng
  int rating; // Số sao đánh giá (0-5)
  String? comment; // Bình luận (có thể null)
  DateTime createdAt; // Ngày tạo
  DateTime updatedAt; // Ngày cập nhật

  // Constructor với các tham số required
  FeedbackModel({
    required this.idFeedBack,
    required this.idUser,
    required this.idJobPost,
    required this.rating,
    this.comment,
    required this.createdAt,
    required this.updatedAt,
  })  : assert(idFeedBack.isNotEmpty, 'idFeedBack must not be empty'),
        assert(idUser.isNotEmpty, 'idUser must not be empty'),
        assert(idJobPost.isNotEmpty, 'idJobPost must not be empty'),
        assert(rating >= 0 && rating <= 5, 'Rating must be between 0 and 5');

  // Factory constructor để tạo instance từ Map
  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      idFeedBack: map['idFeedBack'] as String? ?? 'IDF000',
      idUser: map['idUser'] as String? ?? 'IDU000',
      idJobPost: map['idJobPost'] as String? ?? 'IDJP000',
      rating: (map['rating'] as num?)?.toInt().clamp(0, 5) ?? 0, 
      comment: map['comment'] as String?, // Có thể null
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime(1970, 1, 1),
      updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? '') ?? DateTime(1970, 1, 1),
    );
  }

  // Phương thức toMap để chuyển object thành Map
  Map<String, dynamic> toMap() {
    return {
      'idFeedBack': idFeedBack,
      'idUser': idUser,
      'idJobPost': idJobPost,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Override toString để dễ debug
  @override
  String toString() {
    return 'FeedbackModel(idFeedBack: $idFeedBack, idUser: $idUser, idJobPost: $idJobPost, '
        'rating: $rating, comment: $comment, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}