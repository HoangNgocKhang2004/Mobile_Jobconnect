import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_connect/core/models/account_model.dart';
import 'package:job_connect/core/models/candidate_info_model.dart';
import 'package:job_connect/core/models/chat_thread_model.dart';
import 'package:job_connect/core/services/account_service.dart';
import 'package:job_connect/core/services/candidateinfo_service.dart';
import 'package:job_connect/core/services/chat_service.dart';
import 'package:job_connect/features/chat/screens/hr_chat_detail_screen.dart';

class HRMessagesPage extends StatefulWidget {
  final String recruiterId;
  const HRMessagesPage({super.key, required this.recruiterId});

  @override
  State<HRMessagesPage> createState() => _HRMessagesPageState();
}

class _HRMessagesPageState extends State<HRMessagesPage> {
  final Map<String, Account> _userCache = {};
  List<Map<String, dynamic>> _chatList = [];
  List<Map<String, dynamic>> _filteredChatList = [];
  bool _isLoading = true;
  String _errorMessage = '';
  final _chatService = ChatService();
  final _userService = AccountService();
  final _candidate = CandidateInfoService();

  bool _autoReplyEnabled = false;
  String _autoReplyMessage =
      "Cảm ơn bạn đã liên hệ. Hiện tại tôi đang bận, sẽ phản hồi sớm nhất có thể.";

  String _selectedFilter = 'Tất cả';

  List<ChatThreadModel> _threads = [];

