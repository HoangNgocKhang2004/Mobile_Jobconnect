namespace HuitWorks.WebAPI.Models
{
    public class JobPosting
    {
        public string IdJobPost { get; set; } = null!;
        public string Title { get; set; } = null!;
        public string Description { get; set; } = null!;
        public string Requirements { get; set; } = null!;
        public decimal? Salary { get; set; }   // NULLable
        public string Location { get; set; } = null!;
        public string JobType { get; set; } = null!;
        public string ExperienceLevel { get; set; } = null!;
        public string IdCompany { get; set; } = null!;
        public DateTime? ApplicationDeadline { get; set; }
        public string? Benefits { get; set; }

        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public string JobPostStatus { get; set; } = null!;

        public Company Company { get; set; } = null!;
        public List<JobPostingRequiredSkill> RequiredSkills { get; set; } = new();
        public List<JobApplication> Applications { get; set; } = new();
    }
}
