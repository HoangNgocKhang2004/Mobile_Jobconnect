// Quản lý yêu cầu đặt lại mật khẩu
// Chức năng: Quên mật khẩu, đặt lại mật khẩu
class PasswordResetModel {
  String idReset; // Mã yêu cầu đặt lại, ví dụ: IDPR001
  String userId; // Mã người dùng, ví dụ: IDU001
  String token; // Token đặt lại mật khẩu, ví dụ: "abc123"
  DateTime createdAt; // Thời gian tạo yêu cầu
  DateTime expiresAt; // Thời gian hết hạn token
  bool isUsed; // Token đã sử dụng (true) hay chưa (false)

  PasswordResetModel({
    required this.idReset,
    required this.userId,
    required this.token,
    required this.createdAt,
    required this.expiresAt,
    required this.isUsed,
  });

  factory PasswordResetModel.fromMap(Map<String, dynamic> map) {
    return PasswordResetModel(
      idReset: map['idReset'] as String,
      userId: map['userId'] as String,
      token: map['token'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      expiresAt: DateTime.parse(map['expiresAt'] as String),
      isUsed: map['isUsed'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idReset': idReset,
      'userId': userId,
      'token': token,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'isUsed': isUsed,
    };
  }

  @override
  String toString() {
    return 'PasswordResetModel(idReset: $idReset, userId: $userId, isUsed: $isUsed)';
  }
}