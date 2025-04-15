// Quản lý các giao dịch thanh toán của nhà tuyển dụng
// Chức năng: Thanh toán dịch vụ nâng cấp, theo dõi trạng thái giao dịch, lưu lịch sử thanh toán
import 'package:job_connect/core/models/service_model.dart';

class PaymentModel {
  String idPayment; // Mã giao dịch, ví dụ: IDP001
  String idUser; // Mã người dùng thực hiện thanh toán, ví dụ: IDU001
  double amount; // Số tiền thanh toán, ví dụ: 100.0
  ServiceModel service; // Dịch vụ liên quan, ví dụ: Nâng cấp VIP
  PaymentStatus paymentStatus; // Trạng thái thanh toán: pending, completed, failed
  PaymentMethod paymentMethod; // Phương thức thanh toán: card, bank_transfer, mobile_payment
  String? transactionId; // ID giao dịch từ cổng thanh toán, ví dụ: "txn_123", có thể null
  DateTime createdAt; // Thời gian tạo giao dịch
  DateTime updatedAt; // Thời gian cập nhật giao dịch

  PaymentModel({
    required this.idPayment,
    required this.idUser,
    required this.amount,
    required this.service,
    required this.paymentStatus,
    required this.paymentMethod,
    this.transactionId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      idPayment: map['idPayment'] as String,
      idUser: map['idUser'] as String,
      amount: (map['amount'] as num).toDouble(),
      service: ServiceModel.fromMap(map['service'] as Map<String, dynamic>),
      paymentStatus: PaymentStatus.values.firstWhere((e) => e.toString() == 'PaymentStatus.${map['paymentStatus']}'),
      paymentMethod: PaymentMethod.values.firstWhere((e) => e.toString() == 'PaymentMethod.${map['paymentMethod']}'),
      transactionId: map['transactionId'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idPayment': idPayment,
      'idUser': idUser,
      'amount': amount,
      'service': service.toMap(),
      'paymentStatus': paymentStatus.toString().split('.').last,
      'paymentMethod': paymentMethod.toString().split('.').last,
      'transactionId': transactionId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'PaymentModel(idPayment: $idPayment, idUser: $idUser, amount: $amount, paymentStatus: $paymentStatus)';
  }
}

enum PaymentStatus { pending, completed, failed }
enum PaymentMethod { card, bank_transfer, mobile_payment }