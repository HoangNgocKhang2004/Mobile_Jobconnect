class SaveCandidate {
  final String idUserRecruiter;
  final String idUserCandidate;
  final DateTime savedAt;
  final String? note;

  SaveCandidate({
    required this.idUserRecruiter,
    required this.idUserCandidate,
    required this.savedAt,
    this.note,
  });

  // From JSON
  factory SaveCandidate.fromJson(Map<String, dynamic> json) {
    return SaveCandidate(
      idUserRecruiter: json['idUserRecruiter'] as String,
      idUserCandidate: json['idUserCandidate'] as String,
      savedAt: DateTime.parse(json['savedAt'] as String),
      note: json['note'] as String?,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'idUserRecruiter': idUserRecruiter,
      'idUserCandidate': idUserCandidate,
      'savedAt': savedAt.toIso8601String(),
      'note': note ?? '', 
    };
  }
}