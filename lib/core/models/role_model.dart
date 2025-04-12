class RoleModel {
  final String idRole; //Mã role IDR001
  final String roleName; //Tên role
  final String? description; //Mô tả
  // ... Có thể thêm các thuộc tính khác như permissions

  RoleModel({
    required this.idRole,
    required this.roleName,
    this.description,
  });

  // Factory constructor từ Map
  factory RoleModel.fromMap(Map<String, dynamic> map) {
    return RoleModel(
      idRole: map['idRole'] as String? ?? "ID000",
      roleName: map['roleName'] as String? ?? 'Unknown',
      description: map['description'] as String?,
    );
  }

  // Chuyển đổi sang Map
  Map<String, dynamic> toMap() {
    return {
      'idRole': idRole,
      'roleName': roleName,
      'description': description,
    };
  }

  // Override toString để dễ debug
  @override
  String toString() => 'RoleModel(idRole: $idRole ,roleName: $roleName, description: $description)';

  // Một số vai trò cố định
  static final RoleModel admin = RoleModel(idRole: "IDR001", roleName : 'Admin', description: 'Quản trị viên hệ thống');
  static final RoleModel recruiter = RoleModel(idRole: "IDR002", roleName: 'Recruiter', description: 'Nhà tuyển dụng');
  static final RoleModel candidate = RoleModel(idRole: "IDR003", roleName: 'Candidate', description: 'Ứng viên');
  static final RoleModel unknown = RoleModel(idRole: "IDR000", roleName: 'Unknown', description: 'Không xác định');
}