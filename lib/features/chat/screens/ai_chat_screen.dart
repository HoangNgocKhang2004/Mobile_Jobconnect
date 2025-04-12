import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
//import 'package:cached_network_image/cached_network_image.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({Key? key}) : super(key: key);

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  
  // Cấu hình API
  final String _apiUrl = 'https://g4f-api.com/v1/chat/completions';

  @override
  void initState() {
    super.initState();
    _addBotMessage(
      'Xin chào! Tôi là trợ lý AI của Huitworks. Tôi có thể giúp bạn tìm việc phù hợp với kỹ năng và sở thích của bạn. Bạn muốn tìm công việc gì?',
      hasOptions: true,
      options: ['Lập trình viên', 'Thiết kế', 'Marketing', 'Xem tất cả']
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _addBotMessage(String message, {bool hasOptions = false, List<String> options = const []}) {
    setState(() {
      _messages.add(ChatMessage(
        message: message,
        isUser: false,
        hasOptions: hasOptions,
        options: options,
        onOptionTap: _handleOptionTap,
      ));
    });
    _scrollToBottom();
  }

  void _handleOptionTap(String option) {
    _handleSubmitted(option);
  }

  Future<void> _sendMessageToAI(String message) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': 'Bạn là một trợ lý AI chuyên về tư vấn việc làm. Hãy giúp người dùng tìm công việc phù hợp với kỹ năng và sở thích của họ. Hãy trả lời ngắn gọn và tập trung vào việc tư vấn việc làm.'
            },
            {
              'role': 'user',
              'content': message
            }
          ],
          'temperature': 0.7,
          'max_tokens': 500
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String aiResponse = data['choices'][0]['message']['content'];
        
        // Kiểm tra xem có các tùy chọn nhanh không
        List<String> quickOptions = [];
        if (aiResponse.toLowerCase().contains('lập trình')) {
          quickOptions = ['JavaScript', 'Python', 'Java', 'Flutter/Dart'];
        } else if (aiResponse.toLowerCase().contains('thiết kế')) {
          quickOptions = ['UI/UX', 'Đồ họa', '3D', 'Web Design'];
        }
        
        _addBotMessage(
          aiResponse, 
          hasOptions: quickOptions.isNotEmpty,
          options: quickOptions
        );
      } else {
        print('Lỗi API: ${response.statusCode}');
        print('Response: ${response.body}');
        _addBotMessage('Đã xảy ra lỗi khi kết nối với máy chủ. Vui lòng thử lại sau.');
      }
    } catch (e) {
      print('Lỗi kết nối: $e');
      _addBotMessage('Không thể kết nối đến dịch vụ AI. Vui lòng kiểm tra kết nối mạng và thử lại.');
    }
  }

  void _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        message: text,
        isUser: true,
      ));
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    await _sendMessageToAI(text);
    setState(() {
      _isTyping = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tư vấn việc làm AI',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E88E5),
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                _messages.clear();
              });
              _addBotMessage(
                'Xin chào! Tôi là trợ lý AI của Huitworks. Tôi có thể giúp bạn tìm việc phù hợp với kỹ năng và sở thích của bạn. Bạn muốn tìm công việc gì?',
                hasOptions: true,
                options: ['Lập trình viên', 'Thiết kế', 'Marketing', 'Xem tất cả']
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Column(
          children: [
            // Tiêu đề và lời giới thiệu
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              color: Colors.blue.shade50,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    radius: 10,
                    child: Image.asset('assets/images/logohuit.png', 
                      height: 24, // Thay thế với hình ảnh thực tế
                      errorBuilder: (ctx, err, _) => const Icon(Icons.assistant, color: Color(0xFF1E88E5))
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'AI sẽ giúp bạn tìm công việc phù hợp nhất với năng lực và sở thích',
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
            
            // Chat messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _messages[index];
                },
              ),
            ),
            
            // Typing indicator
            if (_isTyping)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SpinKitThreeBounce(
                        color: Colors.blue[300],
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Đang nhập',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
            // Input field
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    // Nút đính kèm
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.attach_file, color: Colors.blue[400], size: 22),
                        onPressed: () {
                          // Xử lý tính năng đính kèm (CV, portfolio)
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Chức năng tải lên CV sẽ ra mắt sớm!')),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Input
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Nhập tin nhắn của bạn...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.mic, color: Colors.blue[400]),
                            onPressed: () {
                              // Chức năng ghi âm tin nhắn giọng nói
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Chức năng ghi âm sẽ ra mắt sớm!')),
                              );
                            },
                          ),
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        onSubmitted: (text) => _handleSubmitted(text),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Send button
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue[400]!, Colors.blue[700]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send_rounded),
                        color: Colors.white,
                        onPressed: () => _handleSubmitted(_messageController.text),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String message;
  final bool isUser;
  final bool hasOptions;
  final List<String> options;
  final Function(String)? onOptionTap;

  const ChatMessage({
    Key? key,
    required this.message,
    required this.isUser,
    this.hasOptions = false,
    this.options = const [],
    this.onOptionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Avatar và thông tin người gửi
          if (!isUser)
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 4),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.blue[100],
                    child: Image.asset('assets/images/ai_assistant.png', 
                      height: 16,
                      errorBuilder: (ctx, err, _) => const Icon(Icons.assistant, size: 16, color: Color(0xFF1E88E5))
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Trợ lý AI',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          
          // Tin nhắn chính
          Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              margin: EdgeInsets.only(
                left: isUser ? 64 : 16,
                right: isUser ? 16 : 64,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: isUser
                    ? const Color(0xFF1E88E5)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: isUser ? null : const Radius.circular(4),
                  bottomRight: isUser ? const Radius.circular(4) : null,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          
          // Các nút tùy chọn nhanh
          if (hasOptions && options.isNotEmpty && !isUser)
            Container(
              margin: const EdgeInsets.only(top: 8, left: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: options.map((option) {
                  return InkWell(
                    onTap: () => onOptionTap?.call(option),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.blue[300]!),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          
          // Thời gian gửi tin nhắn (có thể thêm sau)
        ],
      ),
    );
  }
}

class ChatGPTService {
  final String _apiUrl = 'https://g4f-api.com/v1/chat/completions'; // API miễn phí từ gpt4free

  Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'gpt-4', // hoặc 'gpt-3.5-turbo'
          'messages': [
            {"role": "system", "content": "Bạn là một trợ lý AI hữu ích."},
            {"role": "user", "content": message}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return 'Lỗi: Không thể kết nối đến máy chủ';
      }
    } catch (e) {
      return 'Lỗi khi gửi yêu cầu: $e';
    }
  }
}