// ServiceModel - Quản lý thông tin dịch vụ
class ServiceModel {
  String idService; // Mã dịch vụ - IDS001
  String serviceName; // Tên dịch vụ
  double price; // Giá tiền của dịch vụ
  String? description; // Mô tả dịch vụ (có thể null)

  ServiceModel({
    required this.idService,
    required this.serviceName,
    required this.price,
    this.description,
  }) : assert(idService.isNotEmpty, 'idService must not be empty'),
       assert(price >= 0, 'Price must be non-negative');

  // Factory constructor từ Map
  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      idService: map['idService'] as String? ?? 'IDS000',
      serviceName: map['serviceName'] as String? ?? 'Unknown',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      description: map['description'] as String?,
    );
  }

  // Chuyển đổi sang Map
  Map<String, dynamic> toMap() {
    return {
      'idService': idService,
      'serviceName': serviceName,
      'price': price,
      'description': description,
    };
  }

  // Override toString để dễ debug
  @override
  String toString() {
    return 'ServiceModel(idService: $idService, serviceName: $serviceName, '
        'price: $price, description: $description)';
  }
}