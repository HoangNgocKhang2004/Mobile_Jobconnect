// Quản lý từng tin nhắn trong cuộc trò chuyện
// Chức năng: Chat trực tiếp, gửi tài liệu/hình ảnh
class MessageModel {
  String idMessage; // Mã tin nhắn, ví dụ: IDM001
  String idChat; // Mã cuộc trò chuyện, ví dụ: IDC001
  String senderId; // Mã người gửi, ví dụ: IDU001
  String content; // Nội dung tin nhắn hoặc URL tệp, ví dụ: "Xin chào" hoặc "file.pdf"
  MessageType type; // Loại tin nhắn: Text, File, Image
  DateTime sentAt; // Thời gian gửi tin nhắn

  MessageModel({
    required this.idMessage,
    required this.idChat,
    required this.senderId,
    required this.content,
    required this.type,
    required this.sentAt,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      idMessage: map['idMessage'] as String,
      idChat: map['idChat'] as String,
      senderId: map['senderId'] as String,
      content: map['content'] as String,
      type: MessageType.values.firstWhere((e) => e.toString() == map['type']),
      sentAt: DateTime.parse(map['sentAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idMessage': idMessage,
      'idChat': idChat,
      'senderId': senderId,
      'content': content,
      'type': type.toString(),
      'sentAt': sentAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'MessageModel(idMessage: $idMessage, idChat: $idChat, senderId: $senderId, type: $type)';
  }
}
enum MessageType {text, file, image, url}