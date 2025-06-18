namespace HuitWorks.AdminWeb.Models.ViewModels
{
    public class JobPostingViewModel
    {
        public string IdJobPost { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string Requirements { get; set; }
        public decimal Salary { get; set; }
        public string Location { get; set; }
        public string JobType { get; set; }
        public string ExperienceLevel { get; set; }
        public string IdCompany { get; set; }
        public DateTime ApplicationDeadline { get; set; }
        public string Benefits { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public string postStatus { get; set; }

        // Có thể load thêm sau
        public string? CompanyName { get; set; }
        public List<string>? RequiredSkills { get; set; }
        public CompanyViewModel Company { get; set; }

    }
}