  bool _isSearching = false;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadThreads();
  }

  Future<void> _loadThreads() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final threads =
          await _chatService.fetchThreadsForUser(widget.recruiterId);
      final chats = await getChatsFromThreads(threads);
      if (!mounted) return;
      setState(() {
        _threads = threads;
        _chatList = chats;
        _filteredChatList = applyFilterAndSearch(_chatList);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<List<Map<String, dynamic>>> getChatsFromThreads(
      List<ChatThreadModel> threads) async {
    final List<Map<String, dynamic>> chats = [];
    for (final thread in threads) {
      final otherId = thread.user1Id == widget.recruiterId
          ? thread.user2Id
          : thread.user1Id;
      var other = _userCache[otherId];
      if (other == null) {
        other = await _userService.fetchAccountById(otherId);
        _userCache[otherId] = other;
      }
      final candidate = await _candidate.fetchByUserId(otherId);
      final msgs = await _chatService.fetchMessages(thread.idThread);
      final lastMsg = msgs.isNotEmpty ? msgs.last : null;
      final name = other.userName;
      final position = candidate.workPosition ?? '';
      final time =
          lastMsg != null ? DateFormat('HH:mm').format(lastMsg.sentAt) : '';
      final avatar = other.avatarUrl ?? 'assets/images/default_avatar.png';
      final online = other.accountStatus == 'active';
      chats.add({
        'idThread': thread.idThread,
        'idUser': otherId,
        'name': name,
        'position': position,
        'message': msgs,
        'time': time,
        'lastMsg': lastMsg != null ? lastMsg.content : '',
        'unread': lastMsg != null
                        ? !lastMsg.isRead && lastMsg.senderId != widget.recruiterId
                        : false,
        'avatar': avatar,
        'isOnline': online,
      });
    }
    return chats;
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      _searchQuery = "";
      _searchController.clear();
      _filteredChatList = applyFilterAndSearch(_chatList);
    });
  }

  void _filterChats(String query) {
    setState(() {
      _searchQuery = query.trim();
      _filteredChatList = applyFilterAndSearch(_chatList);
    });
  }

  /// Kết hợp Filter Tab và Search (theo name hoặc workPosition)
  List<Map<String, dynamic>> applyFilterAndSearch(
      List<Map<String, dynamic>> source) {
    var temp = List<Map<String, dynamic>>.from(source);

    // 1) Lọc theo Filter Tab
    if (_selectedFilter == 'Chưa đọc') {
      temp = temp.where((chat) => (chat['unread'] as bool) == true).toList();
    } else if (_selectedFilter == 'Nhóm') {
      // Ví dụ: temp = temp.where((chat) => chat['isGroup'] == true).toList();
      temp = [];
    }
    // Nếu 'Tất cả', không làm gì thêm

    // 2) Lọc theo tìm kiếm: tìm trong cả 'name' và 'position'
    if (_searchQuery.isNotEmpty) {
      final lowerQ = _searchQuery.toLowerCase();
      temp = temp.where((chat) {
        final name = (chat['name'] as String).toLowerCase();
        final position = (chat['position'] as String).toLowerCase();
        return name.contains(lowerQ) || position.contains(lowerQ);
      }).toList();
    }

    return temp;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    }
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
        leading: IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search),
          onPressed: _toggleSearch,
        ),
        actions: [
          if (!_isSearching) _buildAutoReplyButton(),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(height: 1, color: Colors.grey),
        ),
      ),
      body: Column(
        children: [
          // 1) Ô tìm kiếm (hiển thị khi _isSearching == true)
          if (_isSearching)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Tìm kiếm theo tên hoặc vị trí",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _filterChats('');
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                ),
                onChanged: _filterChats,
              ),
            ),

          // 2) Auto-reply banner (nếu bật)
          if (_autoReplyEnabled) _buildAutoReplyBanner(),

          // 3) Filter Tabs (luôn hiển thị)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(child: Center(child: _buildFilterTab("Tất cả"))),
                Expanded(child: Center(child: _buildFilterTab("Chưa đọc"))),
                Expanded(child: Center(child: _buildFilterTab("Nhóm"))),
              ],
            ),
          ),

          // 4) Danh sách chat (dựa trên _filteredChatList)
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadThreads,
              child: ListView.separated(
                itemCount: _filteredChatList.length,
                separatorBuilder: (context, index) =>
                    const Divider(height: 1, indent: 76),
                itemBuilder: (context, index) {
                  final chat = _filteredChatList[index];
                  return _buildChatTile(chat, context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoReplyButton() {
    return IconButton(
      icon: Icon(
        _autoReplyEnabled ? Icons.auto_awesome : Icons.auto_awesome_outlined,
        color: _autoReplyEnabled ? Colors.blue[700] : null,
      ),
      tooltip: "Chế độ tự động phản hồi",
      onPressed: () => _showAutoReplyDialog(),
    );
  }

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

  void _showAutoReplyDialog() {
    final TextEditingController messageController =
        TextEditingController(text: _autoReplyMessage);
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

  Widget _buildFilterTab(String title) {
    final isActive = title == _selectedFilter;
    final isDisabled = title == "Nhóm"; // 🔒 Tab nhóm bị khóa

    return GestureDetector(
      onTap: () {
        if (isDisabled) return; // 🔒 Không cho nhấn nếu là "Nhóm"
        setState(() {
          _selectedFilter = title;
          _filteredChatList = applyFilterAndSearch(_chatList);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isDisabled
              ? Colors.grey.shade200
              : (isActive ? Colors.blue[50] : Colors.transparent),
          borderRadius: BorderRadius.circular(20),
          border: isActive && !isDisabled
              ? Border.all(color: Colors.blue[700]!)
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isDisabled
                ? Colors.grey
                : (isActive ? Colors.blue[700] : Colors.grey[600]),
            fontWeight: isActive && !isDisabled ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildChatTile(Map<String, dynamic> chat, BuildContext context) {
    final String avatar = (chat['avatar'] as String?) ?? '';
    final String name = (chat['name'] as String?) ?? '';
    final String timeStr = (chat['time'] as String?) ?? '';
    final String pos = (chat['position'] as String?) ?? '';
    final String lastMsg = (chat['lastMsg'] as String?) ?? '';
    final bool unread = (chat['unread'] as bool?) ?? false;
    final bool online = (chat['isOnline'] as bool?) ?? false;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.transparent,
            child: Text(
              avatar.isNotEmpty ? avatar[0] : '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (online)
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
              name,
              style: TextStyle(
                fontWeight: unread ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            timeStr,
            style: TextStyle(
              color: unread ? Colors.blue[700] : Colors.grey,
              fontSize: 12,
              fontWeight: unread ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            pos,
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
                  lastMsg,
                  style: TextStyle(
                    color: unread ? Colors.black87 : Colors.grey[600],
                    fontWeight: unread ? FontWeight.w500 : FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              if (unread)
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
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (_) {
          return HrChatDetailScreen(
            chat: chat,
            recruiterId: widget.recruiterId,
            autoReplyEnabled: _autoReplyEnabled,
            autoReplyMessage: _autoReplyMessage,
          );
        }));
        await _loadThreads();
      },
    );
  }
}
