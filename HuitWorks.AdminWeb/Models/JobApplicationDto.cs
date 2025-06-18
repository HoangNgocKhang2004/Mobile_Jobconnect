namespace HuitWorks.AdminWeb.Models
{
    public class JobApplicationDto
    {
        public string IdJobPost { get; set; }
        public string IdUser { get; set; }
        public string CvFileUrl { get; set; }
        public string CoverLetter { get; set; }
        public string ApplicationStatus { get; set; }
        public DateTime SubmittedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
    }

}
