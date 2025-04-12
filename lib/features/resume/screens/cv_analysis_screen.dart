import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class CVAnalysisPage extends StatefulWidget {
  const CVAnalysisPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CVAnalysisPageState createState() => _CVAnalysisPageState();
}

class _CVAnalysisPageState extends State<CVAnalysisPage> {
  List<JobRecommendation> _recommendations = [];
  bool _isAnalyzed = false;
  bool _isUploading = false;
  File? _selectedFile;

  // Mock data for previously imported CVs
  final List<PreviousCV> _previousCVs = [
    PreviousCV(
      fileName: 'CV_NguyenVanA.pdf',
      userName: 'Nguyễn Văn A',
      uploadDate: '20250310',
      fileIcon: Icons.picture_as_pdf,
      fileIconColor: Colors.red,
    ),
    PreviousCV(
      fileName: 'CV_TranThiB.docx',
      userName: 'Trần Thị B',
      uploadDate: '20250325',
      fileIcon: Icons.description,
      fileIconColor: Colors.blue,
    ),
    PreviousCV(
      fileName: 'CV_LeVanC.doc',
      userName: 'Lê Văn C',
      uploadDate: '20250401',
      fileIcon: Icons.description,
      fileIconColor: Colors.blue,
    ),
  ];

  Future<void> _pickFile() async {
    setState(() {
      _isUploading = true;
    });

    try {
      // Trong ứng dụng thực tế, sử dụng file_picker để chọn file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
          _isUploading = false;

          // Tự động phân tích CV sau khi tải lên thành công
          _analyzeCV();
        });
      } else {
        // User cancelled the picker
        setState(() {
          _isUploading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      // Hiển thị thông báo lỗi
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Có lỗi xảy ra khi tải file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _analyzeCV() {
    // Giả lập quá trình phân tích CV
    setState(() {
      // Hiển thị loading spinner
      _isUploading = true;
    });

    // Giả lập thời gian phân tích
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isAnalyzed = true;
        _isUploading = false;
        _recommendations = [
          JobRecommendation(
            title: 'Frontend Developer',
            company: 'Tech Solutions',
            matchPercentage: 92,
            description:
                'Phát triển giao diện người dùng sử dụng React và Flutter',
            requirements: ['React', 'Flutter', 'JavaScript', 'UI/UX'],
          ),
          JobRecommendation(
            title: 'Mobile Developer',
            company: 'Digital Innovation',
            matchPercentage: 87,
            description: 'Phát triển ứng dụng di động đa nền tảng',
            requirements: ['Flutter', 'Dart', 'Firebase', 'REST API'],
          ),
          JobRecommendation(
            title: 'Full Stack Developer',
            company: 'VN Software',
            matchPercentage: 75,
            description: 'Phát triển ứng dụng web từ frontend đến backend',
            requirements: ['JavaScript', 'Node.js', 'React', 'MongoDB'],
          ),
        ];
      });
    });
  }

  void _selectPreviousCV(PreviousCV cv) {
    setState(() {
      _selectedFile = File(cv.fileName); // Giả lập file
      // Tự động phân tích CV đã có
      _analyzeCV();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Phân tích CV'), backgroundColor: Colors.blue),
      body:
          _isUploading
              ? _buildLoadingView()
              : SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Initial selection screen
                    if (!_isAnalyzed) ...[_buildInitialOptions()],

                    // Analysis Results Section
                    if (_isAnalyzed) ...[_buildAnalysisResults()],
                  ],
                ),
              ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            _isAnalyzed ? 'Đang phân tích CV...' : 'Đang tải lên...',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chọn CV để phân tích',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 24),

        // Option 1: Import new CV
        Card(
          elevation: 4,
          child: InkWell(
            onTap: _pickFile,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.upload_file,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tải lên CV mới',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Tải lên file CV của bạn (PDF, DOC, DOCX)',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: 16),

        // Option 2: Previous CVs
        if (_previousCVs.isNotEmpty) ...[
          Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.history,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 16),
                      Text(
                        'CV đã tải lên trước đó',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ..._previousCVs
                      .map((cv) => _buildPreviousCVItem(cv))
                      // ignore: unnecessary_to_list_in_spreads
                      .toList(),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPreviousCVItem(PreviousCV cv) {
    // Format date for display
    String formattedDate =
        '${cv.uploadDate.substring(6, 8)}/${cv.uploadDate.substring(4, 6)}/${cv.uploadDate.substring(0, 4)}';

    return InkWell(
      onTap: () => _selectPreviousCV(cv),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]!, width: 1),
          ),
        ),
        child: Row(
          children: [
            Icon(cv.fileIcon, color: cv.fileIconColor),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cv.userName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Tải lên: $formattedDate',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisResults() {
    // Hiển thị thông tin file đã được phân tích
    String fileName = _selectedFile?.path.split('/').last ?? 'Unknown';
    IconData fileIcon;
    Color fileIconColor;

    if (fileName.toLowerCase().endsWith('.pdf')) {
      fileIcon = Icons.picture_as_pdf;
      fileIconColor = Colors.red;
    } else if (fileName.toLowerCase().endsWith('.doc') ||
        fileName.toLowerCase().endsWith('.docx')) {
      fileIcon = Icons.description;
      fileIconColor = Colors.blue;
    } else {
      fileIcon = Icons.insert_drive_file;
      fileIconColor = Colors.grey;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // File info
        Card(
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Row(
              children: [
                Icon(fileIcon, color: fileIconColor, size: 40),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Đã phân tích xong',
                        style: TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {
                      _isAnalyzed = false;
                    });
                  },
                  tooltip: 'Chọn CV khác',
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 20),

        Text(
          'Kết quả phân tích',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),

        // CV Analysis Summary
        Card(
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tóm tắt phân tích',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                _buildAnalysisItem('Điểm mạnh', [
                  'Kỹ năng lập trình di động',
                  'Kinh nghiệm với Flutter',
                  'Khả năng làm việc nhóm',
                ]),
                _buildAnalysisItem('Cần cải thiện', [
                  'Kinh nghiệm với backend',
                  'Kỹ năng quản lý dự án',
                ]),
                SizedBox(height: 12),
                Text(
                  'Đánh giá tổng quan: CV của bạn phù hợp với các vị trí phát triển ứng dụng di động, đặc biệt là với Flutter. Bạn có thể cân nhắc bổ sung thêm kinh nghiệm backend để mở rộng cơ hội việc làm.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 16),

        // Job Recommendations
        Text(
          'Công việc phù hợp',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),

        ..._recommendations.map((job) => _buildJobRecommendationCard(job)),
      ],
    );
  }

  Widget _buildAnalysisItem(String title, List<String> items) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          ...items
              .map(
                (item) => Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('•'),
                      SizedBox(width: 8),
                      Expanded(child: Text(item)),
                    ],
                  ),
                ),
              )
              // ignore: unnecessary_to_list_in_spreads
              .toList(),
        ],
      ),
    );
  }

  Widget _buildJobRecommendationCard(JobRecommendation job) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        job.company,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getMatchColor(job.matchPercentage),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${job.matchPercentage}% phù hợp',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(job.description),
            SizedBox(height: 8),
            Text('Yêu cầu:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  job.requirements
                      .map(
                        (req) => Chip(
                          label: Text(req),
                          backgroundColor: Colors.blue[50],
                        ),
                      )
                      .toList(),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // Hiển thị chi tiết công việc
                  },
                  child: Text('Xem chi tiết'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Ứng tuyển công việc
                  },
                  // ignore: sort_child_properties_last
                  child: Text('Ứng tuyển'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getMatchColor(int percentage) {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 75) return Colors.blue;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }
}

class JobRecommendation {
  final String title;
  final String company;
  final int matchPercentage;
  final String description;
  final List<String> requirements;

  JobRecommendation({
    required this.title,
    required this.company,
    required this.matchPercentage,
    required this.description,
    required this.requirements,
  });
}

class PreviousCV {
  final String fileName;
  final String userName;
  final String uploadDate;
  final IconData fileIcon;
  final Color fileIconColor;

  PreviousCV({
    required this.fileName,
    required this.userName,
    required this.uploadDate,
    required this.fileIcon,
    required this.fileIconColor,
  });
}
