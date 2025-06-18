namespace HuitWorks.RecruiterWeb.Models.ViewModel
{
    public class SavedResumeViewModel
    {
        public string IdSave { get; set; }
        public string IdRecruiter { get; set; }
        public string CandidateId { get; set; }
        public string CandidateName { get; set; }
        public string CandidateEmail { get; set; }
        public DateTime SavedAt { get; set; }

        public string? WorkPosition { get; set; }
        public int ExperienceYears { get; set; }
        public string? Education { get; set; }
        public string? Skills { get; set; }
    }
}
