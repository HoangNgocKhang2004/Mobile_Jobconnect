import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Candidate {
  final String id;
  final String name;
  final String position;
  final String avatarUrl;
  final DateTime applicationDate;
  final String
  status; // 'new', 'reviewing', 'interviewed', 'offered', 'rejected'
  final int experienceYears;
  final List<String> skills;

  Candidate({
    required this.id,
    required this.name,
    required this.position,
    required this.avatarUrl,
    required this.applicationDate,
    required this.status,
    required this.experienceYears,
    required this.skills,
  });
}

class CandidateListPage extends StatefulWidget {
  const CandidateListPage({super.key});

  @override
  State<CandidateListPage> createState() => _CandidateListPageState();
}

class _CandidateListPageState extends State<CandidateListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Tất cả';
  final List<String> _filters = [
    'Tất cả',
    'Mới nhất',
    'Đang xem xét',
    'Đã phỏng vấn',
    'Đã đề xuất',
    'Từ chối',
  ];

  // Mock data - Thay thế bằng dữ liệu thực từ API
  final List<Candidate> _candidates = [
    Candidate(
      id: '001',
      name: 'Nguyễn Văn A',
      position: 'Nhân viên bán hàng',
      avatarUrl: '',
      applicationDate: DateTime.now().subtract(const Duration(days: 2)),
      status: 'new',
      experienceYears: 2,
      skills: ['Giao tiếp', 'CSKH', 'MS Office'],
    ),
    Candidate(
      id: '002',
      name: 'Trần Thị B',
      position: 'Kế toán',
      avatarUrl: '',
      applicationDate: DateTime.now().subtract(const Duration(days: 5)),
      status: 'reviewing',
      experienceYears: 3,
      skills: ['Báo cáo tài chính', 'Excel', 'IFRS'],
    ),
    Candidate(
      id: '003',
      name: 'Lê Văn C',
      position: 'Lập trình viên Flutter',
      avatarUrl: '',
      applicationDate: DateTime.now().subtract(const Duration(days: 7)),
      status: 'interviewed',
      experienceYears: 4,
      skills: ['Flutter', 'Dart', 'Firebase', 'REST API'],
    ),
    Candidate(
      id: '004',
      name: 'Phạm Thị D',
      position: 'Thiết kế UI/UX',
      avatarUrl: '',
      applicationDate: DateTime.now().subtract(const Duration(days: 10)),
      status: 'offered',
      experienceYears: 5,
      skills: ['Figma', 'Adobe XD', 'Sketch'],
    ),
    Candidate(
      id: '005',
      name: 'Hoàng Văn E',
      position: 'Nhân viên marketing',
      avatarUrl: '',
      applicationDate: DateTime.now().subtract(const Duration(days: 15)),
      status: 'rejected',
      experienceYears: 1,
      skills: ['SEO', 'Content Marketing', 'Google Analytics'],
    ),
    Candidate(
      id: '006',
      name: 'Đỗ Thị F',
      position: 'Nhân viên bán hàng',
      avatarUrl: '',
      applicationDate: DateTime.now().subtract(const Duration(days: 3)),
      status: 'new',
      experienceYears: 0,
      skills: ['Giao tiếp', 'Tiếng Anh'],
    ),
    Candidate(
      id: '007',
      name: 'Ngô Văn G',
      position: 'Kỹ sư phần mềm',
      avatarUrl: '',
      applicationDate: DateTime.now().subtract(const Duration(days: 8)),
      status: 'interviewed',
      experienceYears: 7,
      skills: ['Java', 'Spring Boot', 'Microservices'],
    ),
    Candidate(
      id: '008',
      name: 'Vũ Thị H',
      position: 'Nhân viên HR',
      avatarUrl: '',
      applicationDate: DateTime.now().subtract(const Duration(days: 12)),
      status: 'reviewing',
      experienceYears: 3,
      skills: ['Tuyển dụng', 'Đào tạo', 'Quản lý nhân sự'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Candidate> get _filteredCandidates {
    List<Candidate> result = _candidates;

    // Áp dụng bộ lọc trạng thái
    if (_selectedFilter != 'Tất cả') {
      String statusFilter = '';
      switch (_selectedFilter) {
        case 'Mới nhất':
          statusFilter = 'new';
          break;
        case 'Đang xem xét':
          statusFilter = 'reviewing';
          break;
        case 'Đã phỏng vấn':
          statusFilter = 'interviewed';
          break;
        case 'Đã đề xuất':
          statusFilter = 'offered';
          break;
        case 'Từ chối':
          statusFilter = 'rejected';
          break;
      }
      result = result.where((c) => c.status == statusFilter).toList();
    }

    // Áp dụng tìm kiếm
    if (_searchQuery.isNotEmpty) {
      result =
          result
              .where(
                (c) =>
                    c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    c.position.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    c.skills.any(
                      (skill) => skill.toLowerCase().contains(
                        _searchQuery.toLowerCase(),
                      ),
                    ),
              )
              .toList();
    }

    return result;
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'new':
        return 'Mới';
      case 'reviewing':
        return 'Đang xem xét';
      case 'interviewed':
        return 'Đã phỏng vấn';
      case 'offered':
        return 'Đã đề xuất';
      case 'rejected':
        return 'Từ chối';
      default:
        return 'Không xác định';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'new':
        return Colors.blue;
      case 'reviewing':
        return Colors.orange;
      case 'interviewed':
        return Colors.purple;
      case 'offered':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Quản lý ứng viên",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF3366FF)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Tìm kiếm ứng viên',
            onPressed: () {
              _showSearchDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Lọc ứng viên',
            onPressed: () {
              _showFilterDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Thêm ứng viên mới',
            onPressed: () {
              // Hiển thị form thêm ứng viên mới
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Thống kê số lượng
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard(
                      'Tổng số',
                      _candidates.length.toString(),
                      const Color(0xFF3366FF),
                      Icons.people,
                    ),
                    _buildStatCard(
                      'Mới',
                      _candidates
                          .where((c) => c.status == 'new')
                          .length
                          .toString(),
                      const Color(0xFF42A5F5),
                      Icons.fiber_new,
                    ),
                    _buildStatCard(
                      'Đã PV',
                      _candidates
                          .where((c) => c.status == 'interviewed')
                          .length
                          .toString(),
                      const Color(0xFF7C4DFF),
                      Icons.mic,
                    ),
                    _buildStatCard(
                      'Đã chọn',
                      _candidates
                          .where((c) => c.status == 'offered')
                          .length
                          .toString(),
                      const Color(0xFF4CAF50),
                      Icons.check_circle,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: const Color(0xFF3366FF),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF3366FF),
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: "Tất cả"),
                Tab(text: "Mới"),
                Tab(text: "Đang xem xét"),
                Tab(text: "Đã phỏng vấn"),
                Tab(text: "Đã đề xuất"),
              ],
            ),
          ),

          // Danh sách ứng viên
          Expanded(
            child: Container(
              color: Colors.grey.shade50,
              child:
                  _filteredCandidates.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Không tìm thấy ứng viên nào",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                      : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildCandidateList(_filteredCandidates),
                          _buildCandidateList(
                            _filteredCandidates
                                .where((c) => c.status == 'new')
                                .toList(),
                          ),
                          _buildCandidateList(
                            _filteredCandidates
                                .where((c) => c.status == 'reviewing')
                                .toList(),
                          ),
                          _buildCandidateList(
                            _filteredCandidates
                                .where((c) => c.status == 'interviewed')
                                .toList(),
                          ),
                          _buildCandidateList(
                            _filteredCandidates
                                .where((c) => c.status == 'offered')
                                .toList(),
                          ),
                        ],
                      ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF3366FF),
        icon: const Icon(Icons.add),
        label: const Text(
          "Thêm ứng viên",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 4,
        onPressed: () {
          // Hiển thị form thêm ứng viên mới
        },
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String count,
    Color color,
    IconData icon,
  ) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCandidateList(List<Candidate> candidates) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: candidates.length,
      itemBuilder: (context, index) {
        final candidate = candidates[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              // Chuyển đến trang chi tiết ứng viên
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        // ignore: deprecated_member_use
                        backgroundColor: _getStatusColor(
                          candidate.status,
                        ).withOpacity(0.1),
                        radius: 28,
                        child:
                            candidate.avatarUrl.isEmpty
                                ? Text(
                                  candidate.name.substring(0, 1).toUpperCase(),
                                  style: TextStyle(
                                    color: _getStatusColor(candidate.status),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                )
                                : null, // Hiển thị ảnh avatar nếu có
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              candidate.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              candidate.position,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: _getStatusColor(
                            candidate.status,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _getStatusText(candidate.status),
                          style: TextStyle(
                            fontSize: 12,
                            color: _getStatusColor(candidate.status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildInfoChip(
                        Icons.calendar_today,
                        DateFormat(
                          'dd/MM/yyyy',
                        ).format(candidate.applicationDate),
                      ),
                      const SizedBox(width: 12),
                      _buildInfoChip(
                        Icons.work,
                        '${candidate.experienceYears} năm KN',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        candidate.skills
                            .map(
                              (skill) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: Text(
                                  skill,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.email_outlined, size: 16),
                        label: const Text('Liên hệ'),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF3366FF),
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        icon: const Icon(Icons.visibility_outlined, size: 16),
                        label: const Text('Xem chi tiết'),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF3366FF),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Lọc ứng viên'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Chọn trạng thái:'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          _filters.map((filter) {
                            return ChoiceChip(
                              label: Text(filter),
                              selected: _selectedFilter == filter,
                              // ignore: deprecated_member_use
                              selectedColor: const Color(
                                0xFF3366FF,
                              ).withOpacity(0.1),
                              labelStyle: TextStyle(
                                color:
                                    _selectedFilter == filter
                                        ? const Color(0xFF3366FF)
                                        : Colors.black87,
                                fontWeight:
                                    _selectedFilter == filter
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                              onSelected: (selected) {
                                setState(() {
                                  _selectedFilter = filter;
                                });
                              },
                            );
                          }).toList(),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // ignore: unnecessary_this
                this.setState(() {}); // Cập nhật UI chính
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3366FF),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Áp dụng'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tìm kiếm ứng viên'),
          content: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Nhập tên, vị trí, kỹ năng...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF3366FF)),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: (value) {
              _searchQuery = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {}); // Cập nhật UI chính
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3366FF),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Tìm kiếm'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }
}
