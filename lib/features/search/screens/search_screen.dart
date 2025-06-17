import 'package:flutter/material.dart';
import 'package:job_connect/features/job/screens/apply_job_screen.dart';
import 'package:job_connect/features/job/screens/hr_job_detail_screen.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  bool _showClearButton = false;
  final List<Map<String, dynamic>> _jobList = [
    {
      "title": "Lập trình viên Flutter",
      "company": "Tech Solutions",
      "location": "TP. Hồ Chí Minh",
      "salary": "15-25 triệu",
      "type": "Toàn thời gian",
      "isRemote": true,
      "postedDate": "2 ngày trước",
      "isFeatured": true,
    },
    {
      "title": "Chuyên viên AI",
      "company": "DataTech",
      "location": "Hà Nội",
      "salary": "30-45 triệu",
      "type": "Toàn thời gian",
      "isRemote": false,
      "postedDate": "3 ngày trước",
      "isFeatured": true,
    },
    {
      "title": "Kỹ sư dữ liệu",
      "company": "BigData Corp",
      "location": "Đà Nẵng",
      "salary": "25-35 triệu",
      "type": "Toàn thời gian",
      "isRemote": true,
      "postedDate": "1 tuần trước",
      "isFeatured": false,
    },
    {
      "title": "Nhà phân tích hệ thống",
      "company": "System Analysis Inc",
      "location": "TP. Hồ Chí Minh",
      "salary": "20-30 triệu",
      "type": "Toàn thời gian",
      "isRemote": false,
      "postedDate": "3 tuần trước",
      "isFeatured": false,
    },
    {
      "title": "Thiết kế UI/UX",
      "company": "Creative Design",
      "location": "TP. Hồ Chí Minh",
      "salary": "18-28 triệu",
      "type": "Toàn thời gian",
      "isRemote": true,
      "postedDate": "5 ngày trước",
      "isFeatured": true,
    },
    {
      "title": "Marketing Digital",
      "company": "Digital Marketing Pro",
      "location": "Hà Nội",
      "salary": "15-25 triệu",
      "type": "Toàn thời gian",
      "isRemote": false,
      "postedDate": "1 tuần trước",
      "isFeatured": false,
    },
    {
      "title": "Nhà phát triển Back-end",
      "company": "Server Solutions",
      "location": "TP. Hồ Chí Minh",
      "salary": "25-40 triệu",
      "type": "Toàn thời gian",
      "isRemote": true,
      "postedDate": "2 tuần trước",
      "isFeatured": true,
    },
  ];

  List<Map<String, dynamic>> _filteredJobs = [];
  final List<String> _recentSearches = [
    'Flutter',
    'AI',
    'Marketing',
    'Python',
    'UI/UX',
  ];

  final List<String> _locations = [
    'Tất cả',
    'TP. Hồ Chí Minh',
    'Hà Nội',
    'Đà Nẵng',
  ];
  final List<String> _jobTypes = [
    'Tất cả',
    'Toàn thời gian',
    'Bán thời gian',
    'Freelance',
    'Remote',
  ];
  final List<String> _experienceLevels = [
    'Tất cả',
    'Mới tốt nghiệp',
    '1-3 năm',
    '3-5 năm',
    '5+ năm',
  ];
  final List<String> _salaryRanges = [
    'Tất cả',
    'Dưới 15 triệu',
    '15-25 triệu',
    '25-40 triệu',
    'Trên 40 triệu',
  ];

  String _selectedLocation = 'Tất cả';
  String _selectedJobType = 'Tất cả';
  String _selectedExperience = 'Tất cả';
  String _selectedSalary = 'Tất cả';
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _filteredJobs = List.from(_jobList);
    _tabController = TabController(length: 3, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _showClearButton = _searchController.text.isNotEmpty;
      });
      _filterJobs();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _filterJobs() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredJobs =
          _jobList.where((job) {
            // Apply text search
            final matchesQuery =
                job['title'].toLowerCase().contains(query) ||
                job['company'].toLowerCase().contains(query);

            // Apply location filter
            final matchesLocation =
                _selectedLocation == 'Tất cả' ||
                job['location'] == _selectedLocation;

            // Apply job type filter
            final matchesJobType =
                _selectedJobType == 'Tất cả' ||
                job['type'] == _selectedJobType ||
                (_selectedJobType == 'Remote' && job['isRemote'] == true);

            // For demonstration purposes, assume all jobs match the experience and salary filters
            // In a real app, you'd check against actual job attributes

            return matchesQuery && matchesLocation && matchesJobType;
          }).toList();
    });
  }

  // ignore: unused_element
  void _addToRecentSearches(String query) {
    if (query.isNotEmpty && !_recentSearches.contains(query)) {
      setState(() {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 5) {
          _recentSearches.removeLast();
        }
      });
    }
  }

  void _resetFilters() {
    setState(() {
      _selectedLocation = 'Tất cả';
      _selectedJobType = 'Tất cả';
      _selectedExperience = 'Tất cả';
      _selectedSalary = 'Tất cả';
      _filterJobs();
    });
  }

  void _applyFilters() {
    _filterJobs();
    setState(() {
      _showFilters = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            MediaQuery.of(context).size.height * 0.28,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [const Color(0xFF2196F3), const Color(0xFF1976D2)],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tìm kiếm công việc',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tìm cơ hội nghề nghiệp tốt nhất cho bạn',
                                    style: TextStyle(
                                      // ignore: deprecated_member_use
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 12),
                                Container(
                                  decoration: BoxDecoration(
                                    // ignore: deprecated_member_use
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.smart_toy,
                                      color: Colors.white,
                                      size: 26,
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: SearchBar(
                                  controller: _searchController,
                                  onSubmitted: (value) {
                                    _filterJobs();
                                  },
                                  trailing: [
                                    // Nút tìm kiếm bằng giọng nói
                                    IconButton(
                                      icon: const Icon(
                                        Icons.mic,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        // Xử lý chức năng tìm kiếm bằng giọng nói
                                        _startVoiceSearch();
                                      },
                                      tooltip: 'Tìm kiếm bằng giọng nói',
                                    ),
                                    // Nút xóa chỉ hiển thị khi có văn bản
                                    if (_showClearButton)
                                      IconButton(
                                        icon: const Icon(
                                          Icons.clear,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          _searchController.clear();
                                          _filterJobs();
                                        },
                                      ),
                                  ],
                                  hintText: "Chức danh, kỹ năng hoặc công ty",
                                  hintStyle: WidgetStateProperty.all(
                                    const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                  ),
                                  backgroundColor: WidgetStateProperty.all(
                                    Colors.white,
                                  ),
                                  elevation: WidgetStateProperty.all(0),
                                  padding: WidgetStateProperty.all(
                                    const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 0,
                                    ),
                                  ),
                                  leading: const Icon(
                                    Icons.search,
                                    color: Colors.blue,
                                  ),
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue[800],
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.tune,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showFilters = !_showFilters;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.white,
                    // ignore: deprecated_member_use
                    unselectedLabelColor: Colors.white.withOpacity(0.7),
                    indicatorColor: Colors.white,
                    indicatorWeight: 3,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    tabs: const [
                      Tab(text: "NỔI BẬT"),
                      Tab(text: "MỚI NHẤT"),
                      Tab(text: "ĐÃ LƯU"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            TabBarView(
              controller: _tabController,
              children: [
                _buildJobListView(),
                _buildJobListView(sortByNewest: true),
                _buildSavedJobsView(),
              ],
            ),
            if (_showFilters) _buildFiltersPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildJobListView({bool sortByNewest = false}) {
    final jobsToShow = List<Map<String, dynamic>>.from(_filteredJobs);

    if (sortByNewest) {
      // In a real app, you would sort by actual date - this is just for demo
      jobsToShow.sort((a, b) => a['postedDate'].compareTo(b['postedDate']));
    }

    if (jobsToShow.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 60,
                color: Colors.blue.shade300,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Không tìm thấy kết quả',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Hãy thử tìm kiếm với từ khóa khác',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: jobsToShow.length,
      itemBuilder: (context, index) {
        final job = jobsToShow[index];
        return _buildJobCard(job);
      },
    );
  }

  Widget _buildSavedJobsView() {
    // For demo purposes, just show a message
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 24),
          Text(
            "Chưa có công việc đã lưu",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Các công việc bạn lưu sẽ xuất hiện ở đây",
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: () {
          
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section with logo, title and bookmark
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        _getIconForJob(job['title']),
                        color: Colors.blue.shade700,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (job['isFeatured'])
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            margin: const EdgeInsets.only(bottom: 6),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'PREMIUM',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.shade700,
                              ),
                            ),
                          ),
                        Text(
                          job['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          job['company'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.bookmark_border,
                      color: Colors.blue.shade700,
                      size: 24,
                    ),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Info section
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildInfoChip(
                    Icons.location_on_outlined,
                    job['location'],
                    Colors.grey[700]!,
                  ),
                  _buildInfoChip(
                    Icons.attach_money,
                    job['salary'],
                    Colors.green[700]!,
                  ),
                  _buildInfoChip(
                    job['isRemote'] ? Icons.laptop : Icons.access_time,
                    job['isRemote'] ? "Remote" : job['type'],
                    Colors.blue[700]!,
                  ),
                  _buildInfoChip(
                    Icons.calendar_today_outlined,
                    job['postedDate'],
                    Colors.orange[700]!,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.blue[800]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Xem chi tiết',
                        style: TextStyle(color: Colors.blue[800]),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ApplyJobScreen(
                                  jobId: _jobList.indexOf(job),
                                  jobTitle: job['title'],
                                  companyName: job['company'],
                                ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Ứng tuyển ngay'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  IconData _getIconForJob(String title) {
    if (title.contains('Flutter') || title.contains('Backend')) {
      return Icons.code;
    } else if (title.contains('AI') || title.contains('dữ liệu')) {
      return Icons.data_usage;
    } else if (title.contains('UI/UX') || title.contains('Thiết kế')) {
      return Icons.brush;
    } else if (title.contains('Marketing')) {
      return Icons.trending_up;
    } else {
      return Icons.work;
    }
  }

  Widget _buildFiltersPanel() {
    return Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        // ignore: deprecated_member_use
        color: Colors.black.withOpacity(0.5),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Bộ lọc tìm kiếm',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            _showFilters = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFilterSection(
                          'Địa điểm',
                          _locations,
                          _selectedLocation,
                          (value) {
                            setState(() {
                              _selectedLocation = value;
                            });
                          },
                        ),
                        const Divider(),
                        _buildFilterSection(
                          'Loại công việc',
                          _jobTypes,
                          _selectedJobType,
                          (value) {
                            setState(() {
                              _selectedJobType = value;
                            });
                          },
                        ),
                        const Divider(),
                        _buildFilterSection(
                          'Kinh nghiệm',
                          _experienceLevels,
                          _selectedExperience,
                          (value) {
                            setState(() {
                              _selectedExperience = value;
                            });
                          },
                        ),
                        const Divider(),
                        _buildFilterSection(
                          'Mức lương',
                          _salaryRanges,
                          _selectedSalary,
                          (value) {
                            setState(() {
                              _selectedSalary = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _resetFilters,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey[400]!),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text('Đặt lại'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _applyFilters,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[800],
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text('Áp dụng'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    List<String> options,
    String selectedValue,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              options.map((option) {
                final isSelected = selectedValue == option;
                return ChoiceChip(
                  label: Text(option),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      onChanged(option);
                    }
                  },
                  backgroundColor: Colors.grey[100],
                  selectedColor: Colors.blue[100],
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.blue[800] : Colors.black87,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(
                      color: isSelected ? Colors.blue[800]! : Colors.grey[300]!,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  // Hàm xử lý tìm kiếm bằng giọng nói
  void _startVoiceSearch() async {
    try {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.mic, size: 48, color: Colors.blue),
                  const SizedBox(height: 16),
                  const Text(
                    'Đang lắng nghe...',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 24),
                  LinearProgressIndicator(
                    backgroundColor: Colors.blue.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ],
              ),
            ),
      );

      // Giả định kết quả từ speech recognition
      // Trong ứng dụng thực tế, bạn sẽ gọi plugin speech_to_text thực tế
      await Future.delayed(const Duration(seconds: 2));
      Navigator.of(context).pop(); // Đóng dialog
      // Áp dụng kết quả
      _searchController.text = "Kết quả từ giọng nói";
      _filterJobs();
    } catch (e) {
      // Xử lý lỗi
      print('Lỗi nhận dạng giọng nói: $e');
    }
  }
}
