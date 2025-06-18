namespace HuitWorks.AdminWeb.Models.ViewModels
{
    public class InterviewScheduleViewModel
    {
        public string IdSchedule { get; set; }
        //public string IdJobApp { get; set; }
        public string IdJobPost { get; set; }   // Mới
        public string IdUser { get; set; }   // Mới
        public DateTime InterviewDate { get; set; }
        public string InterviewMode { get; set; }
        public string Location { get; set; }
        public string Interviewer { get; set; }
        public string Note { get; set; }

        // Thông tin từ JobApplication
        public string ApplicationStatus { get; set; }
        public string CandidateName { get; set; }
        public string CandidateEmail { get; set; }

        // Thông tin Job Posting
        public string JobTitle { get; set; }
        public string JobDescription { get; set; }

        // Thông tin Recruiter
        public string RecruiterName { get; set; }
    }
}
