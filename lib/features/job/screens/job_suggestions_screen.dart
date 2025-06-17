import 'package:flutter/material.dart';

class JobModel {
  final String title;
  final String company;
  final String location;
  final String salary;
  final double matchPercentage;
  final String logoUrl;
  final List<String> skills;

  JobModel({
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.matchPercentage,
    required this.logoUrl,
    required this.skills,
  });
}

class JobSuggestionsPage extends StatefulWidget {
  const JobSuggestionsPage({super.key});

  @override
  State<JobSuggestionsPage> createState() => _JobSuggestionsPageState();
}

class _JobSuggestionsPageState extends State<JobSuggestionsPage> {
  final List<JobModel> suggestedJobs = [
    JobModel(
      title: 'Flutter Developer',
      company: 'Tech Solutions',
      location: 'Hà Nội',
      salary: '25-30 triệu VND',
      matchPercentage: 95.0,
      logoUrl: 'https://example.com/logo1.png',
      skills: ['Flutter', 'Dart', 'Firebase', 'REST API'],
    ),
    JobModel(
      title: 'Mobile App Developer',
      company: 'InnoTech',
      location: 'TP. Hồ Chí Minh',
      salary: '20-28 triệu VND',
      matchPercentage: 88.0,
      logoUrl: 'https://example.com/logo2.png',
      skills: ['Flutter', 'React Native', 'UI/UX', 'Git'],
    ),
    JobModel(
      title: 'Frontend Developer',
      company: 'Digital Creations',
      location: 'Đà Nẵng',
      salary: '18-25 triệu VND',
      matchPercentage: 82.0,
      logoUrl: 'https://example.com/logo3.png',
      skills: ['React', 'JavaScript', 'HTML/CSS', 'Flutter'],
    ),
    JobModel(
      title: 'Software Engineer',
      company: 'VN Solutions',
      location: 'Hà Nội',
      salary: '30-40 triệu VND',
      matchPercentage: 78.0,
      logoUrl: 'https://example.com/logo4.png',
      skills: ['Java', 'Spring', 'Flutter', 'SQL'],
    ),
    JobModel(
      title: 'UI/UX Designer',
      company: 'Creative Studio',
      location: 'TP. Hồ Chí Minh',
      salary: '15-22 triệu VND',
      matchPercentage: 75.0,
      logoUrl: 'https://example.com/logo5.png',
      skills: ['Figma', 'Adobe XD', 'UI Design', 'Wireframing'],
    ),
  ];

  String _selectedFilter = 'Tất cả';
  final List<String> _filterOptions = [
    'Tất cả',
    'Hà Nội',
    'TP. Hồ Chí Minh',
    'Đà Nẵng',
  ];

  List<JobModel> get filteredJobs {
    if (_selectedFilter == 'Tất cả') {
      return suggestedJobs;
    } else {
      return suggestedJobs
          .where((job) => job.location == _selectedFilter)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Gợi ý công việc",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterOptions(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildMatchInfoBar(),
          Expanded(
            child:
                filteredJobs.isEmpty
                    ? const Center(
                      child: Text(
                        'Không có công việc phù hợp với bộ lọc hiện tại',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                    : ListView.builder(
                      itemCount: filteredJobs.length,
                      padding: const EdgeInsets.all(12),
                      itemBuilder: (context, index) {
                        final job = filteredJobs[index];
                        return _buildJobCard(job);
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to CV editing page
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Chỉnh sửa CV để cải thiện kết quả gợi ý'),
            ),
          );
        },
        backgroundColor: Colors.blue,
        // ignore: sort_child_properties_last
        child: const Icon(Icons.edit),
        tooltip: 'Chỉnh sửa CV',
      ),
    );
  }

  Widget _buildMatchInfoBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      color: Colors.blue.shade50,
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Đã tìm thấy ${filteredJobs.length} công việc phù hợp",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Dựa trên kỹ năng và kinh nghiệm trong CV của bạn",
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              // View CV analytics
            },
            child: const Text('Xem phân tích'),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(JobModel job) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.business, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job.company,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        job.location,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildMatchPercentageBadge(job.matchPercentage),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.attach_money, size: 18, color: Colors.green),
                const SizedBox(width: 4),
                Text(job.salary, style: const TextStyle(fontSize: 15)),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  job.skills.map((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Text(
                        skill,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    // View job details
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.blue.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Xem chi tiết'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    //
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(100, 20),
                  ),
                  child: const Text('Ứng tuyển'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchPercentageBadge(double percentage) {
    Color badgeColor;
    if (percentage >= 90) {
      badgeColor = Colors.green;
    } else if (percentage >= 80) {
      badgeColor = Colors.blue;
    } else if (percentage >= 70) {
      badgeColor = Colors.orange;
    } else {
      badgeColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        // ignore: deprecated_member_use
        border: Border.all(color: badgeColor.withOpacity(0.3)),
      ),
      child: Text(
        '${percentage.toInt()}% phù hợp',
        style: TextStyle(
          color: badgeColor,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Lọc theo địa điểm',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    _filterOptions.map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedFilter = filter;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected ? Colors.blue : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            filter,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Đóng'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
