namespace HuitWorks.RecruiterWeb.Models.ViewModel
{
    public class CandidateInfoViewModel
    {
        // API trả về
        public string IdUser { get; set; }
        public string WorkPosition { get; set; }
        public double RatingScore { get; set; }
        public string UniversityName { get; set; }
        public string EducationLevel { get; set; }
        public int ExperienceYears { get; set; }
        public string Skills { get; set; }

        // Gán thêm
        public UserViewModel User { get; set; }
        public List<CandidateApplicationViewModel> Applications { get; set; } = new();
    }
}
