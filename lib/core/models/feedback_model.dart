// Quản lý phản hồi từ người dùng về bài đăng hoặc công ty
// Chức năng: Đánh giá công việc/công ty, xếp hạng ứng viên nổi bật
class FeedbackModel {
  String idFeedBack; // Mã phản hồi, ví dụ: IDF001
  String idUser; // Mã người dùng gửi phản hồi, ví dụ: IDU001
  String? idJobPost; // Mã bài đăng, ví dụ: IDJP001, có thể null
  String? idCompany; // Mã công ty, ví dụ: IDC001, có thể null
  int rating; // Điểm đánh giá (0-5), ví dụ: 4
  String? comment; // Bình luận, ví dụ: "Công ty tốt", có thể null
  FeedbackType feedbackType; // Loại phản hồi: JobPost hoặc Company
  DateTime createdAt; // Thời gian tạo phản hồi
  DateTime updatedAt; // Thời gian cập nhật phản hồi

  FeedbackModel({
    required this.idFeedBack,
    required this.idUser,
    this.idJobPost,
    this.idCompany,
    required this.rating,
    this.comment,
    required this.feedbackType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      idFeedBack: map['idFeedBack'] as String,
      idUser: map['idUser'] as String,
      idJobPost: map['idJobPost'] as String?,
      idCompany: map['idCompany'] as String?,
      rating: map['rating'] as int,
      comment: map['comment'] as String?,
      feedbackType: FeedbackType.values.firstWhere((e) => e.toString() == map['feedbackType']),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idFeedBack': idFeedBack,
      'idUser': idUser,
      'idJobPost': idJobPost,
      'idCompany': idCompany,
      'rating': rating,
      'comment': comment,
      'feedbackType': feedbackType.toString(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'FeedbackModel(idFeedBack: $idFeedBack, idUser: $idUser, rating: $rating, feedbackType: $feedbackType)';
  }
}
enum FeedbackType { jobPost, company }