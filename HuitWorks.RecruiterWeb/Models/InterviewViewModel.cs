namespace HuitWorks.RecruiterWeb.Models
{
    public class InterviewViewModel
    {
        public int Id { get; set; }
        public string CandidateName { get; set; }
        public string CandidateEmail { get; set; }
        public string PositionTitle { get; set; }
        public DateTime InterviewDateTime { get; set; }
        public string Mode { get; set; }    // "Online" hoặc "Offline"
        public string Status { get; set; }  // "Đang chờ", "Đã hoàn thành", "Hủy"
        public string Location { get; set; } // Địa điểm phỏng vấn (nếu là Offline)
        public string MeetingUrl { get; set; } // Link meeting (nếu là Online)
        public string InterviewerName { get; set; } // Người phỏng vấn
        public string Notes { get; set; } // Ghi chú về cuộc phỏng vấn
    }
}