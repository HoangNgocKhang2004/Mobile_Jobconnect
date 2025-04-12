import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  bool _showFilterOptions = false;
  String _currentFilter = "Tất cả";
  final List<String> _filterOptions = [
    "Tất cả",
    "Đang tuyển",
    "Đã đóng",
    "Lưu trữ",
  ];

  final List<Map<String, dynamic>> _jobList = [
    {
      'title': 'Senior Flutter Developer',
      'location': 'Hồ Chí Minh',
      'type': 'Toàn thời gian',
      'salary': '20-25 triệu',
      'applicants': 12,
      'views': 145,
      'status': 'Đang tuyển',
      'posted': '03/10/2023',
      'expires': '03/11/2023',
      'isUrgent': true,
    },
    {
      'title': 'UX/UI Designer',
      'location': 'Hà Nội',
      'type': 'Toàn thời gian',
      'salary': '15-20 triệu',
      'applicants': 8,
      'views': 97,
      'status': 'Đang tuyển',
      'posted': '28/09/2023',
      'expires': '28/10/2023',
      'isUrgent': false,
    },
    {
      'title': 'Product Manager',
      'location': 'Hồ Chí Minh',
      'type': 'Toàn thời gian',
      'salary': '30-35 triệu',
      'applicants': 5,
      'views': 63,
      'status': 'Đã đóng',
      'posted': '15/09/2023',
      'expires': '15/10/2023',
      'isUrgent': false,
    },
    {
      'title': 'React Native Developer',
      'location': 'Đà Nẵng',
      'type': 'Toàn thời gian',
      'salary': '18-22 triệu',
      'applicants': 7,
      'views': 82,
      'status': 'Đã đóng',
      'posted': '10/09/2023',
      'expires': '10/10/2023',
      'isUrgent': false,
    },
    {
      'title': 'Java Backend Developer',
      'location': 'Hồ Chí Minh',
      'type': 'Toàn thời gian',
      'salary': '25-30 triệu',
      'applicants': 10,
      'views': 120,
      'status': 'Lưu trữ',
      'posted': '05/09/2023',
      'expires': '05/10/2023',
      'isUrgent': true,
    },
    {
      'title': 'Full Stack Developer',
      'location': 'Hồ Chí Minh',
      'type': 'Toàn thời gian',
      'salary': '30-40 triệu',
      'applicants': 15,
      'views': 180,
      'status': 'Đang tuyển',
      'posted': '01/10/2023',
      'expires': '01/11/2023',
      'isUrgent': true,
    },
  ];

  List<Map<String, dynamic>> get _filteredJobs {
    if (_currentFilter == "Tất cả") {
      return _jobList;
    } else {
      return _jobList.where((job) => job['status'] == _currentFilter).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FC),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          title: Text(
            'Danh sách công việc',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black87,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Hiển thị tìm kiếm
              },
            ),
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                setState(() {
                  _showFilterOptions = !_showFilterOptions;
                });
              },
            ),
          ],
        ),
        body: Column(
          children: [
            if (_showFilterOptions) _buildFilterOptions(),
            _buildJobStatistics(),
            Expanded(child: _buildJobList()),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Chuyển đến trang tạo công việc mới
          },
          backgroundColor: const Color(0xFF3366FF),
          icon: const Icon(Icons.add),
          label: const Text("Tạo công việc mới"),
        ),
      ),
    );
  }

  Widget _buildFilterOptions() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Lọc theo trạng thái:",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  _filterOptions.map((filter) {
                    bool isSelected = _currentFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _currentFilter = filter;
                            });
                          }
                        },
                        // ignore: deprecated_member_use
                        selectedColor: const Color(0xFF3366FF).withOpacity(0.2),
                        labelStyle: TextStyle(
                          color:
                              isSelected
                                  ? const Color(0xFF3366FF)
                                  : Colors.black87,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobStatistics() {
    // Tính tổng số công việc cho mỗi trạng thái
    int activeJobs =
        _jobList.where((job) => job['status'] == 'Đang tuyển').length;
    int closedJobs = _jobList.where((job) => job['status'] == 'Đã đóng').length;
    int archivedJobs =
        _jobList.where((job) => job['status'] == 'Lưu trữ').length;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tổng quan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.work,
                    iconColor: const Color(0xFF3366FF),
                    title: "Tổng số",
                    count: _jobList.length.toString(),
                    backgroundColor: const Color(0xFFE6EFFF),
                    showBadge: false,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.check_circle_outline,
                    iconColor: Colors.green,
                    title: "Đang tuyển",
                    count: activeJobs.toString(),
                    // ignore: deprecated_member_use
                    backgroundColor: Colors.green.withOpacity(0.1),
                    showBadge: activeJobs > 0,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.block,
                    iconColor: Colors.red,
                    title: "Đã đóng",
                    count: closedJobs.toString(),
                    // ignore: deprecated_member_use
                    backgroundColor: Colors.red.withOpacity(0.1),
                    showBadge: false,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.archive_outlined,
                    iconColor: Colors.grey,
                    title: "Lưu trữ",
                    count: archivedJobs.toString(),
                    // ignore: deprecated_member_use
                    backgroundColor: Colors.grey.withOpacity(0.1),
                    showBadge: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String count,
    required Color backgroundColor,
    required bool showBadge,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              if (showBadge) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: iconColor, width: 1.5),
                  ),
                  child: Text(
                    "!",
                    style: TextStyle(
                      color: iconColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.black87),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildJobList() {
    return _filteredJobs.isEmpty
        ? _buildEmptyState()
        : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _filteredJobs.length,
          itemBuilder: (context, index) {
            final job = _filteredJobs[index];
            return _buildJobCard(job);
          },
        );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            "Không tìm thấy công việc nào",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Hãy thử bỏ bộ lọc hoặc tạo công việc mới",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    Color statusColor;
    Widget statusIcon;

    switch (job['status']) {
      case 'Đang tuyển':
        statusColor = Colors.green;
        statusIcon = const Icon(
          Icons.check_circle_outline,
          size: 16,
          color: Colors.green,
        );
        break;
      case 'Đã đóng':
        statusColor = Colors.red;
        statusIcon = const Icon(Icons.block, size: 16, color: Colors.red);
        break;
      case 'Lưu trữ':
        statusColor = Colors.grey;
        statusIcon = const Icon(
          Icons.archive_outlined,
          size: 16,
          color: Colors.grey,
        );
        break;
      default:
        statusColor = Colors.blue;
        statusIcon = const Icon(
          Icons.info_outline,
          size: 16,
          color: Colors.blue,
        );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: const Color(0xFF3366FF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.work_outline,
                        color: Color(0xFF3366FF),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (job['isUrgent'])
                                Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    // ignore: deprecated_member_use
                                    color: Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.priority_high,
                                        color: Colors.red,
                                        size: 12,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "Gấp",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Expanded(
                                child: Text(
                                  job['title'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                job['location'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                job['type'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              // ignore: deprecated_member_use
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                statusIcon,
                                const SizedBox(width: 4),
                                Text(
                                  job['status'],
                                  style: TextStyle(
                                    color: statusColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: Colors.grey.shade700),
                      itemBuilder:
                          (BuildContext context) => <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 18),
                                  SizedBox(width: 8),
                                  Text('Chỉnh sửa'),
                                ],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'status',
                              child: Row(
                                children: [
                                  Icon(Icons.swap_horiz, size: 18),
                                  SizedBox(width: 8),
                                  Text('Thay đổi trạng thái'),
                                ],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'duplicate',
                              child: Row(
                                children: [
                                  Icon(Icons.content_copy, size: 18),
                                  SizedBox(width: 8),
                                  Text('Nhân bản'),
                                ],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Xóa',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.payments_outlined,
                        label: job['salary'],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.calendar_today_outlined,
                        label: "Đăng: ${job['posted']}",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.event_busy_outlined,
                        label: "Hết hạn: ${job['expires']}",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${job['applicants']} ứng viên",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.visibility_outlined,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${job['views']} lượt xem",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // Xem chi tiết công việc
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3366FF),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text("Xem chi tiết"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({required IconData icon, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
