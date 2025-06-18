namespace HuitWorks.RecruiterWeb.Models.ViewModel
{
    public class InterviewViewModel
    {
        public string? Id { get; set; }
        public string? CandidateName { get; set; }
        public string? CandidateEmail { get; set; }
        public string? PositionTitle { get; set; }
        public DateTime? InterviewDateTime { get; set; }
        public string? Mode { get; set; }
        //public string Status { get; set; }
        public string? Location { get; set; }
        public string? Interviewer { get; set; }
        public string? Note { get; set; }
        public bool HasPassed { get; set; }
    }
}
