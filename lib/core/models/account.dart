// Model for users table
import 'package:job_connect/core/models/role_model.dart';

class Account {
  final String idUser;
  final String userName;
  final String email;
  final String? phoneNumber;
  final Role role;
  final String accountStatus;
  final String? avatarUrl;
  final String? socialLogin;
  final DateTime createdAt;
  final DateTime updatedAt;

  Account({
    required this.idUser,
    required this.userName,
    required this.email,
    this.phoneNumber,
    required this.role,
    required this.accountStatus,
    this.avatarUrl,
    this.socialLogin,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      idUser: json['idUser'] as String,
      userName: json['userName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      role: Role.fromJson(json['role'] as Map<String, dynamic>),
      accountStatus: json['accountStatus'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      socialLogin: json['socialLogin'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUser': idUser,
      'userName': userName,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role.toJson(),
      'accountStatus': accountStatus,
      'avatarUrl': avatarUrl,
      'socialLogin': socialLogin,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'User(idUser: $idUser, userName: $userName, email: $email, role: ${role.roleName}, accountStatus: $accountStatus)';
  }
}
