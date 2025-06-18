namespace HuitWorks.RecruiterWeb.Models.ViewModel
{
    public class CandidateDetailViewModel
    {
        public string IdUser { get; set; } = "";
        public string UserName { get; set; } = "";
        public string Email { get; set; } = "";
        public string? PhoneNumber { get; set; }
        public string? Address { get; set; }

        // Từ CandidateInfo
        public string WorkPosition { get; set; } = "";
        public double RatingScore { get; set; }
        public string UniversityName { get; set; } = "";
        public string EducationLevel { get; set; } = "";
        public int ExperienceYears { get; set; }
        public string Skills { get; set; } = "";
    }
}
