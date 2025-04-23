// Model for roles table
class Role {
  final String idRole;
  final String roleName;
  final String? description;

  Role({required this.idRole, required this.roleName, this.description});

  Map<String, dynamic> toJson() {
    return {'idRole': idRole, 'roleName': roleName, 'description': description};
  }

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      idRole: json['idRole'] as String,
      roleName: json['roleName'] as String,
      description: json['description'] as String?,
    );
  }

  @override
  String toString() {
    return 'Role(idRole: $idRole, roleName: $roleName, description: $description)';
  }
}
