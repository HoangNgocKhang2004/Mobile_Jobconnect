// Model for companies table
class Company {
  final String idCompany;
  final String companyName;
  final String address;
  final String? description;
  final String? logoUrl;
  final String? websiteUrl;
  final String scale;

  Company({
    required this.idCompany,
    required this.companyName,
    required this.address,
    this.description,
    this.logoUrl,
    this.websiteUrl,
    required this.scale,
  });

  Map<String, dynamic> toJson() {
    return {
      'idCompany': idCompany,
      'companyName': companyName,
      'address': address,
      'description': description,
      'logoUrl': logoUrl,
      'websiteUrl': websiteUrl,
      'scale': scale,
    };
  }

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      idCompany: json['idCompany'] as String,
      companyName: json['companyName'] as String,
      address: json['address'] as String,
      description: json['description'] as String?,
      logoUrl: json['logoUrl'] as String?,
      websiteUrl: json['websiteUrl'] as String?,
      scale: json['scale'] as String,
    );
  }

  @override
  String toString() {
    return 'Company(idCompany: $idCompany, companyName: $companyName, address: $address, scale: $scale)';
  }
}