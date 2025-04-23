import 'package:flutter/material.dart';

class HRMessagesPage extends StatefulWidget {
  const HRMessagesPage({super.key});

  @override
  State<HRMessagesPage> createState() => _HRMessagesPageState();
}

class _HRMessagesPageState extends State<HRMessagesPage> {
  bool _autoReplyEnabled = false;
  String _autoReplyMessage = "Cảm ơn bạn đã liên hệ. Hiện tại tôi đang bận, sẽ phản hồi sớm nhất có thể.";

  // Dữ liệu mẫu với thêm thông tin chức danh và trạng thái
  final List<Map<String, dynamic>> chats = const [
    {
      "id": "1",
      "name": "Nguyễn Văn A",
      "position": "Frontend Developer",
      "message": "Chào bạn, công việc còn tuyển không?",
      "time": "08:30",
      "unread": true,
      "avatar": "A",
      "isOnline": true
    },
    {
      "id": "2",
      "name": "Trần Thị B",
      "position": "UI/UX Designer",
      "message": "Mình muốn ứng tuyển vào vị trí này.",
      "time": "09:15",
      "unread": true,
      "avatar": "B",
      "isOnline": false
    },
    {
      "id": "3",
      "name": "Phạm Văn C",
      "position": "Backend Developer",
      "message": "Tôi có kinh nghiệm 3 năm, bạn có thể xem CV không?",
      "time": "10:00",
      "unread": false,
      "avatar": "C",
      "isOnline": true
    },
    {
      "id": "4",
      "name": "Lê Minh D",
      "position": "Project Manager",
      "message": "Bạn có thể cho tôi biết thêm chi tiết về công việc?",
      "time": "11:45",
      "unread": false,
      "avatar": "D",
      "isOnline": false
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Tin nhắn",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          // Thêm nút chế độ tự động phản hồi
          _buildAutoReplyButton(),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey[300],
            height: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          // Hiển thị banner khi bật chế độ tự động
          if (_autoReplyEnabled) _buildAutoReplyBanner(),
          // Phần tabs lọc tin nhắn
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: _buildFilterTab("Tất cả", true),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: _buildFilterTab("Chưa đọc", false),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: _buildFilterTab("Đã ứng tuyển", false),
                  ),
                ),
              ],
            ),
          ),
          // Danh sách tin nhắn
          Expanded(
            child: ListView.separated(
              itemCount: chats.length,
              separatorBuilder: (context, index) => const Divider(height: 1, indent: 76),
              itemBuilder: (context, index) {
                final chat = chats[index];
                return _buildChatTile(chat, context);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[700],
        child: const Icon(Icons.edit),
        onPressed: () {
          // Tạo cuộc trò chuyện mới
        },
      ),
    );
  }

  // Widget nút chế độ tự động phản hồi
  Widget _buildAutoReplyButton() {
    return IconButton(
      icon: Icon(
        _autoReplyEnabled ? Icons.auto_awesome : Icons.auto_awesome_outlined,
        color: _autoReplyEnabled ? Colors.blue[700] : null,
      ),
      tooltip: "Chế độ tự động phản hồi",
      onPressed: () {
        _showAutoReplyDialog();
      },
    );
  }

  // Widget hiển thị banner khi bật chế độ tự động
  Widget _buildAutoReplyBanner() {
    return Container(
      width: double.infinity,
      color: Colors.blue[50],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(Icons.auto_awesome, color: Colors.blue[700], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Chế độ tự động phản hồi đang bật",
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            child: const Text("Tắt"),
            onPressed: () {
              setState(() {
                _autoReplyEnabled = false;
              });
            },
          ),
        ],
      ),
    );
  }

  // Hộp thoại cài đặt tự động phản hồi
  void _showAutoReplyDialog() {
    final TextEditingController messageController = TextEditingController(text: _autoReplyMessage);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Chế độ tự động phản hồi"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text("Bật tự động phản hồi"),
              subtitle: const Text("Tự động trả lời khi bạn đang bận"),
              value: _autoReplyEnabled,
              onChanged: (value) {
                Navigator.pop(context);
                setState(() {
                  _autoReplyEnabled = value;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text("Tin nhắn tự động:"),
            const SizedBox(height: 8),
            TextField(
              controller: messageController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Nhập tin nhắn tự động...",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Hủy"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
            ),
            child: const Text("Lưu"),
            onPressed: () {
              setState(() {
                _autoReplyMessage = messageController.text;
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String title, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue[50] : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: isActive
            ? Border.all(color: Colors.blue[700]!)
            : null,
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
                fontWeight: chat["unread"] ? FontWeight.bold : FontWeight.normal,
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
          Text(
            chat["position"],
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  chat["message"],
                  style: TextStyle(
                    color: chat["unread"] ? Colors.black87 : Colors.grey[600],
                    fontWeight: chat["unread"] ? FontWeight.w500 : FontWeight.normal,
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
          MaterialPageRoute(
            builder: (context) => ChatDetailScreen(
              chat: chat,
              autoReplyEnabled: _autoReplyEnabled,
              autoReplyMessage: _autoReplyMessage,
            ),
          ),
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
}

// Màn hình chi tiết cuộc trò chuyện
class ChatDetailScreen extends StatefulWidget {
  final Map<String, dynamic> chat;
  final bool autoReplyEnabled;
  final String autoReplyMessage;
  
  const ChatDetailScreen({
    super.key, 
    required this.chat,
    required this.autoReplyEnabled,
    required this.autoReplyMessage,
  });
  
  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _hasAutoReplied = false;

  @override
  void initState() {
    super.initState();
    
    // Thêm tin nhắn mẫu ban đầu
    _messages.add(
      ChatMessage(
        text: widget.chat["message"],
        isFromCandidate: true,
        time: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    );
  }
  
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
              backgroundColor: _getAvatarColor(widget.chat["id"]),
              child: Text(
                widget.chat["avatar"],
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
                  widget.chat["name"],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.chat["position"],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Hiển thị banner khi bật chế độ tự động
          if (widget.autoReplyEnabled) _buildAutoReplyBanner(),
          // Khu vực thông tin ứng viên
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
                        const Icon(Icons.file_present, color: Colors.blue),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "CV của ứng viên",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Cập nhật 2 ngày trước",
                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Icon(Icons.download, color: Colors.blue),
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
              decoration: BoxDecoration(
                color: Colors.grey[100],
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageItem(_messages[index]);
                },
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
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Nhập tin nhắn...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue[700]),
                  onPressed: () {
                    _sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị banner khi bật chế độ tự động
  Widget _buildAutoReplyBanner() {
    return Container(
      width: double.infinity,
      color: Colors.blue[50],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(Icons.auto_awesome, color: Colors.blue[700], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Chế độ tự động phản hồi đang bật",
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Gửi tin nhắn
  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: _messageController.text,
          isFromCandidate: false,
          time: DateTime.now(),
        ),
      );
      _messageController.clear();
    });

    // Mô phỏng tin nhắn đến từ ứng viên sau 1-2 giây
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              text: "Cảm ơn bạn đã phản hồi!",
              isFromCandidate: true,
              time: DateTime.now(),
            ),
          );
        });

        // Nếu chế độ tự động đang bật và chưa tự động phản hồi, gửi tin nhắn tự động
        if (widget.autoReplyEnabled && !_hasAutoReplied) {
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              setState(() {
                _messages.add(
                  ChatMessage(
                    text: widget.autoReplyMessage,
                    isFromCandidate: false,
                    time: DateTime.now(),
                    isAutoReply: true,
                  ),
                );
                _hasAutoReplied = true;
              });
            }
          });
        }
      }
    });
  }

  // Hiển thị tin nhắn
  Widget _buildMessageItem(ChatMessage message) {
    final bool isFromMe = !message.isFromCandidate;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isFromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isFromMe)
            CircleAvatar(
              radius: 16,
              backgroundColor: _getAvatarColor(widget.chat["id"]),
              child: Text(
                widget.chat["avatar"],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (!isFromMe) const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isFromMe 
                    ? (message.isAutoReply ? Colors.blue[50] : Colors.blue[700]) 
                    : Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.isAutoReply) 
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome, size: 14, color: Colors.blue[700]),
                          const SizedBox(width: 4),
                          Text(
                            "Tự động phản hồi",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Text(
                    message.text,
                    style: TextStyle(
                      color: isFromMe && !message.isAutoReply ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatTime(message.time),
                    style: TextStyle(
                      fontSize: 10,
                      color: isFromMe && !message.isAutoReply 
                          // ignore: deprecated_member_use
                          ? Colors.white.withOpacity(0.7) 
                          : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isFromMe) const SizedBox(width: 8),
          if (isFromMe && !message.isAutoReply)
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue,
              child: Text(
                "HR",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Format thời gian
  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
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
}

// Model cho tin nhắn
class ChatMessage {
  final String text;
  final bool isFromCandidate;
  final DateTime time;
  final bool isAutoReply;
  
  ChatMessage({
    required this.text,
    required this.isFromCandidate,
    required this.time,
    this.isAutoReply = false,
  });
}