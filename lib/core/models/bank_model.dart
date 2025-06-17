// lib/models/bank_model.dart

class Bank {
  final String bankId;
  final String bankName;
  final String bankCode;    // Ví dụ: "VCB"
  final double balance;
  final String cardNumber;
  final String accountType; // "VIP" hoặc "Normal"
  final String cardType;    // "Thanh Toán", "Tiết Kiệm" hoặc "Visa"
  final bool isDefault;     // true = tài khoản mặc định
  final String? imageUrl;   // có thể null nếu không có ảnh
  final String userId;

  Bank({
    required this.bankId,
    required this.bankName,
    required this.bankCode,
    required this.balance,
    required this.cardNumber,
    required this.accountType,
    required this.cardType,
    required this.isDefault,
    required this.imageUrl,
    required this.userId,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    bool defaultValue;
    final value = json['isDefault'];
    if (value is int) {
      defaultValue = value == 1;
    } else if (value is bool) {
      defaultValue = value;
    } else {
      defaultValue = false;
    }
    return Bank(
      bankId: json['bankId'] as String,
      bankName: json['bankName'] as String,
      bankCode: json['bankCode'] as String,
      // Chuyển từ num → double, không ép thẳng sang int/double
      balance: (json['balance'] as num).toDouble(),
      cardNumber: json['cardNumber'] as String,
      accountType: json['accountType'] as String,
      cardType: json['cardType'] as String,
      isDefault: defaultValue,
      imageUrl: json['imageUrl'] as String?,
      userId: json['userId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bankId': bankId,
      'bankName': bankName,
      'bankCode': bankCode,
      'balance': balance,
      'cardNumber': cardNumber,
      'accountType': accountType,
      'cardType': cardType,
      // Khi gửi lên, phải gửi 0/1 cho isDefault
      'isDefault': isDefault ? 1 : 0,
      'imageUrl': imageUrl,
      'userId': userId,
    };
  }
}
