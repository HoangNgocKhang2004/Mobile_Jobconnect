namespace HuitWorks.RecruiterWeb.Models.ViewModel
{
    public class CandidateResumeViewModel
    {
        // --- Thông tin cơ bản của ứng viên (tương tự CandidateInfoViewModel) ---
        public string IdUser { get; set; } = null!;
        public string UserName { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string WorkPosition { get; set; } = null!;
        public int ExperienceYears { get; set; }
        public string EducationLevel { get; set; } = null!;
        public string UniversityName { get; set; } = null!;
        public string Skills { get; set; } = null!; // ví dụ: "C#, Java, SQL"

        // --- Thông tin CV ---
        public string IdResume { get; set; } = null!;
        public string FileName { get; set; } = null!;
        public string FileUrl { get; set; } = null!; // Đường dẫn trực tiếp tới PDF
        public int FileSizeKB { get; set; }

        // Nếu muốn hiển thị thêm thông tin trình độ kỹ năng chi tiết:
        public List<ResumeSkillDto>? SkillDetails { get; set; }
    }

    // Giả sử ResumeSkillDto trông giống thế này:
    public class ResumeSkillDto
    {
        public string IdResume { get; set; } = null!;
        public string Skill { get; set; } = null!;

        // Chuyển về string
        public string Proficiency { get; set; } = "0";
    }
    // File: Models/Dtos/CandidateInfoDto.cs
    public class CandidateInfoDto
    {
        public string IdUser { get; set; } = null!;
        public string UserName { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string WorkPosition { get; set; } = null!;
        public int ExperienceYears { get; set; }
        public string EducationLevel { get; set; } = null!;
        public string UniversityName { get; set; } = null!;
        public string Skills { get; set; } = null!; // ex: “C#, Java, SQL”
    }
    public class UserResumeDto
    {
        public string? IdUser { get; set; }
        public string? UserName { get; set; }
        public string? Email { get; set; }
        // (các trường khác nếu cần)
    }
}
