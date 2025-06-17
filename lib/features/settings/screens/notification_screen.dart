import 'package:flutter/material.dart';
import 'package:job_connect/core/services/job_posting_service.dart';
import 'package:job_connect/core/services/job_transaction_service.dart';
import 'package:job_connect/core/services/job_application_service.dart';
import 'package:job_connect/core/services/interviewschedule_service.dart';
import 'package:job_connect/core/models/job_posting_model.dart';
import 'package:job_connect/core/models/job_transaction_model.dart';
import 'package:job_connect/core/models/job_application_model.dart';
import 'package:job_connect/core/models/interview_schedule_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final JobPostingService _jobPostingService = JobPostingService();
  final JobtransactionService _jobTransactionService = JobtransactionService();
  final JobApplicationService _jobApplicationService = JobApplicationService();
  final InterviewScheduleService _interviewScheduleService = InterviewScheduleService();

  List<NotificationItem> notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      // Lấy thông báo từ các service
      final jobPostings = await _jobPostingService.fetchJobPostingsByCompanyId('companyId');
      final jobTransactions = await _jobTransactionService.fetchJobTransactions();
      final jobApplications = await _jobApplicationService.fetchByJob('jobId');
      final interviewSchedules = await _interviewScheduleService.fetchInterviewScheduleAll();

      // Tạo danh sách thông báo
      final List<NotificationItem> tempNotifications = [];

      // Thông báo đăng tuyển thành công
      for (var job in jobPostings) {
        tempNotifications.add(NotificationItem(
          title: 'Đăng tuyển thành công',
          message: 'Công việc "${job.title}" đã được đăng tuyển thành công.',
          time: _formatTime(job.createdAt),
          isRead: false,
          icon: Icons.work,
          color: Colors.blue,
        ));
      }

      // Thông báo giao dịch thành công
      for (var transaction in jobTransactions) {
        tempNotifications.add(NotificationItem(
          title: 'Giao dịch thành công',
          message: 'Giao dịch với số tiền ${transaction.amount} đã được thực hiện thành công.',
          time: _formatTime(transaction.transactionDate),
          isRead: false,
          icon: Icons.attach_money,
          color: Colors.green,
        ));
      }

      // Thông báo có người ứng tuyển
      for (var application in jobApplications) {
        tempNotifications.add(NotificationItem(
          title: 'Có người ứng tuyển',
          message: 'Người dùng ${application.idUser} đã ứng tuyển vào công việc.',
          time: _formatTime(application.submittedAt),
          isRead: false,
          icon: Icons.person_add,
          color: Colors.orange,
        ));
      }

      // Thông báo lịch phỏng vấn
      for (var schedule in interviewSchedules) {
        tempNotifications.add(NotificationItem(
          title: 'Lịch phỏng vấn mới',
          message: 'Lịch phỏng vấn vào ngày ${schedule.interviewDate.toLocal()} đã được tạo.',
          time: _formatTime(schedule.interviewDate),
          isRead: false,
          icon: Icons.calendar_today,
          color: Colors.purple,
        ));
      }

      setState(() {
        notifications = tempNotifications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải thông báo: $e')),
      );
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else {
      return '${difference.inDays} ngày trước';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          'Thông báo',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? _buildEmptyState()
              : _buildNotificationList(notifications),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 120, color: Colors.grey[400]),
          const SizedBox(height: 24),
          const Text(
            'Không có thông báo mới',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList(List<NotificationItem> notifications) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationItem(notification);
      },
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            notification.isRead = true;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: notification.color.withOpacity(0.1),
                child: Icon(notification.icon, color: notification.color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                notification.time,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Model cho thông báo
class NotificationItem {
  final String title;
  final String message;
  final String time;
  bool isRead;
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