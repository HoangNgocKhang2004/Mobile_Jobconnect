namespace HuitWorks.RecruiterWeb.Models
{
    // DTO nhận từ API /api/CandidateEvaluation
    public class CandidateEvaluationDto
    {
        public string EvaluationId { get; set; }
        public string IdJobPost { get; set; }
        public string IdCandidate { get; set; }
        public string IdRecruiter { get; set; }
        public DateTime CreatedAt { get; set; }
    }

    // DTO nhận từ API /api/EvaluationCriteria
    public class EvaluationCriteriaDto
    {
        public string CriterionId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public DateTime CreatedAt { get; set; }
    }

    // DTO nhận từ API /api/EvaluationDetail
    public class EvaluationDetailDto
    {
        public string EvaluationDetailId { get; set; }
        public string EvaluationId { get; set; }
        public string CriterionId { get; set; }
        public int Score { get; set; }
        public string Comments { get; set; }
    }

    // Item cho mỗi tiêu chí trong form đánh giá
    public class EvaluateCandidateItem
    {
        public string CriterionId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string EvaluationDetailId { get; set; }
        public int Score { get; set; }
        public string Comments { get; set; }
    }

    // ViewModel tổng hợp cho form đánh giá
    public class EvaluateCandidateViewModel
    {
        public string EvaluationId { get; set; }
        public string IdJobPost { get; set; }
        public string IdCandidate { get; set; }
        public string IdRecruiter { get; set; }
        public List<EvaluateCandidateItem> Items { get; set; }
    }
}
