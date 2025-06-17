import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ApplyJobScreen extends StatefulWidget {
  final int jobId;
  final String jobTitle;
  final String companyName;

  const ApplyJobScreen({
    super.key,
    required this.jobId,
    required this.jobTitle,
    required this.companyName,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ApplyJobScreenState createState() => _ApplyJobScreenState();
}

class _ApplyJobScreenState extends State<ApplyJobScreen> {
  File? selectedCV;
  String fileName = '';
  String applicationStatus = "Chờ duyệt";
  final TextEditingController _coverLetterController = TextEditingController();
  bool isSubmitting = false;
  List<String> savedCVs = ["CV_Professional_2024.pdf", "CV_Developer_2024.pdf"];
  String? selectedSavedCV;
  bool _isExpanded = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickCV() async {
    final XFile? file = await _picker.pickMedia();

    if (file != null) {
      setState(() {
        selectedCV = File(file.path);
        fileName = file.name;
        selectedSavedCV = null;
      });
    }
  }

  void _selectSavedCV(String cv) {
    setState(() {
      selectedSavedCV = cv;
      fileName = cv;
      selectedCV = null;
      _isExpanded = false;
    });
  }

  void _submitApplication() async {
    if (selectedCV == null && selectedSavedCV == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn CV để ứng tuyển'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      applicationStatus = "Đã được xem";
      isSubmitting = false;
    });

    // ignore: use_build_context_synchronously
    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              SizedBox(width: 10),
              Text("Thành công"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Đã gửi hồ sơ ứng tuyển thành công!",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Text(
                "Ngày gửi: ${_getFormattedDate()}",
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                "Trạng thái: $applicationStatus",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Đóng"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Trở về màn hình trước đó
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
              ),
              child: const Text("Quay lại tìm kiếm"),
            ),
          ],
        );
      },
    );
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ứng tuyển công việc",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue[800],
      ),
      body: Container(
        color: Colors.grey[50],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header with job info
            Container(
              color: Colors.blue[800],
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.jobTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.business, color: Colors.blue[100], size: 18),
                      const SizedBox(width: 8),
                      Text(
                        widget.companyName,
                        style: TextStyle(fontSize: 16, color: Colors.blue[100]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.blue[100],
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Vị trí #${widget.jobId}",
                        style: TextStyle(fontSize: 16, color: Colors.blue[100]),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Application Form
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Title
                  const Row(
                    children: [
                      Icon(Icons.description, color: Colors.blue, size: 24),
                      SizedBox(width: 10),
                      Text(
                        "Hồ sơ ứng tuyển",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 30),

                  // Selected CV
                  if (selectedCV != null || selectedSavedCV != null)
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  // ignore: deprecated_member_use
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 0,
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.insert_drive_file,
                              color: Colors.blue[700],
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fileName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Đã chọn",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 20,
                              color: Colors.red[400],
                            ),
                            onPressed: () {
                              setState(() {
                                selectedCV = null;
                                selectedSavedCV = null;
                                fileName = '';
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20),

                  // CV Upload Options
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _pickCV,
                          icon: const Icon(Icons.upload_file),
                          label: const Text("Tải lên CV mới"),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue[700],
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                          icon: const Icon(Icons.file_copy),
                          label: const Text("Chọn CV có sẵn"),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.blue[700],
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 1,
                            side: BorderSide(color: Colors.blue[700]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Saved CVs list
                  if (_isExpanded)
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children:
                            savedCVs
                                .map(
                                  (cv) => ListTile(
                                    leading: Icon(
                                      Icons.description,
                                      color: Colors.blue[700],
                                    ),
                                    title: Text(cv),
                                    trailing: const Icon(
                                      Icons.check_circle_outline,
                                    ),
                                    onTap: () => _selectSavedCV(cv),
                                    dense: true,
                                  ),
                                )
                                .toList(),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Cover Letter
                  const Text(
                    "Thư xin việc (tùy chọn)",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _coverLetterController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText:
                            "Viết thư giới thiệu về bản thân và mong muốn...",
                        contentPadding: EdgeInsets.all(16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Submit Button
                  ElevatedButton(
                    onPressed: isSubmitting ? null : _submitApplication,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue[800],
                      disabledBackgroundColor: Colors.blue[300],
                      minimumSize: const Size(double.infinity, 54),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child:
                        isSubmitting
                            ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  "Đang gửi...",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                            : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.send),
                                SizedBox(width: 8),
                                Text(
                                  "Gửi hồ sơ ứng tuyển",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                  ),
                ],
              ),
            ),

            // Application Tips
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber[200]!),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.amber),
                      SizedBox(width: 8),
                      Text(
                        "Mẹo ứng tuyển",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "• Đảm bảo CV của bạn được cập nhật những kỹ năng mới nhất",
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "• Viết thư xin việc phù hợp với vị trí bạn ứng tuyển",
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "• Nhà tuyển dụng thường phản hồi trong vòng 3-5 ngày làm việc",
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
