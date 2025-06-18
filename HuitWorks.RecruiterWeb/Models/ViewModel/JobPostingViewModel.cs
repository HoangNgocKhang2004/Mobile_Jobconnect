using Newtonsoft.Json;

namespace HuitWorks.RecruiterWeb.Models.ViewModel
{
    public class JobPostingViewModel
    {
        [JsonProperty("idJobPost")]
        public string? IdJobPost { get; set; }

        [JsonProperty("title")]
        public string? Title { get; set; }

        [JsonProperty("description")]
        public string? Description { get; set; }

        [JsonProperty("requirements")]
        public string? Requirements { get; set; }

        // Thay đổi ở đây
        [JsonProperty("salary")]
        public decimal Salary { get; set; }

        [JsonProperty("location")]
        public string? Location { get; set; }

        [JsonProperty("applicationDeadline")]
        public DateTime ApplicationDeadline { get; set; }

        [JsonProperty("createdAt")]
        public DateTime CreatedAt { get; set; }

        [JsonProperty("postStatus")]
        public string? PostStatus { get; set; }
        public string? IdCompany { get; set; }

        [JsonProperty("company")]
        public CompanyViewModel? Company { get; set; }

        [JsonIgnore]
        public bool IsActive => PostStatus == "open";

        [JsonIgnore]
        public DateTime PostedDate => CreatedAt;

        [JsonIgnore]
        public DateTime ExpiryDate => ApplicationDeadline;
    }

}
