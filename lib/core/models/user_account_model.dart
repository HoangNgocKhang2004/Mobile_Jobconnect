import 'package:job_connect/core/models/role_model.dart';

class UserAccountModel {
  String idUser; //Mã người dùng - IDU001 
  String userName; //Tên người dùng
  String email; //Email
  String password; //Mật khẩu
  RoleModel role; //Quyền
  AccountStatus accountStatus; //Trạng thái tài khoản
  DateTime createdAt; //Ngày tạo
  DateTime updatedAt; //Ngày cập nhập
  //.. thêm trường khác...

  UserAccountModel({
    required this.idUser,
    required this.userName,
    required this.email,
    required this.password,
    required this.role,
    required this.accountStatus,
    required this.createdAt,
    required this.updatedAt,
  }):assert(idUser.isEmpty, 'idUser not null!');

  factory UserAccountModel.fromMap(Map<String, dynamic> map) {
    return UserAccountModel(
      idUser: map['idUser'] as String? ?? 'IDU000',
      userName: map['userName'] as String? ?? 'Unknown',
      email: map['email'] as String? ?? 'Unknown',
      password: map['password'] as String? ?? 'Unknown',
      role: RoleModel.fromMap(map['role'] as Map<String, dynamic>? ?? {'name': 'Unknown'}),
      accountStatus: _parseAccountStatus(map['accountStatus']),
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime(1970, 1, 1),
      updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? '') ?? DateTime(1970, 1, 1),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idUser': idUser,
      'userName': userName,
      'email': email,
      'password': password,
      'role': role.toMap(),
      'accountStatus': accountStatus.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  //Hàm bổ trợ chuyển đổ parse AccountStatus
  static AccountStatus _parseAccountStatus(dynamic value) {
    if (value is String) {
      return AccountStatus.values.firstWhere(
        (e) => e.name == value,
        orElse: () => AccountStatus.Inactive,
      );
    }
    return AccountStatus.Inactive;
  }

  // Override toString để dễ debug
  @override
  String toString() {
    return 'UserAccountModel(idUser: $idUser, userName: $userName, email: $email, '
        'password: $password, role: $role, accountStatus: $accountStatus, '
        'createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

enum AccountStatus { Active, Inactive, Banned, Unknown }
// Active: hoạt động
//Inactive: không hoạt động
//Banned: bị cấm