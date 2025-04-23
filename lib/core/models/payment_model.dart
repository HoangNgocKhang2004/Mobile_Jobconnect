// Payment - Quản lý thanh toán và dịch vụ
import 'package:job_connect/core/models/service_model.dart';

class Payment {
  String idPayment; // Mã giao dịch
  String idUser; // ID người dùng
  double amount; // Số tiền thanh toán
  ServiceModel service; // Tham chiếu đến dịch vụ 
  PaymentStatus paymentStatus; // Trạng thái
  PaymentMethod paymentMethod; // Phương thức thanh toán
  DateTime createdAt; // Ngày giao dịch

  // Constructor với các tham số required
  Payment({
    required this.idPayment,
    required this.idUser,
    required this.amount,
    required this.service,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.createdAt,
  })  : assert(amount >= 0, 'Amount must be non-negative'),
        assert(idPayment.isNotEmpty, 'idPayment must not be empty'),
        assert(idUser.isNotEmpty, 'idUser must not be empty');

  // Factory constructor từ Map
  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      idPayment: map['idPayment'] as String? ?? 'IDP000',
      idUser: map['idUser'] as String? ?? 'IDU000',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      service: ServiceModel.fromMap(map['service'] as Map<String, dynamic>? ?? {'idService': 'IDS000'}),
      paymentStatus: _parsePaymentStatus(map['paymentStatus']),
      paymentMethod: _parsePaymentMethod(map['paymentMethod']),
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime(1970, 1, 1),
    );
  }

  // Chuyển đổi sang Map
  Map<String, dynamic> toMap() {
    return {
      'idPayment': idPayment,
      'idUser': idUser,
      'amount': amount,
      'service': service.toMap(),
      'paymentStatus': paymentStatus.name,
      'paymentMethod': paymentMethod.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Hàm phụ trợ để parse PaymentStatus
  static PaymentStatus _parsePaymentStatus(dynamic value) {
    if (value is String) {
      return PaymentStatus.values.firstWhere(
        (e) => e.name == value,
        orElse: () => PaymentStatus.Unknown,
      );
    }
    return PaymentStatus.Unknown;
  }

  // Hàm phụ trợ để parse PaymentMethod
  static PaymentMethod _parsePaymentMethod(dynamic value) {
    if (value is String) {
      return PaymentMethod.values.firstWhere(
        (e) => e.name == value,
        orElse: () => PaymentMethod.Unknown,
      );
    }
    return PaymentMethod.Unknown;
  }

  // Override toString để dễ debug
  @override
  String toString() {
    return 'Payment(idPayment: $idPayment, idUser: $idUser, amount: $amount, '
        'service: $service, paymentStatus: $paymentStatus, '
        'paymentMethod: $paymentMethod, createdAt: $createdAt)';
  }
}

// Enum cho trạng thái thanh toán
enum PaymentStatus { Paid, NotPaid, Unknown }
// Paid: thanh toán
// NotPaid: chưa thanh toán

// Enum cho phương thức thanh toán
enum PaymentMethod { Bank, MoMo, VNPay, ZaloPay, PayPal, Unknown }
// Bank: thanh toán ngân hàng
//MoMo, VNPay, ZaloPay, PayPal: thanh toán app