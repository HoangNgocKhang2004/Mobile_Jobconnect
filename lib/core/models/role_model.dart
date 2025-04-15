// Quản lý vai trò của người dùng trong hệ thống
// Chức năng: Phân quyền người dùng (ứng viên, nhà tuyển dụng, admin), kiểm soát truy cập tính năng
class RoleModel {
  final String idRole; // Mã vai trò, ví dụ: IDR001
  final String roleName; // Tên vai trò, ví dụ: "candidate", "recruiter", "admin"
  final String? description; // Mô tả vai trò, ví dụ: "Người tìm việc", có thể null

  RoleModel({
    required this.idRole,
    required this.roleName,
    this.description,
  });

  factory RoleModel.fromMap(Map<String, dynamic> map) {
    return RoleModel(
      idRole: map['idRole'] as String,
      roleName: map['roleName'] as String,
      description: map['description'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idRole': idRole,
      'roleName': roleName,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'RoleModel(idRole: $idRole, roleName: $roleName)';
  }
}