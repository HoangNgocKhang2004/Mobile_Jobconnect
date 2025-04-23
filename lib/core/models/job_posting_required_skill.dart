// Model for jobPostingRequiredSkills table
class JobPostingRequiredSkill {
  final String idJobPost;
  final String skill;

  JobPostingRequiredSkill({
    required this.idJobPost,
    required this.skill,
  });

  Map<String, dynamic> toJson() {
    return {
      'idJobPost': idJobPost,
      'skill': skill,
    };
  }

  factory JobPostingRequiredSkill.fromJson(Map<String, dynamic> json) {
    return JobPostingRequiredSkill(
      idJobPost: json['idJobPost'] as String,
      skill: json['skill'] as String,
    );
  }

  @override
  String toString() {
    return 'JobPostingRequiredSkill(idJobPost: $idJobPost, skill: $skill)';
  }
}
