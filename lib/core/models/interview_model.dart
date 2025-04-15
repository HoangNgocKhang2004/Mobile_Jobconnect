// Quản lý lịch phỏng vấn giữa nhà tuyển dụng và ứng viên
// Chức năng: Lên lịch phỏng vấn, cập nhật trạng thái, lưu thông tin người phỏng vấn
class InterviewModel {
  String idInterview; // Mã lịch phỏng vấn, ví dụ: IDI001
  String idJobApp; // Mã đơn ứng tuyển, ví dụ: IDJA001
  String idEmployer; // Mã nhà tuyển dụng, ví dụ: IDU002
  DateTime interviewTime; // Thời gian phỏng vấn
  InterviewMode interviewMode; // Hình thức: online, in_person
  InterviewStatus interviewStatus; // Trạng thái: scheduled, completed, cancelled, rescheduled
  String? interviewerName; // Tên người phỏng vấn, ví dụ: "Nguyễn Văn A", có thể null
  String? location; // Địa điểm hoặc link họp, ví dụ: "Google Meet", có thể null
  String? notes; // Ghi chú, ví dụ: "Chuẩn bị bài kiểm tra", có thể null
  DateTime createdAt; // Thời gian tạo lịch
  DateTime updatedAt; // Thời gian cập nhật lịch

  InterviewModel({
    required this.idInterview,
    required this.idJobApp,
    required this.idEmployer,
    required this.interviewTime,
    required this.interviewMode,
    required this.interviewStatus,
    this.interviewerName,
    this.location,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InterviewModel.fromMap(Map<String, dynamic> map) {
    return InterviewModel(
      idInterview: map['idInterview'] as String,
      idJobApp: map['idJobApp'] as String,
      idEmployer: map['idEmployer'] as String? ?? (throw ArgumentError('idEmployer cannot be null')),      interviewMode: InterviewMode.values.firstWhere((e) => e.toString() == 'InterviewMode.${map['interviewMode']}'),
      interviewTime: DateTime.tryParse(map['interviewTime'] as String? ?? '') ??
            (throw ArgumentError('Invalid interviewTime')),
      interviewStatus: InterviewStatus.values.firstWhere((e) => e.toString() == 'InterviewStatus.${map['interviewStatus']}'),
      interviewerName: map['interviewerName'] as String?,
      location: map['location'] as String?,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idInterview': idInterview,
      'idJobApp': idJobApp,
      'idEmployer': idEmployer,
      'interviewTime': interviewTime.toIso8601String(),
      'interviewMode': interviewMode.toString().split('.').last,
      'interviewStatus': interviewStatus.toString().split('.').last,
      'interviewerName': interviewerName,
      'location': location,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'InterviewModel(idInterview: $idInterview, idJobApp: $idJobApp, interviewStatus: $interviewStatus)';
  }
}

enum InterviewMode { online, in_person }
enum InterviewStatus { scheduled, completed, cancelled, rescheduled }