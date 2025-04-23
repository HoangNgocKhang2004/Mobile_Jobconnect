class QuestionModel {
  String content; // Nội dung câu hỏi
  String? correctAnswer; // Đáp án đúng (có thể null nếu chưa xác định)
  List<String>? options; // Các lựa chọn (dành cho trắc nghiệm, có thể null)
  int score; // Điểm số của câu hỏi

  QuestionModel({
    required this.content,
    this.correctAnswer,
    this.options,
    required this.score,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      content: map['content'] as String? ?? '',
      correctAnswer: map['correctAnswer'] as String?,
      options: (map['options'] as List<dynamic>?)?.map((e) => e as String).toList(),
      score: (map['score'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'correctAnswer': correctAnswer,
      'options': options,
      'score': score,
    };
  }

  @override
  String toString() {
    return 'QuestionModel(content: $content, correctAnswer: $correctAnswer, options: $options, score: $score)';
  }
}