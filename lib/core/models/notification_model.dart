// Quản lý thông báo gửi đến người dùng
// Chức năng: Cập nhật trạng thái ứng tuyển, nhắc nhở phỏng vấn, thông báo từ nhà tuyển dụng
class NotificationModel {
  String idNotification; // Mã thông báo, ví dụ: IDN001
  String idUser; // Mã người dùng nhận thông báo, ví dụ: IDU001
  String title; // Tiêu đề, ví dụ: "Lịch phỏng vấn"
  String message; // Nội dung, ví dụ: "Phỏng vấn vào 10h ngày 15/4"
  NotificationType type; // Loại thông báo: ApplicationUpdate, InterviewReminder
  bool isRead; // Đã đọc (true) hay chưa (false)
  DateTime createdAt; // Thời gian tạo thông báo

  NotificationModel({
    required this.idNotification,
    required this.idUser,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      idNotification: map['idNotification'] as String,
      idUser: map['idUser'] as String,
      title: map['title'] as String,
      message: map['message'] as String,
      type: NotificationType.values.firstWhere((e)=> e.toString() == 'NotificationType.${map['type']}'),
      isRead: map['isRead'] as bool,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idNotification': idNotification,
      'idUser': idUser,
      'title': title,
      'message': message,
      'type': type.toString(),
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'NotificationModel(idNotification: $idNotification, idUser: $idUser, title: $title, type: $type)';
  }
}

enum NotificationType{applicationUpdate, interviewReminder}