namespace HuitWorks.RecruiterWeb.Models.ViewModel
{
    public class InterviewScheduleViewModel
    {
        public string IdSchedule { get; set; }
        public string IdUser { get; set; }
        public string IdJobPost { get; set; }
        public string CandidateName { get; set; }
        public DateTime InterviewDate { get; set; }
        public string InterviewTime { get; set; }
        public string InterviewMode { get; set; }
        public string Location { get; set; }
        public string Note { get; set; }
        public string PositionTitle { get; set; }
        public string Interviewer { get; set; }
    }
}
