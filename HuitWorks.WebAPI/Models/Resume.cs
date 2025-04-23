namespace HuitWorks.WebAPI.Models
{
    public class Resume
    {
        public string IdResume { get; set; } = null!;
        public string IdUser { get; set; } = null!;
        public string Experience { get; set; } = null!;
        public string Education { get; set; } = null!;
        public string? Portfolio { get; set; }
        public string? CvFileUrl { get; set; }
        public bool IsPublic { get; set; }
        public decimal? SuitabilityScore { get; set; }
        public string? PreferredJobType { get; set; }
        public decimal? SalaryExpectation { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }

        public User User { get; set; } = null!;
        public List<ResumeSkill> Skills { get; set; } = new();
    }
}
