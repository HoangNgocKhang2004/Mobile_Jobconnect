import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_connect/features/payments/screens/payment_screen.dart';

class PostJobPage extends StatefulWidget {
  const PostJobPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PostJobPageState createState() => _PostJobPageState();
}

class _PostJobPageState extends State<PostJobPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _requirementsController = TextEditingController();
  final TextEditingController _benefitsController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String _jobType = "Toàn thời gian";
  String _experienceLevel = "Mới đi làm";
  bool _isUrgent = false;

  final List<String> _jobTypes = [
    "Toàn thời gian",
    "Bán thời gian",
    "Freelance",
    "Thực tập",
    "Remote",
  ];

  final List<String> _experienceLevels = [
    "Mới đi làm",
    "1-2 năm kinh nghiệm",
    "3-5 năm kinh nghiệm",
    "Trên 5 năm kinh nghiệm",
    "Quản lý",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _salaryController.dispose();
    _requirementsController.dispose();
    _benefitsController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _postJob() {
    if (_formKey.currentState!.validate()) {
      // Xử lý đăng việc (Có thể lưu vào Firebase hoặc SQLite)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Đăng tuyển thành công!"),
          backgroundColor: Colors.green,
        ),
      );
      _resetForm();
    }
  }

  void _resetForm() {
    _titleController.clear();
    _descriptionController.clear();
    _salaryController.clear();
    _requirementsController.clear();
    _benefitsController.clear();
    _locationController.clear();
    setState(() {
      _jobType = "Toàn thời gian";
      _experienceLevel = "Mới đi làm";
      _isUrgent = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Thông tin nhà tuyển dụng
    final recruiterInfo = {
      'name': 'Hoàng Ngọc Khang',
      'company': 'Công ty TNHH ABC Technology',
      'code': 'NTD12345',
      'level': 'Premium',
      'avatar': 'https://example.com/avatar.jpg',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Quản lý đăng tin",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white, size: 20),
            onPressed: () {
              // Hiển thị hướng dẫn
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Phần thông tin nhà tuyển dụng
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              children: [
                Row(
                  children: [
                    // Avatar nhà tuyển dụng
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child:
                            recruiterInfo['avatar'] != null
                                ? Image.network(
                                  recruiterInfo['avatar']!,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(
                                            Icons.person,
                                            color: Color(0xFF2563EB),
                                            size: 30,
                                          ),
                                )
                                : const Icon(
                                  Icons.person,
                                  color: Color(0xFF2563EB),
                                  size: 30,
                                ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Thông tin nhà tuyển dụng
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recruiterInfo['name']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            recruiterInfo['company']!,
                            style: TextStyle(
                              // ignore: deprecated_member_use
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  // ignore: deprecated_member_use
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.badge_outlined,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "Mã NTD: ${recruiterInfo['code']}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  // ignore: deprecated_member_use
                                  color: const Color(
                                    0xFFFFD700,
                                  ).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Color(0xFFFFD700),
                                      size: 12,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      recruiterInfo['level']!,
                                      style: const TextStyle(
                                        color: Color(0xFFFFD700),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Thêm nút thanh toán dịch vụ đẩy tin
                const SizedBox(height: 12),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaymentPage()),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.shopping_cart_outlined,
                          color: Color(0xFF10B981),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Thanh toán dịch vụ đẩy tin",
                          style: TextStyle(
                            color: Color(0xFF10B981),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "MỚI",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // TabBar giữ nguyên
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
              ),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(color: Colors.white, width: 3.0),
                  insets: EdgeInsets.symmetric(horizontal: 10.0),
                ),
                labelColor: Colors.white,
                // ignore: deprecated_member_use
                unselectedLabelColor: Colors.white.withOpacity(0.7),
                labelStyle: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
                labelPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                tabs: [
                  const Tab(
                    icon: Icon(Icons.work_outline, size: 20),
                    text: "Tin tuyển dụng",
                    iconMargin: EdgeInsets.only(bottom: 2.0),
                  ),
                  const Tab(
                    icon: Icon(Icons.history, size: 20),
                    text: "Lịch sử",
                    iconMargin: EdgeInsets.only(bottom: 2.0),
                  ),
                  const Tab(
                    icon: Icon(Icons.visibility_outlined, size: 20),
                    text: "Đang hiển thị",
                    iconMargin: EdgeInsets.only(bottom: 2.0),
                  ),
                  const Tab(
                    icon: Icon(Icons.pending_outlined, size: 20),
                    text: "Chờ xác thực",
                    iconMargin: EdgeInsets.only(bottom: 2.0),
                  ),
                ],
              ),
            ),
          ),

          // TabBarView giữ nguyên
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Đăng tin tuyển dụng
                _buildRecruitmentForm(),

                // Tab 2: Lịch sử đăng tin
                _buildHistoryTab(),

                // Tab 3: Đang hiển thị
                _buildActiveJobsTab(),

                // Tab 4: Chờ xác thực
                _buildPendingJobsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Biểu mẫu đăng tin tuyển dụng
  Widget _buildRecruitmentForm() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: const Color(0xFF2563EB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  // ignore: deprecated_member_use
                  border: Border.all(
                    // ignore: deprecated_member_use
                    color: const Color(0xFF2563EB).withOpacity(0.3),
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tạo tin tuyển dụng mới",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Điền đầy đủ thông tin để tìm được ứng viên phù hợp nhất",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Thông tin cơ bản
              const Text(
                "THÔNG TIN CƠ BẢN",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),

              // Tiêu đề công việc
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Tiêu đề công việc",
                  hintText: "Ví dụ: Kỹ sư phần mềm Flutter",
                  prefixIcon: const Icon(
                    Icons.work_outline,
                    color: Color(0xFF2563EB),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF2563EB),
                      width: 2,
                    ),
                  ),
                  floatingLabelStyle: const TextStyle(color: Color(0xFF2563EB)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Vui lòng nhập tiêu đề công việc";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Mô tả công việc
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: "Mô tả công việc",
                  hintText:
                      "Mô tả chi tiết về công việc, trách nhiệm và kỳ vọng",
                  prefixIcon: const Icon(
                    Icons.description_outlined,
                    color: Color(0xFF2563EB),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF2563EB),
                      width: 2,
                    ),
                  ),
                  alignLabelWithHint: true,
                  floatingLabelStyle: const TextStyle(color: Color(0xFF2563EB)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Vui lòng nhập mô tả công việc";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Yêu cầu
              TextFormField(
                controller: _requirementsController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Yêu cầu ứng viên",
                  hintText: "Kỹ năng, bằng cấp, kinh nghiệm cần thiết",
                  prefixIcon: const Icon(
                    Icons.assignment_outlined,
                    color: Color(0xFF2563EB),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF2563EB),
                      width: 2,
                    ),
                  ),
                  alignLabelWithHint: true,
                  floatingLabelStyle: const TextStyle(color: Color(0xFF2563EB)),
                ),
              ),

              const SizedBox(height: 16),

              // Quyền lợi
              TextFormField(
                controller: _benefitsController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Quyền lợi",
                  hintText: "Chế độ bảo hiểm, thưởng, phúc lợi khác",
                  prefixIcon: const Icon(
                    Icons.card_giftcard_outlined,
                    color: Color(0xFF2563EB),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF2563EB),
                      width: 2,
                    ),
                  ),
                  alignLabelWithHint: true,
                  floatingLabelStyle: const TextStyle(color: Color(0xFF2563EB)),
                ),
              ),

              const SizedBox(height: 24),

              // Thông tin chi tiết
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "THÔNG TIN CHI TIẾT",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Thông tin chi tiết trong CardView
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Loại hình làm việc
                      const Text(
                        "Loại hình làm việc",
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: Color(0xFF2563EB),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _jobType,
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                  items:
                                      _jobTypes.map((type) {
                                        return DropdownMenuItem(
                                          value: type,
                                          child: Text(type),
                                        );
                                      }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _jobType = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Mức lương
                      const Text(
                        "Mức lương",
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: TextFormField(
                          controller: _salaryController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            hintText: "VNĐ/tháng",
                            prefixIcon: const Icon(
                              Icons.monetization_on_outlined,
                              color: Color(0xFF2563EB),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Vui lòng nhập mức lương";
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Kinh nghiệm
                      const Text(
                        "Kinh nghiệm",
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.trending_up_outlined,
                              color: Color(0xFF2563EB),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _experienceLevel,
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                  items:
                                      _experienceLevels.map((level) {
                                        return DropdownMenuItem(
                                          value: level,
                                          child: Text(level),
                                        );
                                      }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _experienceLevel = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Địa điểm làm việc
                      const Text(
                        "Địa điểm làm việc",
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: TextFormField(
                          controller: _locationController,
                          decoration: InputDecoration(
                            hintText: "Thành phố, Quận",
                            prefixIcon: const Icon(
                              Icons.location_on_outlined,
                              color: Color(0xFF2563EB),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Vui lòng nhập địa điểm";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Tuyển gấp
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: CheckboxListTile(
                  title: const Text(
                    "Đánh dấu là tin tuyển gấp",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: const Text(
                    "Tin tuyển dụng sẽ được ưu tiên hiển thị",
                  ),
                  value: _isUrgent,
                  activeColor: const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _isUrgent = value!;
                    });
                  },
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: const Color(0xFF2563EB).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.priority_high,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Nút đăng và hủy
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _resetForm,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFF2563EB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Hủy",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _postJob,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF2563EB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.publish_outlined),
                          SizedBox(width: 8),
                          Text(
                            "Đăng tin tuyển dụng",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Tab tin đang hiển thị
  Widget _buildActiveJobsTab() {
    // Danh sách các công việc đang hiển thị
    final List<Map<String, dynamic>> activeJobs = [
      {
        'title': 'Senior Flutter Developer',
        'location': 'Hồ Chí Minh',
        'posted': '03/10/2023',
        'expires': '03/11/2023',
        'applicants': 12,
        'views': 145,
        'status': 'Còn 30 ngày',
        'isUrgent': true,
      },
      {
        'title': 'UX/UI Designer',
        'location': 'Hà Nội',
        'posted': '28/09/2023',
        'expires': '28/10/2023',
        'applicants': 8,
        'views': 97,
        'status': 'Còn 25 ngày',
        'isUrgent': false,
      },
      {
        'title': 'Full Stack Developer',
        'location': 'Đà Nẵng',
        'posted': '01/10/2023',
        'expires': '01/11/2023',
        'applicants': 15,
        'views': 180,
        'status': 'Còn 28 ngày',
        'isUrgent': true,
      },
    ];

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Thanh tìm kiếm và bộ lọc
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade100,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm tin đăng',
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.shade600,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade100,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.filter_list, color: Colors.grey.shade700),
                    tooltip: 'Lọc tin đăng',
                  ),
                ),
              ],
            ),
          ),

          // Thống kê
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFE6EFFF),
            child: Row(
              children: [
                const Icon(
                  Icons.visibility,
                  color: Color(0xFF2563EB),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${activeJobs.length} tin đang hiển thị',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    const Text(
                      'Tin của bạn đang được người tìm việc xem',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Danh sách tin đăng
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: activeJobs.length,
              itemBuilder: (context, index) {
                final job = activeJobs[index];
                return _buildActiveJobCard(job);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveJobCard(Map<String, dynamic> job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: const Color(0xFF2563EB).withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Color(0xFF2563EB),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      job['status'],
                      style: const TextStyle(
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (job['isUrgent'])
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.priority_high,
                              color: Colors.red,
                              size: 12,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Gấp',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(width: 8),
                    // Thêm nút xóa tin
                    InkWell(
                      onTap: () {
                        // Xử lý logic xóa tin
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
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
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildJobInfoChip(
                      Icons.calendar_today_outlined,
                      'Đăng: ${job['posted']}',
                    ),
                    const SizedBox(width: 16),
                    _buildJobInfoChip(
                      Icons.event_busy_outlined,
                      'Hết hạn: ${job['expires']}',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildJobInfoChip(
                      Icons.person_outline,
                      '${job['applicants']} ứng viên',
                    ),
                    const SizedBox(width: 16),
                    _buildJobInfoChip(
                      Icons.visibility_outlined,
                      '${job['views']} lượt xem',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: const Text('Chỉnh sửa'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF2563EB),
                          side: const BorderSide(color: Color(0xFF2563EB)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.visibility_off_outlined,
                          size: 16,
                        ),
                        label: const Text('Ẩn tin'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey.shade700,
                          side: BorderSide(color: Colors.grey.shade400),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Xử lý logic đẩy top tin tuyển dụng
                        },
                        icon: const Icon(Icons.trending_up, size: 16),
                        label: const Text('Đẩy top'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF10B981),
                          side: const BorderSide(color: Color(0xFF10B981)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
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
    );
  }

  // Tab tin chờ xác thực
  Widget _buildPendingJobsTab() {
    // Danh sách các công việc đang chờ xác thực
    final List<Map<String, dynamic>> pendingJobs = [
      {
        'title': 'Backend Developer (Java)',
        'location': 'Hồ Chí Minh',
        'submitted': '05/10/2023',
        'status': 'Đang chờ duyệt',
        'reason': 'Chờ kiểm duyệt nội dung',
      },
      {
        'title': 'Frontend Developer (ReactJS)',
        'location': 'Hà Nội',
        'submitted': '04/10/2023',
        'status': 'Cần chỉnh sửa',
        'reason': 'Thông tin lương không hợp lệ',
      },
    ];

    return Container(
      color: Colors.white,
      child:
          pendingJobs.isEmpty
              ? _buildEmptyPendingState()
              : Column(
                children: [
                  // Header thông tin
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: const Color(0xFFFFF4E6),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Color(0xFFED8936),
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tin đăng chờ xác thực',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFFED8936),
                                ),
                              ),
                              Text(
                                'Bạn có ${pendingJobs.length} tin đang chờ xác thực. Tin sẽ được hiển thị sau khi được duyệt.',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Danh sách tin chờ duyệt
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: pendingJobs.length,
                      itemBuilder: (context, index) {
                        final job = pendingJobs[index];
                        return _buildPendingJobCard(job);
                      },
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildPendingJobCard(Map<String, dynamic> job) {
    final bool needsEdit = job['status'] == 'Cần chỉnh sửa';
    final Color statusColor = needsEdit ? Colors.red : const Color(0xFFED8936);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: statusColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  needsEdit
                      ? Icons.warning_amber_outlined
                      : Icons.pending_outlined,
                  color: statusColor,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  job['status'],
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
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
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Gửi ngày: ${job['submitted']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                if (job['reason'] != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: statusColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      // ignore: deprecated_member_use
                      border: Border.all(color: statusColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: statusColor, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            job['reason'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: const Text('Chỉnh sửa'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: statusColor,
                          side: BorderSide(color: statusColor),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.delete_outline, size: 16),
                        label: const Text('Hủy đăng'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey.shade700,
                          side: BorderSide(color: Colors.grey.shade400),
                          padding: const EdgeInsets.symmetric(vertical: 10),
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
    );
  }

  Widget _buildEmptyPendingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: Colors.green.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            "Không có tin đăng nào đang chờ xác thực",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Tất cả tin đăng của bạn đã được phê duyệt",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildJobInfoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
      ],
    );
  }

  // Tab lịch sử đăng tin
  Widget _buildHistoryTab() {
    // Danh sách các công việc đã đăng trong lịch sử
    final List<Map<String, dynamic>> historyJobs = [
      {
        'title': 'Senior Flutter Developer',
        'date': '03/10/2023',
        'status': 'Đang hoạt động',
        'statusColor': Colors.green,
        'applicants': 12,
        'views': 145,
      },
      {
        'title': 'UX/UI Designer',
        'date': '28/09/2023',
        'status': 'Đang hoạt động',
        'statusColor': Colors.green,
        'applicants': 8,
        'views': 97,
      },
      {
        'title': 'Product Manager',
        'date': '15/09/2023',
        'status': 'Hết hạn',
        'statusColor': Colors.grey,
        'applicants': 5,
        'views': 63,
      },
      {
        'title': 'React Native Developer',
        'date': '10/09/2023',
        'status': 'Hết hạn',
        'statusColor': Colors.grey,
        'applicants': 7,
        'views': 82,
      },
      {
        'title': 'Java Backend Developer',
        'date': '05/09/2023',
        'status': 'Hết hạn',
        'statusColor': Colors.grey,
        'applicants': 10,
        'views': 120,
      },
    ];

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Thanh tìm kiếm và bộ lọc
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade100,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm theo tên công việc',
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.shade600,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade100,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.filter_list, color: Colors.grey.shade700),
                    tooltip: 'Lọc tin đăng',
                  ),
                ),
              ],
            ),
          ),

          // Thống kê
          Container(
            padding: const EdgeInsets.all(16),
            color: Color(0xFFF1F5F9),
            child: Row(
              children: [
                _buildHistoryStatCard(
                  icon: Icons.article_outlined,
                  title: "Tổng tin",
                  count: historyJobs.length.toString(),
                  color: const Color(0xFF3366FF),
                ),
                const SizedBox(width: 12),
                _buildHistoryStatCard(
                  icon: Icons.check_circle_outline,
                  title: "Đang hoạt động",
                  count:
                      historyJobs
                          .where((job) => job['status'] == 'Đang hoạt động')
                          .length
                          .toString(),
                  color: Colors.green,
                ),
                const SizedBox(width: 12),
                _buildHistoryStatCard(
                  icon: Icons.access_time,
                  title: "Hết hạn",
                  count:
                      historyJobs
                          .where((job) => job['status'] == 'Hết hạn')
                          .length
                          .toString(),
                  color: Colors.grey,
                ),
              ],
            ),
          ),

          // Danh sách tin đăng trong lịch sử
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: historyJobs.length,
              itemBuilder: (context, index) {
                final job = historyJobs[index];
                return _buildHistoryJobCard(job);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryStatCard({
    required IconData icon,
    required String title,
    required String count,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              count,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryJobCard(Map<String, dynamic> job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    job['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: job['statusColor'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    job['status'],
                    style: TextStyle(
                      color: job['statusColor'],
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  "Đăng ngày: ${job['date']}",
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.person_outline,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  "${job['applicants']} ứng viên",
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.visibility_outlined, size: 16),
                    label: const Text('Chi tiết'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF3366FF),
                      side: const BorderSide(color: Color(0xFF3366FF)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Đăng lại'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                          job['status'] == 'Hết hạn'
                              ? Colors.amber.shade800
                              : Colors.grey.shade400,
                      side: BorderSide(
                        color:
                            job['status'] == 'Hết hạn'
                                ? Colors.amber.shade800
                                : Colors.grey.shade400,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
