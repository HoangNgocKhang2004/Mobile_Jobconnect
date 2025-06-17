// lib/core/services/chat_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_connect/core/constant/apiconstant.dart';
import 'package:job_connect/core/models/chat_thread_model.dart';
import 'package:job_connect/core/models/message_model.dart';

class ChatService {
  final http.Client _client;

  ChatService([http.Client? client]) : _client = client ?? http.Client();

  /// 1) Lấy tất cả các thread mà user tham gia
  Future<List<ChatThreadModel>> fetchThreadsForUser(String userId) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.chatThreadsEndpoint}?userId=$userId',
    );
    final resp = await _client.get(uri, headers: {
      'Content-Type': 'application/json',
    });
    if (resp.statusCode != 200) {
      throw Exception('Không tải được threads: ${resp.statusCode}');
    }
    final List<dynamic> data = jsonDecode(resp.body);
    return data.map((e) => ChatThreadModel.fromJson(e)).toList();
  }

  /// 2) Lấy 1 thread giữa hai user nếu tồn tại
  ///    GET /api/chat/threads/between?userId1=...&userId2=...
  Future<ChatThreadModel> getThreadBetween(String recruiterId, String idUser, {
    required String userId1,
    required String userId2,
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.chatThreadsEndpoint}/between'
      '?userId1=$userId1&userId2=$userId2',
    );
    final resp = await _client.get(uri, headers: {
      'Content-Type': 'application/json',
    });
    if (resp.statusCode == 404) {
      throw Exception('Không tìm thấy thread giữa hai user.');
    }
    if (resp.statusCode != 200) {
      throw Exception('Lỗi khi lấy thread: ${resp.statusCode}');
    }
    return ChatThreadModel.fromJson(jsonDecode(resp.body));
  }

  /// 3) Tạo mới 1 thread 1-1
  ///    POST /api/chat/threads
  Future<ChatThreadModel> createThread(String user1, String user2) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.chatThreadsEndpoint}',
    );
    final body = jsonEncode({
      'idUser1': user1,
      'idUser2': user2,
    });
    final resp = await _client.post(uri, headers: {
      'Content-Type': 'application/json',
    }, body: body);
    if (resp.statusCode != 201 && resp.statusCode != 200) {
      throw Exception('Tạo thread thất bại: ${resp.statusCode}');
    }
    return ChatThreadModel.fromJson(jsonDecode(resp.body));
  }

  /// 4) Xóa một thread
  ///    DELETE /api/chat/threads/{threadId}
  Future<void> deleteThread(String threadId) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.chatThreadsEndpoint}/$threadId',
    );
    final resp = await _client.delete(uri, headers: {
      'Content-Type': 'application/json',
    });
    if (resp.statusCode == 404) {
      throw Exception('Thread không tồn tại.');
    }
    if (resp.statusCode != 204 && resp.statusCode != 200) {
      throw Exception('Xóa thread thất bại: ${resp.statusCode}');
    }
  }

  /// 5) Lấy tất cả tin nhắn trong 1 thread
  ///    GET /api/chat/threads/{threadId}/messages
  Future<List<MessageModel>> fetchMessages(String threadId) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.chatMessagesEndpoint}/$threadId/messages',
    );
    final resp = await _client.get(uri, headers: {
      'Content-Type': 'application/json',
    });
    if (resp.statusCode != 200) {
      throw Exception('Không tải được messages: ${resp.statusCode}');
    }
    final List<dynamic> data = jsonDecode(resp.body);
    return data.map((e) => MessageModel.fromJson(e)).toList();
  }

  /// 6) Gửi tin nhắn vào thread
  ///    POST /api/chat/threads/{threadId}/messages
  Future<MessageModel> sendMessage({
    required String threadId,
    required String senderId,
    required String content,
    required bool isRead,
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.chatMessagesEndpoint}/$threadId/messages',
    );
    final body = jsonEncode({
      'idSender': senderId,
      'content': content,
      'isRead': isRead,
    });
    final resp = await _client.post(uri, headers: {
      'Content-Type': 'application/json',
    }, body: body);
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      throw Exception('Gửi message thất bại: ${resp.statusCode}');
    }
    return MessageModel.fromJson(jsonDecode(resp.body));
  }

  /// 7) Đánh dấu message đã đọc
  ///    PUT /api/chat/threads/{threadId}/messages/{messageId}/read
  Future<void> markAsRead({
    required String threadId,
    required String messageId,
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.chatMessagesEndpoint}/'
      '$threadId/messages/$messageId/read',
    );
    final resp = await _client.put(uri, headers: {
      'Content-Type': 'application/json',
    });
    if (resp.statusCode != 204 && resp.statusCode != 200) {
      throw Exception('Đánh dấu đã đọc thất bại: ${resp.statusCode}');
    }
  }
}
