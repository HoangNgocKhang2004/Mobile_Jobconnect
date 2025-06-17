import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_connect/core/models/account_model.dart';
import 'package:job_connect/core/models/candidate_info_model.dart';
import 'package:job_connect/core/models/message_model.dart';
import 'package:job_connect/core/services/account_service.dart';
import 'package:job_connect/core/services/candidateinfo_service.dart';
import 'package:job_connect/core/services/chat_service.dart';

// RouteObserver cần được khởi tạo (bạn cũng có thể định nghĩa trong main.dart)
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class HrChatDetailScreen extends StatefulWidget {
  final Map<String, dynamic> chat;
  final String recruiterId;
  final bool autoReplyEnabled;
  final String autoReplyMessage;

  const HrChatDetailScreen({
    super.key,
    required this.chat,
    required this.recruiterId,
    required this.autoReplyEnabled,
    required this.autoReplyMessage,
  });

  @override
  _HrChatDetailScreenState createState() => _HrChatDetailScreenState();
}

class _HrChatDetailScreenState extends State<HrChatDetailScreen> with RouteAware {
  final TextEditingController _controller = TextEditingController();
  final List<MessageModel> _messages = [];
  bool _isLoading = true;
  String? _error;
  Account? _otherUser;
  CandidateInfo? _otherCandidate;

  final AccountService _userService = AccountService();
  final CandidateInfoService _candidateService = CandidateInfoService();
  final ChatService _chatService = ChatService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }
  
  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _controller.dispose();
    super.dispose();
  }
  
  @override
  void didPopNext() {
    _loadData();
  }
  
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final String otherId = widget.chat['idUser'] as String;
      final String threadId = widget.chat['idThread'] as String;

      _otherUser = await _userService.fetchAccountById(otherId);
      _otherCandidate = await _candidateService.fetchByUserId(otherId);

      final List<MessageModel> raw = await _chatService.fetchMessages(threadId);
      if (!mounted) return;
      setState(() {
        _messages.clear();
        _messages.addAll(raw);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Lỗi khi tải chat: $e';
        _isLoading = false;
      });
    }
  }
  
  void _sendMessage() async {
    final String text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();

    // Hiển thị tin nhắn tạm thời trong UI
    setState(() {
      _messages.add(MessageModel(
        idMessage: '',
        threadId: widget.chat['idThread'],
        senderId: widget.recruiterId,
        content: text,
        sentAt: DateTime.now().toLocal(),
        isRead: true,
      ));
    });

    try {
      final MessageModel sentMessage = await _chatService.sendMessage(
        threadId: widget.chat['idThread'],
        senderId: widget.recruiterId,
        content: text,
        isRead: true,
      );
      if (!mounted) return;
      setState(() {
        // Loại bỏ tin nhắn tạm và thêm tin nhắn từ server
        _messages.removeLast();
        _messages.add(sentMessage);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.removeLast();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gửi thất bại: $e')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chat')),
        body: Center(child: Text(_error!)),
      );
    }
    
    final Account user = _otherUser!;
    final CandidateInfo candidate = _otherCandidate!;
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
              child: user.avatarUrl == null ? Text(user.userName[0].toUpperCase()) : null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.userName, overflow: TextOverflow.ellipsis),
                  Text(candidate.workPosition ?? '---',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
            )
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          if (widget.autoReplyEnabled)
            Container(
              color: Colors.blue[50],
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, color: Colors.blue[700]),
                  const SizedBox(width: 8),
                  Expanded(child: Text(widget.autoReplyMessage)),
                ],
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadData,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (_, int index) {
                  final MessageModel m = _messages[index];
                  final bool me = m.senderId == widget.recruiterId;
                  return Align(
                    alignment: me ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      constraints: const BoxConstraints(maxWidth: 250),
                      decoration: BoxDecoration(
                        color: me ? Colors.blue[700] : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.content,
                            style: TextStyle(
                              color: me ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('HH:mm').format(m.sentAt),
                            style: TextStyle(
                              fontSize: 10,
                              // ignore: deprecated_member_use
                              color: (me ? Colors.white : Colors.black54).withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.attach_file), onPressed: () {}),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn…',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue[700]),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}