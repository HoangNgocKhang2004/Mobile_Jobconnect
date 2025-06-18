namespace HuitWorks.AdminWeb.Models.ViewModels
{
    public class CandidateInfoViewModel
    {
        public string? IdUser { get; set; }
        public string? WorkPosition { get; set; }
        public double? RatingScore { get; set; }
        public string? UniversityName { get; set; }
        public string? EducationLevel { get; set; }
        public int? ExperienceYears { get; set; }
        public string? Skills { get; set; }

        public UserViewModel? User { get; set; }

        public List<InterviewScheduleViewModel> InterviewSchedules { get; set; }
            = new List<InterviewScheduleViewModel>();
        public string? FirstScheduleId
            => InterviewSchedules?.FirstOrDefault()?.IdSchedule;

        public string? ResumeUrl { get; set; }
    }
}
