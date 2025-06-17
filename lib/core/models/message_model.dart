class MessageModel {
  final String idMessage;
  final String threadId;
  final String senderId;
  final String content;
  final DateTime sentAt;
  final bool isRead;

  MessageModel({
    required this.idMessage,
    required this.threadId,
    required this.senderId,
    required this.content,
    required this.sentAt,
    required this.isRead,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      idMessage: json['idMessage'] as String,
      threadId:  json['idThread']  as String,
      senderId:  json['idSender']  as String,
      content:   json['content']   as String,
      sentAt:    DateTime.parse(json['sentAt'] as String).toLocal(),
      isRead:    json['isRead']    as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'idMessage': idMessage,
        'idThread':  threadId,
        'idSender':  senderId,
        'content':   content,
        'sentAt':    sentAt.toUtc().toIso8601String(),
        'isRead':    isRead,
      };
}
