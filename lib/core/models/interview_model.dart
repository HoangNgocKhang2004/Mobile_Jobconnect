// InterviewModel - Quản lý lịch phỏng vấn
class InterviewModel {
  String idInterview; // Mã lịch phỏng vấn - IDI001
  String idJobApp; // ID ứng tuyển (liên kết với model JobApplication)
  DateTime interviewTime; // Thời gian phỏng vấn
  InterviewMode interviewMode; // Hình thức phỏng vấn
  InterviewStatus interviewStatus; // Trạng thái phỏng vấn
  DateTime createdAt; // Thời gian tạo lịch phỏng vấn
  DateTime updatedAt; // Thời gian cập nhật lịch phỏng vấn

  // Constructor với các tham số required
  InterviewModel({
    required this.idInterview,
    required this.idJobApp,
    required this.interviewTime,
    required this.interviewMode,
    required this.interviewStatus,
    required this.createdAt,
    required this.updatedAt,
  })  : assert(idInterview.isNotEmpty, 'idInterview must not be empty'),
        assert(idJobApp.isNotEmpty, 'idJobApp must not be empty');

  // Factory constructor từ Map
  factory InterviewModel.fromMap(Map<String, dynamic> map) {
    return InterviewModel(
      idInterview: map['idInterview'] as String? ?? 'IDI000',
      idJobApp: map['idJobApp'] as String? ?? 'IDJA000',
      interviewTime: DateTime.tryParse(map['interviewTime'] as String? ?? '') ?? DateTime(1970, 1, 1),
      interviewMode: _parseInterviewMode(map['interviewMode']),
      interviewStatus: _parseInterviewStatus(map['interviewStatus']),
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime(1970, 1, 1),
      updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? '') ?? DateTime(1970, 1, 1),
    );
  }

  // Chuyển đổi sang Map
  Map<String, dynamic> toMap() {
    return {
      'idInterview': idInterview,
      'idJobApp': idJobApp,
      'interviewTime': interviewTime.toIso8601String(),
      'interviewMode': interviewMode.name,
      'interviewStatus': interviewStatus.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Hàm phụ trợ để parse InterviewMode
  static InterviewMode _parseInterviewMode(dynamic value) {
    if (value is String) {
      return InterviewMode.values.firstWhere(
        (e) => e.name == value,
        orElse: () => InterviewMode.Unknown,
      );
    }
    return InterviewMode.Unknown;
  }

  // Hàm phụ trợ để parse InterviewStatus
  static InterviewStatus _parseInterviewStatus(dynamic value) {
    if (value is String) {
      return InterviewStatus.values.firstWhere(
        (e) => e.name == value,
        orElse: () => InterviewStatus.Unknown,
      );
    }
    return InterviewStatus.Unknown;
  }

  // Override toString để dễ debug
  @override
  String toString() {
    return 'InterviewModel(idInterview: $idInterview, idJobApp: $idJobApp, '
        'interviewTime: $interviewTime, interviewMode: $interviewMode, '
        'interviewStatus: $interviewStatus, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

// Enum cho hình thức phỏng vấn
enum InterviewMode { Online, Offline, Unknown }
//Online: hình thức trực tuyến (Call video/Zoom)
//Offline: hình thức trực tiếp

// Enum cho trạng thái phỏng vấn
enum InterviewStatus { Pending, Completed, Canceled, Unknown }
//Pending: chưa giải quyết
//Completed: hoàn thành
//Canceled: hủy