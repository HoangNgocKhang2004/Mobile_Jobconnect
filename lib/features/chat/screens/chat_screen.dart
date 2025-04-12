import 'package:flutter/material.dart';
//import 'package:intl/intl.dart'; // Thêm package để định dạng thời gian

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  // Dữ liệu mẫu với thông tin nhà tuyển dụng
  final List<Map<String, dynamic>> chats = const [
    {
      "id": "1",
      "name": "FPT Software",
      "position": "Frontend Developer",
      "message": "Cảm ơn bạn đã ứng tuyển. Khi nào bạn có thể phỏng vấn?",
      "time": "08:30",
      "unread": true,
      "avatar": "F",
      "isOnline": true,
      "jobStatus": "Đã phản hồi",
    },
    {
      "id": "2",
      "name": "VNG Corporation",
      "position": "UI/UX Designer",
      "message": "Hồ sơ của bạn đã được chúng tôi xem xét.",
      "time": "09:15",
      "unread": true,
      "avatar": "V",
      "isOnline": false,
      "jobStatus": "Đang xem xét",
    },
    {
      "id": "3",
      "name": "Tiki",
      "position": "Backend Developer",
      "message": "Chúng tôi muốn mời bạn tham gia buổi phỏng vấn online.",
      "time": "10:00",
      "unread": false,
      "avatar": "T",
      "isOnline": true,
      "jobStatus": "Mời phỏng vấn",
    },
    {
      "id": "4",
      "name": "Momo",
      "position": "Mobile Developer",
      "message":
          "Cảm ơn bạn đã tham gia phỏng vấn. Chúng tôi sẽ thông báo kết quả sớm.",
      "time": "11:45",
      "unread": false,
      "avatar": "M",
      "isOnline": false,
      "jobStatus": "Đã phỏng vấn",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Tin nhắn tuyển dụng",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey[300], height: 1.0),
        ),
      ),
      body: Column(
        children: [
          // Phần tabs lọc tin nhắn
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(child: Center(child: _buildFilterTab("Tất cả", true))),
                Expanded(
                  child: Center(child: _buildFilterTab("Chưa đọc", false)),
                ),
                Expanded(
                  child: Center(child: _buildFilterTab("Đã ứng tuyển", false)),
                ),
              ],
            ),
          ),
          // Danh sách tin nhắn
          Expanded(
            child: ListView.separated(
              itemCount: chats.length,
              separatorBuilder:
                  (context, index) => const Divider(height: 1, indent: 76),
              itemBuilder: (context, index) {
                final chat = chats[index];
                return _buildChatTile(chat, context);
              },
            ),
          ),
        ],
      ),
      // Đã loại bỏ bottomNavigationBar
    );
  }

  Widget _buildFilterTab(String title, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue[50] : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: isActive ? Border.all(color: Colors.blue[700]!) : null,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.blue[700] : Colors.grey[600],
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildChatTile(Map<String, dynamic> chat, BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: _getAvatarColor(chat["id"]),
            child: Text(
              chat["avatar"],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (chat["isOnline"])
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              chat["name"],
              style: TextStyle(
                fontWeight:
                    chat["unread"] ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            chat["time"],
            style: TextStyle(
              color: chat["unread"] ? Colors.blue[700] : Colors.grey,
              fontSize: 12,
              fontWeight: chat["unread"] ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                chat["position"],
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getStatusColor(chat["jobStatus"]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  chat["jobStatus"],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  chat["message"],
                  style: TextStyle(
                    color: chat["unread"] ? Colors.black87 : Colors.grey[600],
                    fontWeight:
                        chat["unread"] ? FontWeight.w500 : FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              if (chat["unread"])
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.blue[700],
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatDetailScreen(chat: chat)),
        );
      },
    );
  }

  Color _getAvatarColor(String id) {
    // Tạo màu khác nhau dựa trên ID
    final List<Color> colors = [
      Colors.blue[700]!,
      Colors.purple[700]!,
      Colors.orange[700]!,
      Colors.teal[700]!,
    ];

    return colors[int.parse(id) % colors.length];
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Đã phản hồi":
        return Colors.blue[700]!;
      case "Đang xem xét":
        return Colors.orange[700]!;
      case "Mời phỏng vấn":
        return Colors.green[700]!;
      case "Đã phỏng vấn":
        return Colors.purple[700]!;
      default:
        return Colors.grey[700]!;
    }
  }
}

// Màn hình chi tiết cuộc trò chuyện
class ChatDetailScreen extends StatelessWidget {
  final Map<String, dynamic> chat;

  const ChatDetailScreen({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: _getAvatarColor(chat["id"]),
              child: Text(
                chat["avatar"],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat["name"],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  chat["position"],
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.info_outline), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Khu vực thông tin việc làm
          Container(
            color: Colors.grey[50],
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.work_outline, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${chat["position"]} - ${chat["name"]}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(chat["jobStatus"]),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  chat["jobStatus"],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Phần chat
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Colors.grey[100]),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildReceivedMessage(
                    "Chào bạn, cảm ơn bạn đã quan tâm đến vị trí ${chat["position"]} tại ${chat["name"]}.",
                    "08:30",
                  ),
                  _buildReceivedMessage(
                    "Hồ sơ của bạn đã được chúng tôi xem xét và đánh giá cao.",
                    "08:31",
                  ),
                  _buildSentMessage(
                    "Dạ, em cảm ơn quý công ty đã xem xét hồ sơ của em.",
                    "08:35",
                  ),
                  _buildReceivedMessage(chat["message"], chat["time"]),
                  if (chat["jobStatus"] == "Mời phỏng vấn" ||
                      chat["jobStatus"] == "Đã phỏng vấn")
                    _buildSentMessage(
                      "Dạ, em có thể tham gia phỏng vấn vào thứ 5 tuần này ạ.",
                      "10:15",
                    ),
                ],
              ),
            ),
          ),
          // Phần nhập tin nhắn
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 1,
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Nhập tin nhắn...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue[700]),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceivedMessage(String message, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, right: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                ),
              ],
            ),
            child: Text(message),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 8),
            child: Text(
              time,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSentMessage(String message, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(message),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, right: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.done_all, size: 14, color: Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getAvatarColor(String id) {
    final List<Color> colors = [
      Colors.blue[700]!,
      Colors.purple[700]!,
      Colors.orange[700]!,
      Colors.teal[700]!,
    ];

    return colors[int.parse(id) % colors.length];
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Đã phản hồi":
        return Colors.blue[700]!;
      case "Đang xem xét":
        return Colors.orange[700]!;
      case "Mời phỏng vấn":
        return Colors.green[700]!;
      case "Đã phỏng vấn":
        return Colors.purple[700]!;
      default:
        return Colors.grey[700]!;
    }
  }
}