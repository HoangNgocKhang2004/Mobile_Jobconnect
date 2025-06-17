class Notification {
  final String idNotification;
  final String? idUser;
  final String title;
  final String type; // Cập nhật ứng tuyển, Phỏng vấn, Việc làm mới
  final DateTime dateTime;
  final String status; // Đã gửi, Lên lịch, Chờ xử lý
  final String actionUrl;
  final DateTime createdAt;

  Notification({
    required this.idNotification,
    this.idUser,
    required this.title,
    required this.type,
    required this.dateTime,
    required this.status,
    required this.actionUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      idNotification: json['idNotification'],
      idUser: json['idUser'],
      title: json['title'],
      type: json['type'],
      dateTime: DateTime.parse(json['dateTime']),
      status: json['status'],
      actionUrl: json['actionUrl'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idNotification': idNotification,
      'idUser': idUser,
      'title': title,
      'type': type,
      'dateTime': dateTime.toIso8601String(),
      'status': status,
      'actionUrl': actionUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
