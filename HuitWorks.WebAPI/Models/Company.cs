namespace HuitWorks.WebAPI.Models
{
    public class Company
    {
        public string IdCompany { get; set; } = null!;  // NOT NULL
        public string CompanyName { get; set; } = null!;  // NOT NULL
        public string Address { get; set; } = null!;  // NOT NULL
        public string? Description { get; set; }
        public string? LogoUrl { get; set; }
        public string? WebsiteUrl { get; set; }

        public string Scale { get; set; } = null!;  // NOT NULL
        public List<RecruiterInfo> Recruiters { get; set; } = new();
        public List<JobPosting> JobPostings { get; set; } = new();
    }
}
