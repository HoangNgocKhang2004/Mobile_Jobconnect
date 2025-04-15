// Quản lý các dịch vụ trả phí cho nhà tuyển dụng
// Chức năng: Thanh toán dịch vụ, quản lý gói nâng cấp bài đăng, kích hoạt ưu đãi
class ServiceModel {
  String idService; // Mã dịch vụ, ví dụ: IDS001
  String serviceName; // Tên dịch vụ, ví dụ: "Nâng cấp bài đăng VIP"
  double price; // Giá dịch vụ, ví dụ: 100.0
  String? description; // Mô tả dịch vụ, ví dụ: "Hiển thị bài đăng lên top trong 30 ngày", có thể null
  int? duration; // Thời gian hiệu lực (ngày), ví dụ: 30, có thể null

  ServiceModel({
    required this.idService,
    required this.serviceName,
    required this.price,
    this.description,
    this.duration,
  });

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      idService: map['idService'] as String,
      serviceName: map['serviceName'] as String,
      price: (map['price'] as num).toDouble(),
      description: map['description'] as String?,
      duration: map['duration'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idService': idService,
      'serviceName': serviceName,
      'price': price,
      'description': description,
      'duration': duration,
    };
  }

  @override
  String toString() {
    return 'ServiceModel(idService: $idService, serviceName: $serviceName, price: $price)';
  }
}