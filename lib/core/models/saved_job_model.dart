// Quản lý danh sách công việc được ứng viên lưu
// Chức năng: Lưu tin tuyển dụng để xem sau
class SavedJobModel {
  String idSavedJob; // Mã công việc đã lưu, ví dụ: IDSJ001
  String idUser; // Mã người dùng lưu công việc, ví dụ: IDU001
  String idJobPost; // Mã bài đăng, ví dụ: IDJP001
  DateTime savedAt; // Thời gian lưu công việc

  SavedJobModel({
    required this.idSavedJob,
    required this.idUser,
    required this.idJobPost,
    required this.savedAt,
  });

  factory SavedJobModel.fromMap(Map<String, dynamic> map) {
    return SavedJobModel(
      idSavedJob: map['idSavedJob'] as String,
      idUser: map['idUser'] as String,
      idJobPost: map['idJobPost'] as String,
      savedAt: DateTime.parse(map['savedAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idSavedJob': idSavedJob,
      'idUser': idUser,
      'idJobPost': idJobPost,
      'savedAt': savedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'SavedJobModel(idSavedJob: $idSavedJob, idUser: $idUser, idJobPost: $idJobPost)';
  }
}