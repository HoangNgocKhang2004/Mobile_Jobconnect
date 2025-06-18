using System.Text.Json.Serialization;

namespace HuitWorks.RecruiterWeb.Models
{
    public class InterviewScheduleDto
    {
        public string IdSchedule { get; set; }
        public string IdJobPost { get; set; }
        [JsonPropertyName("idUser")]
        public string IdUser { get; set; }
        public DateTime InterviewDate { get; set; }
        public string InterviewMode { get; set; }
        public string Location { get; set; }
        public string Interviewer { get; set; }
        public string Note { get; set; }
    }
}
