import 'package:flutter/material.dart';

class SearchHrScreen extends StatefulWidget {
  const SearchHrScreen({super.key});
  @override
  State<SearchHrScreen> createState() => _SearchHrScreenState();
}

class _SearchHrScreenState extends State<SearchHrScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedLocation = 'Tất cả địa điểm';
  String selectedExperience = 'Tất cả kinh nghiệm';
  String selectedSkill = 'Tất cả kỹ năng';
  String selectedSort = 'Mới nhất';

  List<String> locations = ['Tất cả địa điểm', 'Hà Nội', 'TP. HCM', 'Đà Nẵng'];
  List<String> experiences = [
    'Tất cả kinh nghiệm',
    'Dưới 1 năm',
    '1-3 năm',
    'Trên 3 năm',
  ];
  List<String> skills = [
    'Tất cả kỹ năng',
    'Flutter',
    'React',
    'Java',
    'Python',
  ];
  List<String> sortOptions = [
    'Mới nhất',
    'Phù hợp nhất',
    'Kinh nghiệm nhiều nhất',
  ];

  List<Map<String, dynamic>> candidates = [
    {
      'name': 'Hoàng Ngọc Khang',
      'position': 'Flutter Developer',
      'location': 'Hà Nội',
      'image': 'https://randomuser.me/api/portraits/men/1.jpg',
      'experience': '2 năm',
      'skills': ['Flutter', 'Dart', 'Firebase'],
      'rating': 4.5,
      'isActive': true,
    },
    {
      'name': 'Nguyễn Thanh Tùng',
      'position': 'React Developer',
      'location': 'TP. HCM',
      'image': 'https://randomuser.me/api/portraits/women/2.jpg',
      'experience': '3 năm',
      'skills': ['React', 'JavaScript', 'TypeScript'],
      'rating': 4.2,
      'isActive': true,
    },
    {
      'name': 'Lê Minh Tiến',
      'position': 'Java Developer',
      'location': 'Đà Nẵng',
      'image': 'https://randomuser.me/api/portraits/men/3.jpg',
      'experience': '4 năm',
      'skills': ['Java', 'Spring Boot', 'Hibernate'],
      'rating': 4.8,
      'isActive': false,
    },
    {
      'name': 'Tăng Hữu Minh',
      'position': 'Python Developer',
      'location': 'Hà Nội',
      'image': 'https://randomuser.me/api/portraits/women/4.jpg',
      'experience': '1 năm',
      'skills': ['Python', 'Django', 'Flask'],
      'rating': 3.9,
      'isActive': true,
    },
  ];

  List<Map<String, dynamic>> filteredCandidates = [];
  bool isAdvancedFilterVisible = false;

  @override
  void initState() {
    super.initState();
    filteredCandidates = List.from(candidates);
  }

  void _filterCandidates() {
    setState(() {
      filteredCandidates =
          candidates.where((candidate) {
            // Áp dụng filter cho từ khóa tìm kiếm
            bool matchesKeyword =
                _searchController.text.isEmpty ||
                candidate['name'].toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ) ||
                candidate['position'].toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                );

            // Áp dụng filter cho địa điểm
            bool matchesLocation =
                selectedLocation == 'Tất cả địa điểm' ||
                candidate['location'] == selectedLocation;

            // Áp dụng filter cho kinh nghiệm
            bool matchesExperience = selectedExperience == 'Tất cả kinh nghiệm';
            if (selectedExperience == 'Dưới 1 năm') {
              matchesExperience =
                  candidate['experience'].contains('1 năm') ||
                  int.parse(candidate['experience'].split(' ')[0]) < 1;
            } else if (selectedExperience == '1-3 năm') {
              int years = int.parse(candidate['experience'].split(' ')[0]);
              matchesExperience = years >= 1 && years <= 3;
            } else if (selectedExperience == 'Trên 3 năm') {
              matchesExperience =
                  int.parse(candidate['experience'].split(' ')[0]) > 3;
            }

            // Áp dụng filter cho kỹ năng
            bool matchesSkill =
                selectedSkill == 'Tất cả kỹ năng' ||
                (candidate['skills'] as List<String>).contains(selectedSkill);

            return matchesKeyword &&
                matchesLocation &&
                matchesExperience &&
                matchesSkill;
          }).toList();

      // Sắp xếp theo lựa chọn
      if (selectedSort == 'Mới nhất') {
        // Giả định rằng thứ tự trong danh sách ban đầu là theo thời gian mới nhất
      } else if (selectedSort == 'Kinh nghiệm nhiều nhất') {
        filteredCandidates.sort((a, b) {
          int expA = int.parse(a['experience'].split(' ')[0]);
          int expB = int.parse(b['experience'].split(' ')[0]);
          return expB.compareTo(expA);
        });
      } else if (selectedSort == 'Phù hợp nhất') {
        filteredCandidates.sort((a, b) => b['rating'].compareTo(a['rating']));
      }
    });
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  'Sắp xếp theo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ...sortOptions.map((option) {
                return ListTile(
                  leading: Radio<String>(
                    value: option,
                    groupValue: selectedSort,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (value) {
                      setState(() {
                        selectedSort = value!;
                        _filterCandidates();
                      });
                      Navigator.pop(context);
                    },
                  ),
                  title: Text(option),
                  onTap: () {
                    setState(() {
                      selectedSort = option;
                      _filterCandidates();
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void _showAdvancedFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Bộ lọc nâng cao',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView(
                      children: [
                        const Text(
                          'Địa điểm',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              locations.map((location) {
                                return FilterChip(
                                  label: Text(location),
                                  selected: selectedLocation == location,
                                  onSelected: (selected) {
                                    setState(() {
                                      selectedLocation = location;
                                    });
                                  },
                                  selectedColor: Colors.blue.withOpacity(0.2),
                                  checkmarkColor: Colors.blue,
                                );
                              }).toList(),
                        ),

                        const SizedBox(height: 20),
                        const Text(
                          'Kinh nghiệm',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              experiences.map((experience) {
                                return FilterChip(
                                  label: Text(experience),
                                  selected: selectedExperience == experience,
                                  onSelected: (selected) {
                                    setState(() {
                                      selectedExperience = experience;
                                    });
                                  },
                                  selectedColor: Colors.blue.withOpacity(0.2),
                                  checkmarkColor: Colors.blue,
                                );
                              }).toList(),
                        ),

                        const SizedBox(height: 20),
                        const Text(
                          'Kỹ năng',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              skills.map((skill) {
                                return FilterChip(
                                  label: Text(skill),
                                  selected: selectedSkill == skill,
                                  onSelected: (selected) {
                                    setState(() {
                                      selectedSkill = skill;
                                    });
                                  },
                                  selectedColor: Colors.blue.withOpacity(0.2),
                                  checkmarkColor: Colors.blue,
                                );
                              }).toList(),
                        ),

                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  side: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                child: const Text('Đặt lại'),
                                onPressed: () {
                                  setState(() {
                                    selectedLocation = 'Tất cả địa điểm';
                                    selectedExperience = 'Tất cả kinh nghiệm';
                                    selectedSkill = 'Tất cả kỹ năng';
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                ),
                                child: const Text(
                                  'Áp dụng',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  _filterCandidates();
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Tìm kiếm ứng viên',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.blue),
            onPressed: () {
              // Hiển thị thông báo
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_outline, color: Colors.blue),
            onPressed: () {
              // Hiển thị danh sách đã lưu
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Thanh tìm kiếm được cải tiến
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => _filterCandidates(),
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm theo tên, vị trí, kỹ năng...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: const Icon(Icons.search, color: Colors.blue),
                      suffixIcon:
                          _searchController.text.isNotEmpty
                              ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  _filterCandidates();
                                },
                              )
                              : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Thanh bộ lọc với thiết kế được cải tiến
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        Icons.location_on_outlined,
                        'Địa điểm',
                        selectedLocation,
                        locations,
                      ),
                      const SizedBox(width: 12),
                      _buildFilterChip(
                        Icons.work_outline,
                        'Kinh nghiệm',
                        selectedExperience,
                        experiences,
                      ),
                      const SizedBox(width: 12),
                      _buildFilterChip(
                        Icons.code,
                        'Kỹ năng',
                        selectedSkill,
                        skills,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Hiển thị số lượng kết quả và tùy chọn sắp xếp
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredCandidates.length} ứng viên được tìm thấy',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                GestureDetector(
                  onTap: _showSortOptions,
                  child: Row(
                    children: [
                      const Text(
                        'Sắp xếp: ',
                        style: TextStyle(color: Colors.black54),
                      ),
                      Text(
                        selectedSort,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.blue),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Danh sách ứng viên với thiết kế card được cải tiến
          Expanded(
            child:
                filteredCandidates.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Không tìm thấy ứng viên phù hợp',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                selectedLocation = 'Tất cả địa điểm';
                                selectedExperience = 'Tất cả kinh nghiệm';
                                selectedSkill = 'Tất cả kỹ năng';
                                _filterCandidates();
                              });
                            },
                            child: const Text('Xóa bộ lọc'),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredCandidates.length,
                      itemBuilder: (context, index) {
                        final candidate = filteredCandidates[index];
                        return _buildCandidateCard(candidate);
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.filter_list),
        label: const Text('Bộ lọc'),
        onPressed: _showAdvancedFilterDialog,
      ),
    );
  }

  Widget _buildFilterChip(
    IconData icon,
    String label,
    String selectedValue,
    List<String> items,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(25),
        color:
            selectedValue != items[0]
                ? Colors.blue.withOpacity(0.1)
                : Colors.transparent,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
          isDense: true,
          itemHeight: 48,
          borderRadius: BorderRadius.circular(10),
          hint: Text(label),
          items:
              items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              if (label == 'Địa điểm') {
                selectedLocation = newValue!;
              } else if (label == 'Kinh nghiệm') {
                selectedExperience = newValue!;
              } else if (label == 'Kỹ năng') {
                selectedSkill = newValue!;
              }
              _filterCandidates();
            });
          },
        ),
      ),
    );
  }

  Widget _buildCandidateCard(Map<String, dynamic> candidate) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header với tên, chức vụ và đánh giá
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar với badge hiển thị trạng thái
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: NetworkImage(candidate['image']),
                        ),
                        if (candidate['isActive'])
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
                    // Thông tin ứng viên
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Tên ứng viên
                              Text(
                                candidate['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Đánh giá sao - đã chuyển ra ngoài để khớp với thiết kế trong hình
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    candidate['rating'].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Vị trí công việc
                          Text(
                            candidate['position'],
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Thông tin về địa điểm và kinh nghiệm
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                candidate['location'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                Icons.work,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'KN: ${candidate['experience']}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Các kỹ năng
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      (candidate['skills'] as List<String>).map((skill) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            skill,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),

          // Các nút tương tác - đã sửa lại để hiển thị giống với mẫu
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Nút Xem hồ sơ
                TextButton.icon(
                  icon: const Icon(
                    Icons.visibility_outlined,
                    size: 18,
                    color: Colors.blue,
                  ),
                  label: const Text(
                    'Xem hồ sơ',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {},
                ),

                // Nút Liên hệ
                TextButton.icon(
                  icon: const Icon(
                    Icons.message_outlined,
                    size: 18,
                    color: Colors.blue,
                  ),
                  label: const Text(
                    'Liên hệ',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {},
                ),

                // Nút Mời
                TextButton.icon(
                  icon: const Icon(
                    Icons.person_add_outlined,
                    size: 18,
                    color: Colors.blue,
                  ),
                  label: const Text(
                    'Mời',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
