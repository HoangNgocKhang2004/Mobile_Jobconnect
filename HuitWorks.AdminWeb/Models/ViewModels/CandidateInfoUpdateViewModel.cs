namespace HuitWorks.AdminWeb.Models.ViewModels
{
    public class CandidateInfoUpdateViewModel
    {
        public string IdUser { get; set; }
        public string WorkPosition { get; set; }
        public double? RatingScore { get; set; }
        public string UniversityName { get; set; }
        public string EducationLevel { get; set; }
        public int? ExperienceYears { get; set; }
        public string Skills { get; set; }

        public UserViewModel User { get; set; }
    }
}
