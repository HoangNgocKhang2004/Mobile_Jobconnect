// Model for resumeSkills table
class ResumeSkill {
  final String idResume;
  final String skill;

  ResumeSkill({
    required this.idResume,
    required this.skill,
  });

  Map<String, dynamic> toJson() {
    return {
      'idResume': idResume,
      'skill': skill,
    };
  }

  factory ResumeSkill.fromJson(Map<String, dynamic> json) {
    return ResumeSkill(
      idResume: json['idResume'] as String,
      skill: json['skill'] as String,
    );
  }

  @override
  String toString() {
    return 'ResumeSkill(idResume: $idResume, skill: $skill)';
  }
}