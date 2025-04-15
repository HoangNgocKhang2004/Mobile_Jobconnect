// Quản lý banner quảng cáo cho bài đăng tuyển dụng nổi bật
// Chức năng: Hiển thị banner trên trang chủ
class BannerModel {
  String idBanner; // Mã banner, ví dụ: IDB001
  String idJobPost; // Mã bài đăng liên kết, ví dụ: IDJP001
  String imageUrl; // URL hình ảnh banner, ví dụ: "banner.jpg"
  DateTime startDate; // Ngày bắt đầu hiển thị
  DateTime endDate; // Ngày kết thúc hiển thị
  bool isActive; // Trạng thái hoạt động (true/false)

  BannerModel({
    required this.idBanner,
    required this.idJobPost,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.isActive,
  });

  factory BannerModel.fromMap(Map<String, dynamic> map) {
    return BannerModel(
      idBanner: map['idBanner'] as String,
      idJobPost: map['idJobPost'] as String,
      imageUrl: map['imageUrl'] as String,
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: DateTime.parse(map['endDate'] as String),
      isActive: map['isActive'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idBanner': idBanner,
      'idJobPost': idJobPost,
      'imageUrl': imageUrl,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return 'BannerModel(idBanner: $idBanner, idJobPost: $idJobPost, isActive: $isActive)';
  }
}