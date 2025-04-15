// Lưu trữ lịch sử tìm kiếm công việc của người dùng
// Chức năng: Tìm kiếm công việc, lưu kết quả tìm kiếm
class SearchHistoryModel {
  String idSearch; // Mã tìm kiếm, ví dụ: IDS001
  String idUser; // Mã người dùng, ví dụ: ID lcU001
  String query; // Từ khóa tìm kiếm, ví dụ: "Lập trình viên Java"
  Map<String, dynamic> filters; // Bộ lọc, ví dụ: {"location": "Hà Nội", "salary": 1000}
  DateTime searchedAt; // Thời gian thực hiện tìm kiếm

  SearchHistoryModel({
    required this.idSearch,
    required this.idUser,
    required this.query,
    required this.filters,
    required this.searchedAt,
  });

  factory SearchHistoryModel.fromMap(Map<String, dynamic> map) {
    return SearchHistoryModel(
      idSearch: map['idSearch'] as String,
      idUser: map['idUser'] as String,
      query: map['query'] as String,
      filters: map['filters'] as Map<String, dynamic>,
      searchedAt: DateTime.parse(map['searchedAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idSearch': idSearch,
      'idUser': idUser,
      'query': query,
      'filters': filters,
      'searchedAt': searchedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'SearchHistoryModel(idSearch: $idSearch, idUser: $idUser, query: $query)';
  }
}