import 'dart:core';

class InterviewSchedule {
  String? id; // ID duy nhất của lịch phỏng vấn
  int applicationId; // ID của đơn ứng tuyển liên quan
  int employerId; // ID của nhà tuyển dụng (hoặc người phỏng vấn cụ thể)
  DateTime interviewTime; // Thời gian diễn ra phỏng vấn
  String location; // Địa điểm (Văn phòng ABC, Link Google Meet, ...)
  String? interviewerName; // Tên người phỏng vấn (nếu cần)
  String? notes; // Ghi chú cho buổi phỏng vấn
  String status; // Trạng thái (Scheduled, Completed, Cancelled, Rescheduled)

  InterviewSchedule({
    required this.id,
    required this.applicationId,
    required this.employerId,
    required this.interviewTime,
    required this.location,
    this.interviewerName,
    this.notes,
    required this.status,
  });

  // Chuyển đổi từ InterviewSchedule object sang Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'applicationId': applicationId,
      'employerId': employerId,
      'interviewTime': interviewTime.toIso8601String(),
      'location': location,
      'interviewerName': interviewerName,
      'notes': notes,
      'status': status,
    };
  }

  // Chuyển đổi từ Map sang InterviewSchedule object
  factory InterviewSchedule.fromMap(Map<String, dynamic> map) {
    return InterviewSchedule(
      id: map['id'],
      applicationId: map['applicationId'],
      employerId: map['employerId'],
      interviewTime: DateTime.parse(map['interviewTime']),
      location: map['location'],
      interviewerName: map['interviewerName'],
      notes: map['notes'],
      status: map['status'],
    );
  }
}
