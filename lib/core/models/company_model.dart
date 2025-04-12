// CompanyModel - Quản lý thông tin công ty
class CompanyModel {
  String idCompany; // Mã công ty -- IDC0001
  String companyName; // Tên công ty
  String address; // Địa chỉ công ty
  String? description; // Mô tả công ty (có thể null)
  //...thêm tùy ý

  CompanyModel({
    required this.idCompany,
    required this.companyName,
    required this.address,
    this.description,
  }) : assert(idCompany.isNotEmpty, 'idCompany must not be empty'),
       assert(companyName.isNotEmpty, 'companyName must not be empty');

  // Factory constructor từ Map
  factory CompanyModel.fromMap(Map<String, dynamic> map) {
    return CompanyModel(
      idCompany: map['idCompany'] as String? ?? 'IDC000',
      companyName: map['companyName'] as String? ?? 'Unknown',
      address: map['address'] as String? ?? 'Unknown',
      description: map['description'] as String?,
    );
  }

  // Chuyển đổi sang Map
  Map<String, dynamic> toMap() {
    return {
      'idCompany': idCompany,
      'companyName': companyName,
      'address': address,
      'description': description,
    };
  }

  // Override toString để dễ debug
  @override
  String toString() {
    return 'CompanyModel(idCompany: $idCompany, companyName: $companyName, '
        'address: $address, description: $description)';
  }
}