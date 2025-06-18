using System.Text.Json.Serialization;

namespace HuitWorks.RecruiterWeb.Models.ViewModel
{
    public class JobApplicationViewModel
    {
        [JsonPropertyName("idJobPost")]
        public string IdJobPost { get; set; } = null!;

        [JsonPropertyName("idUser")]
        public string IdUser { get; set; } = null!;

        [JsonPropertyName("cvFileUrl")]
        public string? CvFileUrl { get; set; }

        [JsonPropertyName("coverLetter")]
        public string? CoverLetter { get; set; }

        [JsonPropertyName("applicationStatus")]
        public string ApplicationStatus { get; set; } = null!;

        [JsonPropertyName("submittedAt")]
        public DateTime SubmittedAt { get; set; }

        [JsonPropertyName("updatedAt")]
        public DateTime UpdatedAt { get; set; }

        // Nếu API trả về jobPosting object, bạn có thể thêm field:
        // [JsonPropertyName("jobPosting")]
        // public JobPostingViewModel? JobPosting { get; set; }
    }
}
