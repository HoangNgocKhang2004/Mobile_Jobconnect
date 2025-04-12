// SkillTest - Kiểm tra kỹ năng ứng viên
import 'package:job_connect/core/models/question_model.dart';

class SkillsTestModel {
  String idTest; // Mã bài kiểm tra - IDS0001
  String testName; // Tên bài kiểm tra
  List<QuestionModel> questions; // Danh sách câu hỏi
  int passScore; // Điểm đạt
  DateTime createdAt; // Thời gian tạo bài kiểm tra
  DateTime updatedAt; // Thời gian cập nhật bài kiểm tra

  // Constructor với các tham số required
  SkillsTestModel({
    required this.idTest,
    required this.testName,
    required this.questions,
    required this.passScore,
    required this.createdAt,
    required this.updatedAt,
  })  : assert(passScore >= 0, 'Pass score must be non-negative'),
        assert(idTest.isNotEmpty, 'idTest must not be empty');

  // Factory constructor từ Map
  factory SkillsTestModel.fromMap(Map<String, dynamic> map) {
    return SkillsTestModel(
      idTest: map['idTest'] as String? ?? 'IDT000',
      testName: map['testName'] as String? ?? 'Unknown',
      questions: (map['questions'] as List<dynamic>?)
              ?.map((e) => QuestionModel.fromMap(e as Map<String, dynamic>))
              .toList() ?? [],
      passScore: (map['passScore'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime(1970, 1, 1),
      updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? '') ?? DateTime(1970, 1, 1),
    );
  }

  // Chuyển đổi sang Map
  Map<String, dynamic> toMap() {
    return {
      'idTest': idTest,
      'testName': testName,
      'questions': questions.map((q) => q.toMap()).toList(),
      'passScore': passScore,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Override toString để dễ debug
  @override
  String toString() {
    return 'SkillsTestModel(idTest: $idTest, testName: $testName, questions: $questions, '
        'passScore: $passScore, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}