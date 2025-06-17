import 'package:job_connect/core/models/message_model.dart';

class ChatThreadModel {
  final String idThread;
  final String user1Id;
  final String user2Id;
  final DateTime createdAt;
  List<MessageModel> messages;

  ChatThreadModel({
    required this.idThread,
    required this.user1Id,
    required this.user2Id,
    required this.createdAt,
    this.messages = const [],
  });

  factory ChatThreadModel.fromJson(Map<String, dynamic> json) {
    return ChatThreadModel(
      idThread: json['idThread'] as String,
      user1Id: json['idUser1'] as String,
      user2Id: json['idUser2'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'idThread': idThread,
    'idUser1': user1Id,
    'idUser2': user2Id,
    'createdAt': createdAt.toIso8601String(),
  };
}
