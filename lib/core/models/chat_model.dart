// Quản lý cuộc trò chuyện giữa ứng viên và nhà tuyển dụng
// Chức năng: Chat trực tiếp, gửi tài liệu/hình ảnh
import 'package:job_connect/core/models/message_model.dart';

class ChatModel {
  String idChat; // Mã cuộc trò chuyện, ví dụ: IDC001
  List<String> participants; // Danh sách ID người tham gia, ví dụ: [IDU001, IDU002]
  List<MessageModel> messages; // Danh sách tin nhắn trong cuộc trò chuyện
  DateTime createdAt; // Thời gian bắt đầu cuộc trò chuyện
  DateTime updatedAt; // Thời gian cập nhật (tin nhắn mới nhất)

  ChatModel({
    required this.idChat,
    required this.participants,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      idChat: map['idChat'] as String,
      participants: (map['participants'] as List<dynamic>).cast<String>(),
      messages: (map['messages'] as List<dynamic>)
          .map((m) => MessageModel.fromMap(m as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idChat': idChat,
      'participants': participants,
      'messages': messages.map((m) => m.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'ChatModel(idChat: $idChat, participants: $participants)';
  }
}