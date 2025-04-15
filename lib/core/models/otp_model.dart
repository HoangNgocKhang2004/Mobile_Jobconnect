// Quản lý mã OTP cho xác thực email/số điện thoại
// Chức năng: Xác thực OTP khi đăng ký, đăng nhập, quên mật khẩu
class OTPModel {
  String idOTP; // Mã OTP, ví dụ: IDOTP001
  String userId; // Mã người dùng, ví dụ: IDU001
  String code; // Mã OTP, ví dụ: "123456"
  String contact; // Email hoặc số điện thoại, ví dụ: "user@example.com"
  DateTime createdAt; // Thời gian tạo OTP
  DateTime expiresAt; // Thời gian hết hạn OTP
  bool isUsed; // OTP đã sử dụng (true) hay chưa (false)

  OTPModel({
    required this.idOTP,
    required this.userId,
    required this.code,
    required this.contact,
    required this.createdAt,
    required this.expiresAt,
    required this.isUsed,
  });

  factory OTPModel.fromMap(Map<String, dynamic> map) {
    return OTPModel(
      idOTP: map['idOTP'] as String,
      userId: map['userId'] as String,
      code: map['code'] as String,
      contact: map['contact'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      expiresAt: DateTime.parse(map['expiresAt'] as String),
      isUsed: map['isUsed'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idOTP': idOTP,
      'userId': userId,
      'code': code,
      'contact': contact,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'isUsed': isUsed,
    };
  }

  @override
  String toString() {
    return 'OTPModel(idOTP: $idOTP, userId: $userId, code: $code, isUsed: $isUsed)';
  }
}