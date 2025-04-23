import 'package:flutter/material.dart';

class JobHistoryScreen extends StatelessWidget {
  const JobHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Lịch sử ứng tuyển',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildStatsSummary(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                children: [
                  const Text(
                    'Việc làm đã ứng tuyển',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildJobHistoryList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSummary() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(count: '5', label: 'Tổng số', color: Colors.blue),
          _buildVerticalDivider(),
          _buildStatItem(count: '1', label: 'Đang xét', color: Colors.orange),
          _buildVerticalDivider(),
          _buildStatItem(count: '1', label: 'Đã nhận', color: Colors.green),
          _buildVerticalDivider(),
          _buildStatItem(count: '3', label: 'Đã đóng', color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    // ignore: deprecated_member_use
    return Container(height: 40, width: 1, color: Colors.grey.withOpacity(0.3));
  }

  Widget _buildStatItem({
    required String count,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildJobHistoryList() {
    // Hardcoded job data - in a real app, this would come from an API or database
    final List<Map<String, dynamic>> jobs = [
      {
        'title': 'Senior Flutter Developer',
        'company': 'FPT Software',
        'appliedDate': '15/03/2024',
        'status': 'Đang xem xét',
        'logoUrl':
            'assets/images/company_logo.png', // Using local asset instead of network image
        'location': 'Hà Nội, Việt Nam',
        'salary': '30-40 triệu',
      },
      {
        'title': 'Mobile Developer (Flutter)',
        'company': 'VNG Corporation',
        'appliedDate': '10/03/2024',
        'status': 'Đã phỏng vấn',
        'logoUrl': 'assets/images/company_logo.png',
        'location': 'TP. Hồ Chí Minh',
        'salary': '25-35 triệu',
      },
      {
        'title': 'Flutter Developer',
        'company': 'Tiki Corporation',
        'appliedDate': '05/03/2024',
        'status': 'Đã từ chối',
        'logoUrl': 'assets/images/company_logo.png',
        'location': 'TP. Hồ Chí Minh',
        'salary': '20-30 triệu',
      },
      {
        'title': 'Flutter Team Lead',
        'company': 'Momo',
        'appliedDate': '01/03/2024',
        'status': 'Đã nhận việc',
        'logoUrl': 'assets/images/company_logo.png',
        'location': 'TP. Hồ Chí Minh',
        'salary': '40-50 triệu',
      },
      {
        'title': 'Junior Flutter Developer',
        'company': 'Tech Startup XYZ',
        'appliedDate': '25/02/2024',
        'status': 'Đã hết hạn',
        'logoUrl': 'assets/images/company_logo.png',
        'location': 'Đà Nẵng',
        'salary': '15-20 triệu',
      },
    ];

    // Using ListView.separated for better performance
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: jobs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final job = jobs[index];
        return _buildJobHistoryCard(
          title: job['title'],
          company: job['company'],
          appliedDate: job['appliedDate'],
          status: job['status'],
          logoUrl: job['logoUrl'],
          location: job['location'],
          salary: job['salary'],
        );
      },
    );
  }

  Widget _buildJobHistoryCard({
    required String title,
    required String company,
    required String appliedDate,
    required String status,
    required String logoUrl,
    required String location,
    required String salary,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phần tiêu đề job
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo công ty
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child:
                        logoUrl.startsWith('http')
                            ? Image.network(
                              logoUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Text(
                                    company[0],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            )
                            : Image.asset(
                              'assets/images/logohuit.png',
                              fit: BoxFit.cover,
                            ),
                  ),
                ),
                const SizedBox(width: 10),
                // Thông tin job
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        company,
                        style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                // Status chip
                _buildStatusChip(status),
              ],
            ),
            const SizedBox(height: 12),

            // Thông tin location và salary
            Row(
              children: [
                // Location
                Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    location,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                // Salary
                Icon(Icons.monetization_on, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 3),
                Text(
                  salary,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),

            const Divider(height: 20),

            // Thông tin ngày ứng tuyển và nút hành động
            Row(
              children: [
                // Ngày ứng tuyển
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          'Đã ứng tuyển: $appliedDate',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                // Các nút hành động
                _buildActionButtons(status),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(String status) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 28,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.blue[700],
              side: BorderSide(color: Colors.blue[700]!),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Xem chi tiết', style: TextStyle(fontSize: 11)),
          ),
        ),
        const SizedBox(width: 8),
        if (status == 'Đang xem xét')
          SizedBox(
            height: 28,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red[700],
                side: BorderSide(color: Colors.red[700]!),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Hủy ứng tuyển',
                style: TextStyle(fontSize: 11),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    IconData statusIcon;
    Color chipColor;
    Color textColor;
    String displayText;

    switch (status) {
      case 'Đang xem xét':
        statusIcon = Icons.hourglass_top;
        chipColor = Colors.blue[50]!;
        textColor = Colors.blue[700]!;
        displayText = 'Đang xem xét';
        break;
      case 'Đã phỏng vấn':
        statusIcon = Icons.person;
        chipColor = Colors.orange[50]!;
        textColor = Colors.orange[700]!;
        displayText = 'Đã phỏng vấn';
        break;
      case 'Đã từ chối':
        statusIcon = Icons.cancel;
        chipColor = Colors.red[50]!;
        textColor = Colors.red[700]!;
        displayText = 'Đã từ chối';
        break;
      case 'Đã nhận việc':
        statusIcon = Icons.check_circle;
        chipColor = Colors.green[50]!;
        textColor = Colors.green[700]!;
        displayText = 'Đã nhận';
        break;
      default:
        statusIcon = Icons.access_time;
        chipColor = Colors.grey[100]!;
        textColor = Colors.grey[700]!;
        displayText = 'Đã hết hạn';
    }

    // Sử dụng icon riêng cho một số trạng thái để tiết kiệm không gian
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 10, color: textColor),
          const SizedBox(width: 3),
          Text(
            displayText,
            style: TextStyle(
              color: textColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
