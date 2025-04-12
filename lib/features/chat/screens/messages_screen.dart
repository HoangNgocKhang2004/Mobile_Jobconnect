import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tin nhắn'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search messages
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Show message options
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMessageCard(
            avatar: 'https://picsum.photos/200',
            name: 'Công ty ABC',
            lastMessage: 'Chào bạn, chúng tôi đã xem hồ sơ của bạn...',
            time: '2 giờ trước',
            unreadCount: 2,
            isOnline: true,
            onTap: () {
              // TODO: Navigate to chat screen
            },
          ),
          const SizedBox(height: 12),
          _buildMessageCard(
            avatar: 'https://picsum.photos/201',
            name: 'Công ty XYZ',
            lastMessage: 'Bạn có thể đến phỏng vấn vào 15:00 ngày 20/03/2024',
            time: '5 giờ trước',
            unreadCount: 0,
            isOnline: false,
            onTap: () {
              // TODO: Navigate to chat screen
            },
          ),
          const SizedBox(height: 12),
          _buildMessageCard(
            avatar: 'https://picsum.photos/202',
            name: 'Công ty DEF',
            lastMessage: 'Chúc mừng bạn đã trúng tuyển vị trí Mobile Developer',
            time: '1 ngày trước',
            unreadCount: 0,
            isOnline: true,
            onTap: () {
              // TODO: Navigate to chat screen
            },
          ),
          const SizedBox(height: 12),
          _buildMessageCard(
            avatar: 'https://picsum.photos/203',
            name: 'Công ty GHI',
            lastMessage: 'Cảm ơn bạn đã quan tâm đến vị trí UI/UX Designer',
            time: '2 ngày trước',
            unreadCount: 0,
            isOnline: false,
            onTap: () {
              // TODO: Navigate to chat screen
            },
          ),
          const SizedBox(height: 12),
          _buildMessageCard(
            avatar: 'https://picsum.photos/204',
            name: 'Công ty JKL',
            lastMessage: 'Chúng tôi sẽ liên hệ với bạn sớm nhất có thể',
            time: '3 ngày trước',
            unreadCount: 0,
            isOnline: false,
            onTap: () {
              // TODO: Navigate to chat screen
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to new message screen
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildMessageCard({
    required String avatar,
    required String name,
    required String lastMessage,
    required String time,
    required int unreadCount,
    required bool isOnline,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(avatar),
                  ),
                  if (isOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lastMessage,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (unreadCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 