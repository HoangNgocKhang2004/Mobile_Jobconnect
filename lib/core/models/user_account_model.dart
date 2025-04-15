// Quản lý tài khoản người dùng
// Chức năng: Đăng nhập/đăng ký, quản lý thông tin tài khoản, cài đặt quyền riêng tư, xác thực OTP, chọn loại tài khoản, đổi mật khẩu, cập nhật ảnh đại diện
import 'package:job_connect/core/models/role_model.dart';

class UserAccountModel {
  String idUser; // Mã người dùng, ví dụ: IDU001
  String userName; // Tên người dùng hiển thị
  String email; // Email dùng để đăng nhập hoặc liên hệ
  String? phoneNumber; // Số điện thoại cho xác thực OTP, có thể null
  // String password; // Mật khẩu (đã mã hóa)
  RoleModel role; // Vai trò của người dùng (Admin, Candidate, Recruiter)
  AccountType accountType; // Loại tài khoản: candidate hoặc recruiter
  AccountStatus accountStatus; // Trạng thái tài khoản: active, inactive, suspended
  String? avatarUrl; // URL ảnh đại diện, có thể null
  String? socialLoginProvider; // Nhà cung cấp đăng nhập xã hội: Google, Facebook, có thể null
  String? socialLoginId; // ID duy nhất từ nhà cung cấp xã hội, có thể null
  bool isProfilePublic; // Hồ sơ công khai (true) hay ẩn danh (false)
  DateTime createdAt; // Thời gian tạo tài khoản
  DateTime updatedAt; // Thời gian cập nhật tài khoản

  UserAccountModel({
    required this.idUser,
    required this.userName,
    required this.email,
    this.phoneNumber,
    // required this.password,
    required this.role,
    required this.accountType,
    required this.accountStatus,
    this.avatarUrl,
    this.socialLoginProvider,
    this.socialLoginId,
    required this.isProfilePublic,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserAccountModel.fromMap(Map<String, dynamic> map) {
    return UserAccountModel(
      idUser: map['idUser'] as String,
      userName: map['userName'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String?,
      // password: map['password'] as String,
      role: RoleModel.fromMap(map['role'] as Map<String, dynamic>),
      accountType: AccountType.values.firstWhere((e) => e.toString() == 'AccountType.${map['accountType']}'),
      accountStatus: AccountStatus.values.firstWhere((e) => e.toString() == 'AccountStatus.${map['accountStatus']}'),
      avatarUrl: map['avatarUrl'] as String?,
      socialLoginProvider: map['socialLoginProvider'] as String?,
      socialLoginId: map['socialLoginId'] as String?,
      isProfilePublic: map['isProfilePublic'] as bool,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idUser': idUser,
      'userName': userName,
      'email': email,
      'phoneNumber': phoneNumber,
      // 'password': password,
      'role': role.toMap(),
      'accountType': accountType.toString().split('.').last,
      'accountStatus': accountStatus.toString().split('.').last,
      'avatarUrl': avatarUrl,
      'socialLoginProvider': socialLoginProvider,
      'socialLoginId': socialLoginId,
      'isProfilePublic': isProfilePublic,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'UserAccountModel(idUser: $idUser, userName: $userName, email: $email, accountType: $accountType, accountStatus: $accountStatus)';
  }
}

enum AccountType { candidate, recruiter }
enum AccountStatus { active, inactive, suspended }