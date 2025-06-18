namespace HuitWorks.AdminWeb.Models.ViewModels
{
    public class ResumeViewModel
    {
        public string? IdResume { get; set; }
        public string? IdUser { get; set; }
        public string? FileUrl { get; set; }
        public string? FileName { get; set; }
        public int? FileSizeKB { get; set; }
        public int? IsDefault { get; set; }
        public DateTime? CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }

        public List<ResumeSkillViewModel>? ResumeSkills { get; set; } = new();

    }

    public class ResumeSkillViewModel
    {
        public string? IdResume { get; set; }
        public string? Skill { get; set; }
        public string? Proficiency { get; set; }
    }
}
