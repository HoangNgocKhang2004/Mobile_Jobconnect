namespace HuitWorks.AdminWeb.Models
{
    public class CandidateEvaluationListItem
    {
        public string EvaluationId { get; set; }
        public string IdJobPost { get; set; }
        public string IdCandidate { get; set; }
        public string IdRecruiter { get; set; }
        public DateTime CreatedAt { get; set; }
        public double AverageScore { get; set; }

        public string Status { get; set; }
    }
}
