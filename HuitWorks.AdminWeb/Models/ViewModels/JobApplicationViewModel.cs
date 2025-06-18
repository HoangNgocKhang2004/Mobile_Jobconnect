namespace HuitWorks.AdminWeb.Models.ViewModels
{
    public class JobApplicationViewModel
    {
        public string IdUser { get; set; }
        public string IdJobPost { get; set; }
        public string CvFileUrl { get; set; }
        public string CoverLetter { get; set; }
        public string ApplicationStatus { get; set; }
        public DateTime SubmittedAt { get; set; }

        // Tên được gán trong controller
        public string CandidateName { get; set; }
        public string JobTitle { get; set; }

        public string CompanyName { get; set; }

    }
}
