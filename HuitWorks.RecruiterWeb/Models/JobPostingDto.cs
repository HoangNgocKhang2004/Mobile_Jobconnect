namespace HuitWorks.RecruiterWeb.Models
{
    public class JobPostingDto
    {
        public string IdJobPost { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string Requirements { get; set; }
        public decimal Salary { get; set; }
        public string Location { get; set; }
        public string WorkType { get; set; }
        public string ExperienceLevel { get; set; }
        public string IdCompany { get; set; }
        public DateTime ApplicationDeadline { get; set; }
        public string Benefits { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public int IsFeatured { get; set; }
        public string PostStatus { get; set; }

        public CompanyDto Company { get; set; }
    }
}
