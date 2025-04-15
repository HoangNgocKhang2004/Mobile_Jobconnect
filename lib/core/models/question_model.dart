// Quản lý câu hỏi trong bài kiểm tra kỹ năng
// Chức năng: Tạo/sửa câu hỏi, thiết lập đáp án và điểm số, hỗ trợ bài kiểm tra trắc nghiệm hoặc tự luận
class QuestionModel {
  String idQuestion; // Mã câu hỏi, ví dụ: IDQ001
  String content; // Nội dung câu hỏi, ví dụ: "Hàm main trong Java là gì?"
  String? correctAnswer; // Đáp án đúng, ví dụ: "void main()", có thể null
  List<String>? options; // Lựa chọn trắc nghiệm, ví dụ: ["A", "B", "C"], có thể null
  int score; // Điểm cho câu hỏi, ví dụ: 10
  QuestionType questionType; // Loại câu hỏi: multiple_choice, open_ended, coding, other

  QuestionModel({
    required this.idQuestion,
    required this.content,
    this.correctAnswer,
    this.options,
    required this.score,
    required this.questionType,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      idQuestion: map['idQuestion'] as String,
      content: map['content'] as String,
      correctAnswer: map['correctAnswer'] as String?,
      options: (map['options'] as List<dynamic>?)?.cast<String>(),
      score: map['score'] as int,
      questionType: QuestionType.values.firstWhere((e) => e.toString() == 'QuestionType.${map['questionType']}'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idQuestion': idQuestion,
      'content': content,
      'correctAnswer': correctAnswer,
      'options': options,
      'score': score,
      'questionType': questionType.toString().split('.').last,
    };
  }

  @override
  String toString() {
    return 'QuestionModel(idQuestion: $idQuestion, content: $content, questionType: $questionType)';
  }
}

enum QuestionType { multiple_choice, open_ended, coding, other }