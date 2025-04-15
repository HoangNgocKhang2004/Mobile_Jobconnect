// Lưu trữ dữ liệu phân tích cho xu hướng tuyển dụng và biểu đồ lương
// Chức năng: Biểu đồ so sánh lương trung bình, phân tích xu hướng tuyển dụng
class AnalyticsModel {
  String idAnalytics; // Mã phân tích, ví dụ: IDA001
  String industry; // Ngành nghề, ví dụ: "Công nghệ"
  double averageSalary; // Lương trung bình, ví dụ: 1500.0
  int jobCount; // Số lượng công việc, ví dụ: 100
  DateTime lastUpdated; // Thời gian cập nhật dữ liệu

  AnalyticsModel({
    required this.idAnalytics,
    required this.industry,
    required this.averageSalary,
    required this.jobCount,
    required this.lastUpdated,
  });

  factory AnalyticsModel.fromMap(Map<String, dynamic> map) {
    return AnalyticsModel(
      idAnalytics: map['idAnalytics'] as String,
      industry: map['industry'] as String,
      averageSalary: (map['averageSalary'] as num).toDouble(),
      jobCount: map['jobCount'] as int,
      lastUpdated: DateTime.parse(map['lastUpdated'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idAnalytics': idAnalytics,
      'industry': industry,
      'averageSalary': averageSalary,
      'jobCount': jobCount,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'AnalyticsModel(idAnalytics: $idAnalytics, industry: $industry, averageSalary: $averageSalary)';
  }
}