import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Danh sách thông báo giả lập (có thể thay thế bằng dữ liệu thực)
    final List<NotificationItem> notifications = [
      NotificationItem(
        title: 'Phỏng vấn mới',
        message: 'Bạn có một cuộc phỏng vấn mới vào ngày 05/04/2025',
        time: '2 giờ trước',
        isRead: false,
        icon: Icons.calendar_today,
        color: Colors.blue,
      ),
      NotificationItem(
        title: 'Hồ sơ đã được xem',
        message: 'Công ty ABC vừa xem hồ sơ của bạn',
        time: '1 ngày trước',
        isRead: true,
        icon: Icons.visibility,
        color: Colors.green,
      ),
      NotificationItem(
        title: 'Ứng tuyển thành công',
        message: 'Bạn đã ứng tuyển thành công vào vị trí Flutter Developer',
        time: '3 ngày trước',
        isRead: true,
        icon: Icons.check_circle,
        color: Colors.purple,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: Text(
          'Thông báo',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Hiển thị bộ lọc thông báo
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => _buildFilterOptions(),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Hiển thị menu tùy chọn
              _showOptionsMenu(context);
            },
          ),
        ],
      ),
      body:
          notifications.isEmpty
              ? _buildEmptyState()
              : _buildNotificationList(notifications),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_notification.png',
            height: 150,
            // Sử dụng hình ảnh thực tế từ assets
            // Hoặc thay thế bằng Icon nếu không có hình ảnh
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.notifications_off_outlined,
                size: 100,
                color: Colors.grey[400],
              );
            },
          ),
          SizedBox(height: 24),
          Text(
            'Không có thông báo mới',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Các thông báo về ứng tuyển và phỏng vấn sẽ xuất hiện tại đây',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              // Chuyển đến trang tìm kiếm công việc
            },
            child: Text(
              'Tìm kiếm cơ hội mới',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList(List<NotificationItem> notifications) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.white,
          child: Row(
            children: [
              Text(
                'Mới nhất',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  // Đánh dấu tất cả là đã đọc
                },
                child: Text('Đánh dấu tất cả đã đọc'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(top: 8),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _buildNotificationItem(notification);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.white : Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: notification.color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(notification.icon, color: notification.color, size: 24),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight:
                notification.isRead ? FontWeight.normal : FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              notification.message,
              style: TextStyle(color: Colors.black87, fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              notification.time,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          icon: Icon(Icons.more_horiz, color: Colors.grey[600]),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          itemBuilder:
              (context) => [
                PopupMenuItem(
                  // ignore: sort_child_properties_last
                  child: Text(
                    notification.isRead
                        ? 'Đánh dấu chưa đọc'
                        : 'Đánh dấu đã đọc',
                  ),
                  value: 'toggle_read',
                ),
                PopupMenuItem(
                  // ignore: sort_child_properties_last
                  child: Text('Xóa thông báo'),
                  value: 'delete',
                ),
              ],
          onSelected: (value) {
            // Xử lý hành động
          },
        ),
        onTap: () {
          // Xử lý khi người dùng nhấn vào thông báo
        },
      ),
    );
  }

  Widget _buildFilterOptions() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lọc thông báo',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          _buildFilterOption('Tất cả thông báo', true),
          _buildFilterOption('Chưa đọc', false),
          _buildFilterOption('Phỏng vấn', false),
          _buildFilterOption('Ứng tuyển', false),
          _buildFilterOption('Công việc đề xuất', false),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // Áp dụng bộ lọc
              },
              child: Text(
                'Áp dụng',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String title, bool isSelected) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey,
                width: 2,
              ),
              color: isSelected ? Colors.blue : Colors.transparent,
            ),
            child:
                isSelected
                    ? Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
          ),
          SizedBox(width: 12),
          Text(title, style: TextStyle(fontSize: 16, color: Colors.black87)),
        ],
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => SimpleDialog(
            title: Text('Tùy chọn'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  // Đánh dấu tất cả là đã đọc
                },
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Text('Đánh dấu tất cả đã đọc'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  // Xóa tất cả thông báo
                },
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Text('Xóa tất cả thông báo'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  // Mở cài đặt thông báo
                },
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Text('Cài đặt thông báo'),
              ),
            ],
          ),
    );
  }
}

// Model cho các thông báo
class NotificationItem {
  final String title;
  final String message;
  final String time;
  final bool isRead;
  final IconData icon;
  final Color color;

  NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.icon,
    required this.color,
  });
}
