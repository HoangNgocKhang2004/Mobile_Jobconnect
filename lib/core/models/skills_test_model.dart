// Quản lý các bài kiểm tra kỹ năng cho ứng viên
// Chức năng: Tạo bài kiểm tra, đánh giá kỹ năng ứng viên, liên kết bài kiểm tra với công việc, lưu kết quả
import 'package:job_connect/core/models/question_model.dart';

class SkillsTestModel {
  String idTest; // Mã bài kiểm tra, ví dụ: IDS0001
  String testName; // Tên bài kiểm tra, ví dụ: "Kiểm tra lập trình Java"
  List<QuestionModel> questions; // Danh sách câu hỏi trong bài kiểm tra
  int passScore; // Điểm tối thiểu để đạt, ví dụ: 70
  String? idJobPost; // Mã bài đăng tuyển dụng liên kết, ví dụ: IDJP001, có thể null
  int? duration; // Thời gian làm bài (phút), ví dụ: 60, có thể null
  TestType testType; // Loại bài kiểm tra: technical, aptitude, personality, other
  DateTime createdAt; // Thời gian tạo bài kiểm tra
  DateTime updatedAt; // Thời gian cập nhật bài kiểm tra

  SkillsTestModel({
    required this.idTest,
    required this.testName,
    required this.questions,
    required this.passScore,
    this.idJobPost,
    this.duration,
    required this.testType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SkillsTestModel.fromMap(Map<String, dynamic> map) {
    return SkillsTestModel(
      idTest: map['idTest'] as String,
      testName: map['testName'] as String,
      questions: (map['questions'] as List<dynamic>)
          .map((q) => QuestionModel.fromMap(q as Map<String, dynamic>))
          .toList(),
      passScore: map['passScore'] as int,
      idJobPost: map['idJobPost'] as String?,
      duration: map['duration'] as int?,
      testType: TestType.values.firstWhere((e) => e.toString() == 'TestType.${map['testType']}'),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idTest': idTest,
      'testName': testName,
      'questions': questions.map((q) => q.toMap()).toList(),
      'passScore': passScore,
      'idJobPost': idJobPost,
      'duration': duration,
      'testType': testType.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'SkillsTestModel(idTest: $idTest, testName: $testName, passScore: $passScore, testType: $testType)';
  }
}

enum TestType { technical, aptitude, personality, other }