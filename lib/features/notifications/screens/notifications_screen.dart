import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.checklist), onPressed: () {}),
          IconButton(icon: const Icon(Icons.delete_outline), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotificationCard(
            icon: Icons.work_outline,
            title: 'Công ty ABC đã xem hồ sơ của bạn',
            subtitle: 'Vị trí: Senior Flutter Developer',
            time: '2 giờ trước',
            isRead: false,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            icon: Icons.calendar_today_outlined,
            title: 'Lịch phỏng vấn mới',
            subtitle: 'Công ty XYZ - 15:00 ngày 20/03/2024',
            time: '5 giờ trước',
            isRead: false,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            icon: Icons.check_circle_outline,
            title: 'Đơn ứng tuyển đã được chấp nhận',
            subtitle: 'Vị trí: Mobile Developer tại Công ty DEF',
            time: '1 ngày trước',
            isRead: true,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            icon: Icons.bookmark_outline,
            title: 'Việc làm đã lưu sắp hết hạn',
            subtitle: 'Vị trí: UI/UX Designer tại Công ty GHI',
            time: '2 ngày trước',
            isRead: true,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            icon: Icons.update_outlined,
            title: 'Cập nhật trạng thái ứng tuyển',
            subtitle: 'Vị trí: Backend Developer tại Công ty JKL',
            time: '3 ngày trước',
            isRead: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required bool isRead,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isRead ? Colors.grey[200] : Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isRead ? Colors.grey[600] : Colors.blue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            isRead ? FontWeight.normal : FontWeight.w500,
                        color: isRead ? Colors.grey[800] : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              if (!isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
