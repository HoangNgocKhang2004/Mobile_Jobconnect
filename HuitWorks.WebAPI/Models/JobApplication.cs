namespace HuitWorks.WebAPI.Models
{
    public class JobApplication
    {
        public string IdJobApp { get; set; } = null!;
        public string IdJobPost { get; set; } = null!;
        public string IdUser { get; set; } = null!;
        public string? CvFileUrl { get; set; }
        public string? CoverLetter { get; set; }
        public decimal? SuitabilityScore { get; set; }
        public string JobApplicationStatus { get; set; } = null!;
        public DateTime SubmittedAt { get; set; }
        public DateTime UpdatedAt { get; set; }

        public JobPosting JobPosting { get; set; } = null!;
        public User User { get; set; } = null!;
    }
}
