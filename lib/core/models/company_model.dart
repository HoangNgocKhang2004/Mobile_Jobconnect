// Quản lý thông tin công ty đăng tuyển
// Chức năng: Quản lý hồ sơ công ty, hiển thị chi tiết công việc, tìm kiếm công việc
class CompanyModel {
  String idCompany; // Mã công ty, ví dụ: IDC0001
  String companyName; // Tên công ty, ví dụ: "Công ty ABC"
  String address; // Địa chỉ, ví dụ: "123 Đường Láng, Hà Nội"
  String? description; // Mô tả công ty, có thể null
  String? logoUrl; // URL logo công ty, ví dụ: "logo.png", có thể null
  String? websiteUrl; // URL website, ví dụ: "www.abc.com", có thể null
  String industry; // Ngành nghề, ví dụ: "Công nghệ"

  CompanyModel({
    required this.idCompany,
    required this.companyName,
    required this.address,
    this.description,
    this.logoUrl,
    this.websiteUrl,
    required this.industry,
  });

  factory CompanyModel.fromMap(Map<String, dynamic> map) {
    return CompanyModel(
      idCompany: map['idCompany'] as String,
      companyName: map['companyName'] as String,
      address: map['address'] as String,
      description: map['description'] as String?,
      logoUrl: map['logoUrl'] as String?,
      websiteUrl: map['websiteUrl'] as String?,
      industry: map['industry'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idCompany': idCompany,
      'companyName': companyName,
      'address': address,
      'description': description,
      'logoUrl': logoUrl,
      'websiteUrl': websiteUrl,
      'industry': industry,
    };
  }

  @override
  String toString() {
    return 'CompanyModel(idCompany: $idCompany, companyName: $companyName, industry: $industry)';
  }
}